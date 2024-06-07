import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysmax_playground/app_text_styles.dart';

class CustomDropDown<T> extends StatelessWidget {
  final T selectedValue;
  final void Function(T? newValue) onChanged;
  final List<T> items;
  final bool fixWidth;
  final bool enabled;
  final String? disabledHint;

  const CustomDropDown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    this.fixWidth = true,
    this.enabled = true,
    this.disabledHint,
  });

  @override
  Widget build(BuildContext context) {
    if(enabled == false) {
      return _disableWidget();
    }

    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(width: 1, color: const Color(0xFFE9ECF5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<T>(
        value: selectedValue,
        onChanged: onChanged,
        padding: const EdgeInsets.fromLTRB(11, 0, 9, 0),
        style: AppTextStyles.size12Regular.singleLine.copyWith(letterSpacing: -0.36),
        items: items.map<DropdownMenuItem<T>>(
          (T value) => DropdownMenuItem<T>(
            value: value,
            child: Container(
              width: fixWidth ? 26 : null,
              margin: const EdgeInsets.only(right: 7),
              alignment: Alignment.centerLeft,
              child: Text(
                value.toString(),
              ),
            ),
          ),
        ).toList(),
        icon: SvgPicture.asset(
          'assets/icons/dropdown_button_icon.svg',
        ),
        iconSize: 42,
        underline: const SizedBox.shrink(),
      ),
    );
  }

  Widget _disableWidget() {
    return Container(
      width: disabledHint != null ? null : 56,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECF5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: disabledHint != null
          ? Row(
        children: [
          Text(
            disabledHint!,
            style: AppTextStyles.size12Regular.singleLine.copyWith(
              letterSpacing: -0.36,
              height: 26 / 12,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/dropdown_button_icon.svg',
          ),
        ],
      ) : null,
    );
  }
}