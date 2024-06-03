import 'package:flutter/foundation.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/models/enums/condition_type.dart';
import 'package:mysmax_playground/models/thing_value.dart';

import '../../../core/scenario_code_parser/enums.dart';
import '../../../core/scenario_code_parser/expression.dart';

class AddUntilScenarioViewModel extends ChangeNotifier {
  AddUntilScenarioViewModel();

  ThingValue? _firstValue;
  ThingValue? get firstValue => _firstValue;
  set firstValue(ThingValue? value) {
    _firstValue = value;
    notifyListeners();
  }

  RangeType _firstValueRangeType = RangeType.ANY;
  RangeType get firstValueRangeType => _firstValueRangeType;
  set firstValueRangeType(RangeType value) {
    _firstValueRangeType = value;
    notifyListeners();
  }

  ValueServiceExpression firstValueToExpression() {
    return ValueServiceExpression(
      firstValue!.name,
      firstValue!.tags.map((e) => e.name).toList(),
      _firstValueRangeType,
    );
  }

  ConditionType? _conditionType = ConditionType.equal;
  ConditionType? get conditionType => _conditionType;
  set conditionType(ConditionType? value) {
    _conditionType = value;
    notifyListeners();
  }

  dynamic _lastValue;
  dynamic get lastValue => _lastValue;
  set lastValue(dynamic value) {
    _lastValue = value;
    notifyListeners();
  }

  ValueServiceExpression lastValueToExpression() {
    var value = lastValue as ThingValue;
    return ValueServiceExpression(
      value.name,
      value.tags.map((e) => e.name).toList(),
      _lastValueRangeType,
    );
  }

  RangeType _lastValueRangeType = RangeType.ANY;
  RangeType get lastValueRangeType => _lastValueRangeType;
  set lastValueRangeType(RangeType value) {
    _lastValueRangeType = value;
    notifyListeners();
  }

  Block createBlock() {
    return WaitUntilBlock(
        PeriodExpression(PeriodType.SEC,
            LiteralExpression(0, literalType: LiteralType.INTEGER)),
        ConditionExpression(
          firstValueToExpression(), // Literal, ValueService
          lastValue is ThingValue
              ? lastValueToExpression()
              : lastValue, // Literal, ValueService
          false,
          conditionType!.toOperator,
        ));
  }

  // Add your state and logic here
}
