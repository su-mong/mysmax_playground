import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysmax_playground/app_text_styles.dart';

class EditorDateButton extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onClick;
  final bool enabled;

  const EditorDateButton(
    this.date, {
    super.key,
    required this.onClick,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? onClick
          : null,
      child: Container(
        width: 110,
        height: 34,
        decoration: BoxDecoration(
          color: date != null && enabled
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFF8F9FD),
          border: Border.all(width: 1, color: const Color(0xFFE9ECF5)),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          date != null && enabled
              ? DateFormat('yyyy년 M월 d일').format(date!)
              : '년 월 일',
          style: AppTextStyles.size12Regular.copyWith(
              letterSpacing: -0.36,
              color: date != null && enabled
                  ? const Color(0xFF3F424B)
                  : const Color(0xFF8F94A4)
          ),
        ),
      ),
    );
  }
}