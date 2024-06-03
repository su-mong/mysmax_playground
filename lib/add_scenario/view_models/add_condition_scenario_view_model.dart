import 'package:flutter/foundation.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';
import 'package:mysmax_playground/models/condition_item.dart';

import '../../../core/scenario_code_parser/enums.dart';
import '../../core/scenario_code_parser/scenario_code_parser.dart';

class AddConditionScenarioViewModel extends ChangeNotifier {
  AddConditionScenarioViewModel();

  List<Operator> operators = [];

  List<ConditionItem> _conditions = [
    ConditionItem(
      conditionType: Operator.EQUAL,
    )
  ];

  List<ConditionItem> get conditions => _conditions;

  set conditions(List<ConditionItem> value) {
    _conditions = value;
    notifyListeners();
  }

  void setFirstValue(int index, dynamic value) {
    _conditions[index].firstValue = value;
    notifyListeners();
  }

  void setFirstValueRangeType(int index, RangeType value) {
    _conditions[index].firstValueRangeType = value;
    notifyListeners();
  }

  void setConditionType(int index, Operator value) {
    _conditions[index].conditionType = value;
    notifyListeners();
  }

  void setLastValue(int index, dynamic value) {
    _conditions[index].lastValue = value;
    notifyListeners();
  }

  void setLastValueRangeType(int index, RangeType value) {
    _conditions[index].lastValueRangeType = value;
    notifyListeners();
  }

  void setOperator(int index, Operator value) {
    operators[index] = value;
    notifyListeners();
  }

  void addCondition() {
    operators.add(Operator.AND);
    _conditions.add(ConditionItem(
      conditionType: Operator.EQUAL,
    ));
    notifyListeners();
  }

  // ThingValue? _firstValue;
  // ThingValue? get firstValue => _firstValue;
  // set firstValue(ThingValue? value) {
  //   _firstValue = value;
  //   notifyListeners();
  // }
  //
  // RangeType _firstValueRangeType = RangeType.ANY;
  // RangeType get firstValueRangeType => _firstValueRangeType;
  // set firstValueRangeType(RangeType value) {
  //   _firstValueRangeType = value;
  //   notifyListeners();
  // }
  //
  // ValueServiceExpression firstValueToExpression() {
  //   return ValueServiceExpression(
  //     firstValue!.name,
  //     firstValue!.tags.map((e) => e.name).toList(),
  //     _firstValueRangeType,
  //   );
  // }
  //
  // ConditionType? _conditionType = ConditionType.equal;
  // ConditionType? get conditionType => _conditionType;
  // set conditionType(ConditionType? value) {
  //   _conditionType = value;
  //   notifyListeners();
  // }
  //
  // dynamic _lastValue;
  // dynamic get lastValue => _lastValue;
  // set lastValue(dynamic value) {
  //   _lastValue = value;
  //   notifyListeners();
  // }
  //
  // ValueServiceExpression lastValueToExpression() {
  //   var value = lastValue as ThingValue;
  //   return ValueServiceExpression(
  //     value.name,
  //     value.tags.map((e) => e.name).toList(),
  //     _lastValueRangeType,
  //   );
  // }
  //
  // RangeType _lastValueRangeType = RangeType.ANY;
  // RangeType get lastValueRangeType => _lastValueRangeType;
  // set lastValueRangeType(RangeType value) {
  //   _lastValueRangeType = value;
  //   notifyListeners();
  // }

  Future loadBlock(IfBlock block) async {
    var expression = block.condition;
    var expressions = expression.expressions;
    while (expressions.any((element) => element is ConditionExpression)) {
      var index =
          expressions.indexWhere((element) => element is ConditionExpression);
      expressions[index] =
          (expressions[index] as ConditionExpression).expressions;
    }
    print(expressions);
    notifyListeners();
  }

  IfBlock createBlock() {
    ConditionExpression? finalExpression;
    if (_conditions.length == 1) {
      finalExpression = ConditionExpression(
        _conditions[0].firstValue,
        _conditions[0].lastValue,
        false,
        _conditions[0].conditionType!,
      );
    } else {
      for (var i = 0; i < _conditions.length; i++) {
        if (i == 0) {
          finalExpression = ConditionExpression(
            _conditions[i].firstValue,
            _conditions[i].lastValue,
            false,
            _conditions[i].conditionType!,
          );
          continue;
        }
        finalExpression = ConditionExpression(
          finalExpression,
          ConditionExpression(
            _conditions[i].firstValue,
            _conditions[i].lastValue,
            false,
            _conditions[i].conditionType!,
          ),
          false,
          operators[i - 1],
        );
      }
    }

    return IfBlock(finalExpression!);
  }

  // Add your state and logic here
}
