import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysmax_playground/app_text_styles.dart';

/// TODO: validator 필요함
class EditorNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final int min;
  final int max;
  final bool enabled;
  final void Function(int value)? onChanged;

  const EditorNumberTextField({
    super.key,
    required this.controller,
    required this.min,
    required this.max,
    required this.enabled,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 61,
      height: 34,
      padding: const EdgeInsets.fromLTRB(11, 0, 6, 0),
      decoration: BoxDecoration(
        color: enabled
            ? const Color(0xFFFFFFFF)
            : const Color(0xFFF8F9FD),
        border: Border.all(width: 1, color: const Color(0xFFE9ECF5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              /// TODO padding 지우고도 가운데로 맞출 수 있도록 수정
              padding: const EdgeInsets.only(top: 8.5),
              child: TextField(
                enabled: enabled,
                controller: controller,
                keyboardType: TextInputType.number,
                maxLines: 1,
                maxLength: max.toString().length,
                onChanged: (strValue) {
                  if(int.tryParse(strValue) != null && onChanged != null) {
                    onChanged!(int.parse(strValue));
                  }
                },
                style: AppTextStyles.size12Regular.copyWith(height: 15 / 12),
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  counter: SizedBox.shrink(),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if(enabled) {
                    final currentNum = int.tryParse(controller.text);
                    if (currentNum != null && currentNum < max) {
                      controller.text = (currentNum + 1).toString();

                      if(onChanged != null) {
                        onChanged!(currentNum + 1);
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: SvgPicture.asset(
                    'assets/icons/number_text_field_up.svg',
                    height: 4,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  if(enabled) {
                    final currentNum = int.tryParse(controller.text);
                    if (currentNum != null && currentNum > min) {
                      controller.text = (currentNum - 1).toString();

                      if(onChanged != null) {
                        onChanged!(currentNum - 1);
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: SvgPicture.asset(
                    'assets/icons/number_text_field_down.svg',
                    height: 4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}