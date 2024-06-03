import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/widgets/radio_toggle.dart';

class RadioTextButton<T> extends StatelessWidget {
  final bool enabled;
  final T value;
  final T groupValue;
  final void Function(T) onChanged;
  final String title;

  const RadioTextButton({
    super.key,
    this.enabled = true,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if(enabled == false) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Color(0xFFE9ECF5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.size14Regular.copyWith(
              color: const Color(0xFFADB3C6),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioToggleButton(
            toggled: value == groupValue,
            size: 14,
            innerSize: 8,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: value == groupValue
                ? AppTextStyles.size14Bold.copyWith(
              color: const Color(0xFF5D7CFF),
            ) : AppTextStyles.size14Regular.copyWith(
              color: const Color(0xFFADB3C6),
            ),
          ),
        ],
      ),
    );
  }
}