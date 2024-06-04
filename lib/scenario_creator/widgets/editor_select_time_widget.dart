import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/helper/date_time_helper.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_number_text_field.dart';
import 'package:mysmax_playground/widgets/custom_drop_down.dart';

class EditorSelectTimeWidget extends StatelessWidget {
  final bool enabled;
  final AmPm selectedTimePrefix;
  final void Function(AmPm? newValue) onChangedTimePrefix;
  final TextEditingController hourController;
  final void Function(int) onChangedHour;
  final TextEditingController minuteController;
  final void Function(int) onChangedMinute;

  const EditorSelectTimeWidget({
    super.key,
    required this.enabled,
    required this.selectedTimePrefix,
    required this.onChangedTimePrefix,
    required this.hourController,
    required this.onChangedHour,
    required this.minuteController,
    required this.onChangedMinute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomDropDown<AmPm>(
          enabled: enabled,
          selectedValue: selectedTimePrefix,
          onChanged: onChangedTimePrefix,
          items: AmPm.values,
        ),
        const SizedBox(width: 6),
        EditorNumberTextField(
          enabled: enabled,
          controller: hourController,
          min: 1,
          max: 12,
          onChanged: onChangedHour,
        ),
        const SizedBox(width: 6),
        Text(':', style: AppTextStyles.size12Regular.singleLine),
        const SizedBox(width: 6),
        EditorNumberTextField(
          enabled: enabled,
          controller: minuteController,
          min: 0,
          max: 59,
          onChanged: onChangedMinute,
        ),
      ],
    );
  }
}