import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/helper/date_time_helper.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_hour_text_field.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_number_text_field.dart';
import 'package:mysmax_playground/widgets/custom_drop_down.dart';

class EditorSelectDateTimeWidget extends StatefulWidget {
  final bool enabled;
  final DateTime? initialDateTime;
  final void Function(DateTime?) onChangeDateTime;

  const EditorSelectDateTimeWidget({
    super.key,
    required this.enabled,
    required this.initialDateTime,
    required this.onChangeDateTime,
  });

  @override
  State<EditorSelectDateTimeWidget> createState() => _EditorSelectDateTimeWidgetState();
}

class _EditorSelectDateTimeWidgetState extends State<EditorSelectDateTimeWidget> {
  late DateTime? _currentDateTime;

  AmPm _selectedTimePrefix = AmPm.am;
  late final TextEditingController _hourController;
  late final TextEditingController _minuteController;

  @override
  void initState() {
    super.initState();

    _currentDateTime = widget.initialDateTime;
    _selectedTimePrefix = _currentDateTime?.getAmPm ?? AmPm.am;
    _hourController = TextEditingController(text: _currentDateTime != null ? DateFormat('h').format(_currentDateTime!) : '');
    _minuteController = TextEditingController(text: _currentDateTime != null ? DateFormat('m').format(_currentDateTime!) : '');
  }

  @override
  void didUpdateWidget(covariant EditorSelectDateTimeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget != oldWidget) {
      // _isActive = widget.initialDateTime != null;
      _currentDateTime = widget.initialDateTime;
      _selectedTimePrefix = _currentDateTime?.getAmPm ?? AmPm.am;
      _hourController.text = _currentDateTime != null ? DateFormat('h').format(_currentDateTime!) : '';
      _minuteController.text = _currentDateTime != null ? DateFormat('m').format(_currentDateTime!) : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dateButton(),
        const SizedBox(height: 6),
        _timeWidget(),
      ],
    );
  }

  Widget _dateButton() {
    return GestureDetector(
      onTap: widget.enabled
        ? () async {
        final DateTime? selectedDateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2099, 12, 31, 23, 59, 59),
          locale: const Locale('ko', 'KR'),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: const Color(0xFF5D7CFF), // Set primary color
                colorScheme: const ColorScheme.light(primary: Color(0xFF5D7CFF)),
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );

        setState(() {
          _currentDateTime = selectedDateTime ?? _currentDateTime;
        });

        widget.onChangeDateTime(_currentDateTime);
      } : null,
      child: Container(
        width: 110,
        height: 34,
        decoration: BoxDecoration(
          color: widget.enabled
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFF8F9FD),
          border: Border.all(width: 1, color: const Color(0xFFE9ECF5)),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.enabled && _currentDateTime != null// && _isActive
              ? DateFormat('yyyy년 M월 d일').format(_currentDateTime!)
              : '년 월 일',
          style: AppTextStyles.size12Regular.copyWith(
              letterSpacing: -0.36,
              color: widget.enabled && _currentDateTime != null// && _isActive
                  ? const Color(0xFF3F424B)
                  : const Color(0xFF8F94A4)
          ),
        ),
      ),
    );
  }

  Widget _timeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomDropDown<AmPm>(
          enabled: widget.enabled && _currentDateTime != null,// && _isActive,
          selectedValue: _selectedTimePrefix,
          onChanged: (amPm) {
            if(amPm != null) {
              setState(() {
                _currentDateTime = _currentDateTime!.copyWithAmPm(amPm);
              });
              widget.onChangeDateTime(_currentDateTime);
            }
          },
          items: AmPm.values,
        ),
        const SizedBox(width: 6),
        EditorHourTextField(
          enabled: widget.enabled && _currentDateTime != null,// && _isActive,
          controller: _hourController,
          onChanged: (hour) {
            setState(() {
              int _hour = hour;
              /// 시간은 이른 순서부터 나열하면 12시, 1시, 2시, ..., 11시 이렇게 된다.
              /// 따라서, hour == 12이면 0으로 입력해주고, 나머지 케이스에 대해선 그대로 입력해야 한다.
              if(hour == 12) {
                _hour = 0;
              }
              /// 오전/오후 변경되지 않도록 값 계산
              if(_selectedTimePrefix == AmPm.pm) {
                _hour += 12;
              }
              _currentDateTime = _currentDateTime!.copyWith(hour: _hour);
            });
            widget.onChangeDateTime(_currentDateTime);
          },
        ),
        const SizedBox(width: 6),
        Text(':', style: AppTextStyles.size12Regular.singleLine),
        const SizedBox(width: 6),
        EditorNumberTextField(
          enabled: widget.enabled && _currentDateTime != null,// && _isActive,
          controller: _minuteController,
          min: 0,
          max: 59,
          onChanged: (minute) {
            setState(() {
              _currentDateTime = _currentDateTime!.copyWith(minute: minute);
            });
            widget.onChangeDateTime(_currentDateTime);
          },
        ),
      ],
    );
  }
}