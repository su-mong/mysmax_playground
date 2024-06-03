import 'package:flutter/cupertino.dart';

const double _kPickerHeight = 180.0;
const Duration _kToggleDuration = Duration(milliseconds: 200);
const Curve _kToggleCurve = Curves.ease;

class ToggleableDatePicker extends StatelessWidget {
  const ToggleableDatePicker({
    Key? key,
    this.minimumDate,
    required this.initialDate,
    required this.isToggled,
    required this.onDateTimeChanged,
  }) : super(key: key);

  final DateTime initialDate;
  final DateTime? minimumDate;
  final bool isToggled;
  final Function(DateTime value) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _kToggleDuration,
      curve: _kToggleCurve,
      height: isToggled ? _kPickerHeight : 0,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight >= 1) {
          return CupertinoDatePicker(
            onDateTimeChanged: onDateTimeChanged,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate,
            minimumDate: minimumDate,
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
