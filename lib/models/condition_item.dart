import '../core/scenario_code_parser/enums.dart';

class ConditionItem {
  dynamic firstValue;
  RangeType? firstValueRangeType;
  Operator? conditionType;

  dynamic lastValue;
  RangeType? lastValueRangeType;

  ConditionItem({
    this.firstValue,
    this.firstValueRangeType,
    this.conditionType,
    this.lastValue,
    this.lastValueRangeType,
  });
}
