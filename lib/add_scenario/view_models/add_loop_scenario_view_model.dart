import 'package:flutter/foundation.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';

const durationType = [
  PeriodType.HOUR,
  PeriodType.MIN,
  PeriodType.SEC,
  // PeriodType.MSEC,
];

class AddLoopScenarioViewModel extends ChangeNotifier {
  LoopMode _loopType = LoopMode.MANUAL;
  LoopMode get loopType => _loopType;
  set loopType(LoopMode value) {
    _loopType = value;
    notifyListeners();
  }

  int _loopValue = 0;
  int get loopValue => _loopValue;
  set loopValue(int value) {
    _loopValue = value;
    notifyListeners();
  }

  bool _openStartTimePicker = false;
  bool get openStartTimePicker => _openStartTimePicker;
  set openStartTimePicker(bool value) {
    _openStartTimePicker = value;
    notifyListeners();
  }

  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  set startTime(DateTime? value) {
    _startTime = value;
    notifyListeners();
  }

  List<ConditionExpression>? get startTimeExpression {
    if (_startTime == null) return null;
    return [];
  }

  bool _openEndTimePicker = false;
  bool get openEndTimePicker => _openEndTimePicker;
  set openEndTimePicker(bool value) {
    _openEndTimePicker = value;
    notifyListeners();
  }

  DateTime? _endTime;
  DateTime? get endTime => _endTime;
  set endTime(DateTime? value) {
    _endTime = value;
    notifyListeners();
  }

  PeriodType _durationType = PeriodType.HOUR;
  PeriodType get durationType => _durationType;
  set durationType(PeriodType value) {
    _durationType = value;
    print('durationType: $durationType');
    notifyListeners();
  }

  DateTime? _loopTime;
  DateTime? get loopTime => _loopTime;
  set loopTime(DateTime? value) {
    _loopTime = value;
    notifyListeners();
  }

  int _weekDay = 0;
  int get weekDay => _weekDay;
  set weekDay(int value) {
    _weekDay = value;
    notifyListeners();
  }

  List<int> _weekDays = [];
  List<int> get weekDays => _weekDays;
  void addWeekDay(int value) {
    _weekDays.add(value);
    notifyListeners();
  }

  void removeWeekDay(int value) {
    _weekDays.remove(value);
    notifyListeners();
  }

  AddLoopScenarioViewModel();

  Future loadBlock(LoopBlock block) async {
    _loopType = block.loopMode;
    _loopValue = block.period?.period.value;
    _durationType = block.period?.periodType ?? PeriodType.HOUR;
    _startTime = block.timeBound.isNotEmpty ? block.timeBound[0] : null;
    _endTime = block.timeBound.length > 1 ? block.timeBound[1] : null;
    _weekDays = block.weekdays.map((e) => e.toInt).toList();
    notifyListeners();
  }

  LoopBlock get data {
    return LoopBlock(
        PeriodExpression(_durationType,
            LiteralExpression(_loopValue, literalType: LiteralType.INTEGER)),
        null,
        loopType,
        [
          _startTime,
          _endTime,
        ],
        _weekDays.map((e) => e.toWeekDayEnum).toList());
  }

  // LoopData get data => LoopData(
  //       loop_type: loopType,
  //       duration: durationType.toDuration(loopValue),
  //       start_time: startTime,
  //       end_time: endTime,
  //       loop_time: loopTime,
  //       week_days: weekDays.map((e) => e.toWeekDay()).toList(),
  //       week_day: weekDay.toWeekDay(),
  //     );
}
