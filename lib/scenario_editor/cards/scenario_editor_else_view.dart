import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';

class ScenarioEditorElseView extends StatelessWidget {
  const ScenarioEditorElseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 32, 0, 28),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          '그렇지 않다면',
          style: AppTextStyles.size18Bold.copyWith(
            height: 29 / 18,
            color: const Color(0xFF282828),
          ),
        ),
      ),
    );
  }
}