import 'package:flutter/material.dart';

import '../../models/condition_item.dart';
import 'block.dart';
import '../../colors.dart';
import 'enums.dart';

ServiceType getServiceType(String line) {
  RegExp functionPattern = RegExp(r'\(#.*?\)\.\w+\(.*?\)');
  RegExp valuePattern = RegExp(r'\(#.*?\)\.\w+');

  if (functionPattern.hasMatch(line)) {
    return ServiceType.FUNCTION;
  } else if (valuePattern.hasMatch(line)) {
    return ServiceType.VALUE;
  } else {
    return ServiceType.UNDEFINED;
  }
}

abstract class Expression {
  ExpressionType expressionType = ExpressionType.UNDEFINED;

  Expression(this.expressionType);

  // Generate scenario code from class.
  //   ex) [any]({#tag1} {#tag2} ...).{serviceName}: [] means optional, {} means necessary, ... means repeatable
  String toScenarioCode();
}

class LiteralExpression extends Expression {
  LiteralType literalType = LiteralType.UNDEFINED;
  dynamic value;

  LiteralExpression(this.value, {this.literalType = LiteralType.UNDEFINED})
      : super(ExpressionType.LITERAL);

  String get valueString {
    switch (literalType) {
      case LiteralType.STRING:
        return value as String;
      case LiteralType.BOOL:
        return (value as bool).toString().toLowerCase();
      case LiteralType.INTEGER:
        return (value as int).toString();
      case LiteralType.DOUBLE:
        return (value as double).toStringAsFixed(4);
      case LiteralType.VARIABLE:
        return value as String;
      default:
        throw Exception('Invalid literal type');
    }
  }

  TextSpan get expressionTextSpan {
    return TextSpan(children: [
      TextSpan(
        text: "${literalType.toDisplayName} ",
      ),
      TextSpan(
          text: valueString, style: const TextStyle(color: AppColors.blue)),
    ]);
  }

  TextSpan get leftExpressionTextSpan {
    return expressionTextSpan;
  }
  String get leftExpressionString {
    return "${literalType.toDisplayName} $valueString";
  }

  TextSpan get rightExpressionTextSpan {
    return expressionTextSpan;
  }
  String get rightExpressionString {
    return "${literalType.toDisplayName} $valueString";
  }

  static LiteralExpression parse(String line) {
    // int type check
    try {
      int intValue = int.parse(line);
      return LiteralExpression(intValue, literalType: LiteralType.INTEGER);
    } on FormatException {
      // pass
    }

    // double type check
    try {
      double doubleValue = double.parse(line);
      return LiteralExpression(doubleValue, literalType: LiteralType.DOUBLE);
    } on FormatException {
      // pass
    }

    // bool type check
    try {
      bool boolValue = bool.parse(line.toLowerCase());
      return LiteralExpression(boolValue, literalType: LiteralType.BOOL);
    } on FormatException {
      // pass
    }

    // string type check
    if (line.startsWith('"') && line.endsWith('"')) {
      return LiteralExpression(line.substring(1, line.length - 1),
          literalType: LiteralType.STRING);
    }

    // If all attempts fail, it is considered a variable.
    return LiteralExpression(line, literalType: LiteralType.VARIABLE);
  }

  @override
  String toScenarioCode() {
    // {Literal}
    String code = '';

    if (value is String && (value as String).isEmpty) {
      code = '';
    } else if (literalType == LiteralType.STRING) {
      code = '"$value"';
    } else if (literalType == LiteralType.BOOL) {
      code = value.toString().toLowerCase();
    } else if (literalType == LiteralType.INTEGER) {
      code = value.toString();
    } else if (literalType == LiteralType.DOUBLE) {
      code = (value as double).toStringAsFixed(4);
    } else if (literalType == LiteralType.VARIABLE) {
      code = '$value';
    } else {
      throw Exception('Invalid literal type');
    }

    return code;
  }
}

class PeriodExpression extends Expression {
  PeriodType periodType = PeriodType.UNDEFINED;
  LiteralExpression period;

  PeriodExpression(this.periodType, this.period) : super(ExpressionType.PERIOD);

  static PeriodExpression parse(String line) {
    List<String> lines = line.split(' ');
    LiteralExpression period = LiteralExpression.parse(lines[0]);
    PeriodType periodType = PeriodTypeExtension.fromString(lines[1]);

    if (periodType == PeriodType.UNDEFINED) {
      throw Exception('Invalid period type');
    }

    return PeriodExpression(periodType, period);
  }

  @override
  String toScenarioCode() {
    // {LiteralExpression} {PeriodType}
    String code = '${period.toScenarioCode()} ${periodType.value}';

    return code;
  }
}

class ConditionExpression extends Expression {
  dynamic leftExpression; // Condition, Literal, ValueService | Expression
  dynamic rightExpression; // Condition, Literal, ValueService | Expression
  bool isNegatedCondition;
  Operator operator = Operator.UNDEFINED;

  ConditionExpression(this.leftExpression, this.rightExpression,
      this.isNegatedCondition, this.operator)
      : super(ExpressionType.CONDITION);

  List<dynamic> get expressions {
    return [leftExpression, operator, rightExpression];
  }

  List<ConditionItem> get conditions {
    List<ConditionItem> conditions = [];

    switch (leftExpression.runtimeType) {
      case ConditionExpression:
        conditions.addAll((leftExpression as ConditionExpression).conditions);
        break;
      case LiteralExpression:
        conditions.add(ConditionItem(
            firstValue: (leftExpression as LiteralExpression),
            conditionType: operator,
            lastValue: rightExpression,
            lastValueRangeType: rightExpression is ValueServiceExpression
                ? (rightExpression as ValueServiceExpression).rangeType
                : null));
        break;
      case ValueServiceExpression:
        conditions.add(ConditionItem(
            firstValue: (leftExpression as ValueServiceExpression),
            firstValueRangeType:
                (leftExpression as ValueServiceExpression).rangeType,
            conditionType: operator,
            lastValue: rightExpression,
            lastValueRangeType: rightExpression is ValueServiceExpression
                ? (rightExpression as ValueServiceExpression).rangeType
                : null));
        break;
      default:
        throw Exception('Invalid left expression type');
    }

    return conditions;
  }

  TextSpan get expressionTextSpan {
    return TextSpan(children: [
      leftExpression.leftExpressionTextSpan,
      TextSpan(
          text: " ${operator.value} ",
          style: const TextStyle(color: AppColors.blue)),
      rightExpression.rightExpressionTextSpan,
    ]);
  }
  String get expressionString {
    return '${leftExpression.leftExpressionString} ${operator.value} ${rightExpression.rightExpressionString}';
  }

  TextSpan get leftExpressionTextSpan {
    if (leftExpression is LiteralExpression) {
      return TextSpan(children: [
        TextSpan(
          text:
              "${(leftExpression as LiteralExpression).literalType.toDisplayName} ",
        ),
        TextSpan(
            text: (leftExpression as LiteralExpression).valueString,
            style: const TextStyle(color: AppColors.blue)),
      ]);
    } else if (leftExpression is ValueServiceExpression) {
      return TextSpan(children: [
        TextSpan(
          text: "${(leftExpression as ValueServiceExpression).serviceName} ",
        ),
      ]);
    } else if (leftExpression is ConditionExpression) {
      var condition = leftExpression as ConditionExpression;
      return condition.expressionTextSpan;
    } else {
      throw Exception('Invalid left expression type');
    }
  }

  String get leftExpressionString {
    if (leftExpression is LiteralExpression) {
      return '${(leftExpression as LiteralExpression).literalType.toDisplayName}'
          ' ${(leftExpression as LiteralExpression).valueString}';
    } else if (leftExpression is ValueServiceExpression) {
      return '${(leftExpression as ValueServiceExpression).serviceName} ';
    } else if (leftExpression is ConditionExpression) {
      return '${leftExpression.leftExpressionString}'
          ' ${operator.value} ${rightExpression.rightExpressionString}';
    } else {
      throw Exception('Invalid left expression type');
    }
  }

  TextSpan get rightExpressionTextSpan {
    if (rightExpression is LiteralExpression) {
      return TextSpan(children: [
        TextSpan(
          text:
              "${(rightExpression as LiteralExpression).literalType.toDisplayName} ",
        ),
        TextSpan(
            text: (rightExpression as LiteralExpression).valueString,
            style: const TextStyle(color: AppColors.blue)),
      ]);
    } else if (rightExpression is ValueServiceExpression) {
      return TextSpan(children: [
        TextSpan(
          text: "${(rightExpression as ValueServiceExpression).serviceName} ",
        ),
      ]);
    } else if (rightExpression is ConditionExpression) {
      var condition = rightExpression as ConditionExpression;
      return condition.expressionTextSpan;
    } else {
      throw Exception('Invalid right expression type');
    }
  }

  String get rightExpressionString {
    if (rightExpression is LiteralExpression) {
      return "${(rightExpression as LiteralExpression).literalType.toDisplayName}"
          " ${(rightExpression as LiteralExpression).valueString}";
    } else if (rightExpression is ValueServiceExpression) {
      return "${(rightExpression as ValueServiceExpression).serviceName} ";
    } else if (rightExpression is ConditionExpression) {
      return '${leftExpression.leftExpressionString}'
          ' ${operator.value} ${rightExpression.rightExpressionString}';
    } else {
      throw Exception('Invalid right expression type');
    }
  }

  static ConditionExpression parse(String line) {
    // 우선 순위에 따라 문자열을 나누기: 'or'가 'and'보다 낮은 우선 순위를 가집니다.
    for (Operator op in [Operator.OR, Operator.AND]) {
      int index = (op == Operator.OR)
          ? line.lastIndexOf(' or ')
          : line.lastIndexOf(' and ');
      if (index == -1) continue;

      String leftPart = line.substring(0, index);
      String rightPart = line.substring(index + ((op == Operator.OR) ? 4 : 5));

      dynamic leftExpr = parse(leftPart);
      dynamic rightExpr = parse(rightPart);

      return ConditionExpression(leftExpr, rightExpr, false, op);
    }

    // 비교 연산자 처리
    for (Operator op in ComparisonOperators.values) {
      if (op == Operator.UNDEFINED) continue;

      String opStr = op.value;
      bool isNegatedCondition = false;
      if (!line.contains(' $opStr ')) continue;
      if (line.contains('not')) {
        isNegatedCondition = true;
        line = line.replaceAll('not', '').trim();
      }

      List<String> parts = line.split(opStr);
      if (parts.length != 2) {
        throw Exception(
            'Invalid condition expression - too many operators - $line');
      }

      String leftPart = parts[0].trim();
      String rightPart = parts[1].trim();

      ServiceType leftServiceType = getServiceType(leftPart);
      dynamic leftExpr;
      switch (leftServiceType) {
        case ServiceType.VALUE:
          leftExpr = ValueServiceExpression.parse(leftPart);
          break;
        case ServiceType.FUNCTION:
          throw Exception(
              'Invalid condition expression - function service is not allowed - $leftPart');
        default:
          leftExpr = LiteralExpression.parse(leftPart);
      }

      ServiceType rightServiceType = getServiceType(rightPart);
      dynamic rightExpr;
      switch (rightServiceType) {
        case ServiceType.VALUE:
          rightExpr = ValueServiceExpression.parse(rightPart);
          break;
        case ServiceType.FUNCTION:
          throw Exception(
              'Invalid condition expression - function service is not allowed - $rightPart');
        default:
          rightExpr = LiteralExpression.parse(rightPart);
      }
      return ConditionExpression(leftExpr, rightExpr, isNegatedCondition,
          ComparisonOperatorsExtension.fromString(opStr));
    }

    throw Exception('Invalid condition expression - no operator found');
  }

  @override
  String toScenarioCode() {
    // [not] {Condition, Literal, ValueService} {op} [not] {Condition, Literal, ValueService} ...

    String code = '';
    String op = operator.value;
    String left;
    String right;

    if (isTimeCondition()) {
      // ValueServiceExpression timeService = leftExpression is ValueServiceExpression ? leftExpression : rightExpression;
      // LiteralExpression timeLiteral = leftExpression is LiteralExpression ? leftExpression : rightExpression;
      TimeServiceType timeServiceType = getTimeServiceType();

      switch (timeServiceType) {
        case TimeServiceType.DATETIME:
          left = leftExpression is ValueServiceExpression
              ? (leftExpression as ValueServiceExpression).toScenarioCode()
              : (leftExpression as LiteralExpression)
                  .toScenarioCode()
                  .padLeft(12, '0');
          right = rightExpression is ValueServiceExpression
              ? (rightExpression as ValueServiceExpression).toScenarioCode()
              : (rightExpression as LiteralExpression)
                  .toScenarioCode()
                  .padLeft(12, '0');
          break;
        case TimeServiceType.DATE:
          left = leftExpression is ValueServiceExpression
              ? (leftExpression as ValueServiceExpression).toScenarioCode()
              : (leftExpression as LiteralExpression)
                  .toScenarioCode()
                  .padLeft(8, '0');
          right = rightExpression is ValueServiceExpression
              ? (rightExpression as ValueServiceExpression).toScenarioCode()
              : (rightExpression as LiteralExpression)
                  .toScenarioCode()
                  .padLeft(8, '0');
          break;
        case TimeServiceType.TIME:
          left = leftExpression is ValueServiceExpression
              ? (leftExpression as ValueServiceExpression).toScenarioCode()
              : (leftExpression as LiteralExpression)
                  .toScenarioCode()
                  .padLeft(4, '0');
          right = rightExpression is ValueServiceExpression
              ? (rightExpression as ValueServiceExpression).toScenarioCode()
              : (rightExpression as LiteralExpression)
                  .toScenarioCode()
                  .padLeft(4, '0');
          break;
        case TimeServiceType.WEEKDAY:
          left = leftExpression is ValueServiceExpression
              ? (leftExpression as ValueServiceExpression).toScenarioCode()
              : (leftExpression as LiteralExpression).toScenarioCode();
          right = rightExpression is ValueServiceExpression
              ? (rightExpression as ValueServiceExpression).toScenarioCode()
              : (rightExpression as LiteralExpression).toScenarioCode();
          break;
        default:
          throw Exception('Invalid time service type');
      }
    } else {
      Type leftExpressionType = leftExpression.runtimeType;
      Type rightExpressionType = rightExpression.runtimeType;

      switch (leftExpressionType) {
        case ConditionExpression:
          left = (leftExpression as ConditionExpression).toScenarioCode();
          break;
        case LiteralExpression:
          left = (leftExpression as LiteralExpression).toScenarioCode();
          break;
        case ValueServiceExpression:
          left = (leftExpression as ValueServiceExpression).toScenarioCode();
          break;
        case FunctionServiceBlock:
          left = (leftExpression as FunctionServiceBlock).toScenarioCode();
          break;
        default:
          throw Exception('Invalid left expression type');
      }

      switch (rightExpressionType) {
        case ConditionExpression:
          right = (rightExpression as ConditionExpression).toScenarioCode();
          break;
        case LiteralExpression:
          right = (rightExpression as LiteralExpression).toScenarioCode();
          break;
        case ValueServiceExpression:
          right = (rightExpression as ValueServiceExpression).toScenarioCode();
          break;
        case FunctionServiceBlock:
          right = (rightExpression as FunctionServiceBlock).toScenarioCode();
          break;
        default:
          throw Exception('Invalid right expression type');
      }
    }

    if (isNegatedCondition) {
      code = 'not $left $op $right';
    } else {
      code = '$left $op $right';
    }

    return code;
  }

  bool isHaveTimeCondition() {
    bool isTimeConditionHelper(ConditionExpression condition) {
      if (condition.isTimeCondition()) {
        return true;
      } else {
        if (condition.leftExpression is ConditionExpression) {
          return isTimeConditionHelper(condition.leftExpression);
        }
        if (condition.rightExpression is ConditionExpression) {
          return isTimeConditionHelper(condition.rightExpression);
        }

        return false;
      }
    }

    return isTimeConditionHelper(this);
  }

  bool isTimeCondition() {
    if (!((leftExpression is ValueServiceExpression &&
            rightExpression is LiteralExpression) ||
        (leftExpression is LiteralExpression &&
            rightExpression is ValueServiceExpression))) {
      return false;
    }

    ValueServiceExpression valueServiceExpression =
        leftExpression is ValueServiceExpression
            ? leftExpression
            : rightExpression;
    // LiteralExpression literalExpression = leftExpression is LiteralExpression ? leftExpression : rightExpression;
    if (!((valueServiceExpression.tags.contains('clock') || valueServiceExpression.tags.contains('Clock')) &&
        (TimeServiceTypeExtension.fromString(
                valueServiceExpression.serviceName) !=
            TimeServiceType.UNDEFINED))) {
      return false;
    }

    return true;
  }

  int getTimeLiteral() {
    if (!isTimeCondition()) {
      throw Exception('Invalid time condition');
    }

    if (leftExpression is LiteralExpression) {
      return (leftExpression as LiteralExpression).value;
    } else if (rightExpression is LiteralExpression) {
      return (rightExpression as LiteralExpression).value;
    } else {
      throw Exception('Invalid time condition');
    }
  }

  TimeServiceType getTimeServiceType() {
    if (!isHaveTimeCondition()) {
      throw Exception('Invalid time condition');
    }

    String timeServiceName;

    if (leftExpression is ValueServiceExpression) {
      timeServiceName = (leftExpression as ValueServiceExpression).serviceName;
    } else if (rightExpression is ValueServiceExpression) {
      timeServiceName = (rightExpression as ValueServiceExpression).serviceName;
    } else {
      throw Exception('Invalid time condition');
    }

    return TimeServiceTypeExtension.fromString(timeServiceName);
  }
}

class ValueServiceExpression extends Expression {
  String serviceName;
  List<String> tags = <String>[];
  RangeType rangeType;

  ValueServiceExpression(this.serviceName, this.tags, this.rangeType)
      : super(ExpressionType.VALUE_SERVICE);

  TextSpan get expressionTextSpan {
    return TextSpan(children: [
      TextSpan(
        text: "$serviceName ",
      ),
    ]);
  }

  TextSpan get leftExpressionTextSpan {
    return expressionTextSpan;
  }
  String get leftExpressionString {
    return "$serviceName ";
  }

  TextSpan get rightExpressionTextSpan {
    return expressionTextSpan;
  }
  String get rightExpressionString {
    return "$serviceName ";
  }

  static ValueServiceExpression parse(String line) {
    String serviceName = '';
    List<String> tags = [];
    RangeType rangeType = RangeType.AUTO;

    if (line.startsWith('any(')) {
      rangeType = RangeType.ANY;
      line = line.replaceFirst('any', '').trim();
    } else if (line.startsWith('(')) {
      rangeType = RangeType.AUTO;
    } else {
      throw FormatException('Invalid format for ValueServiceExpression: $line');
    }

    RegExp pattern = RegExp(r'\((#.*?)\)\.(\w+)');
    var matches = pattern.firstMatch(line);

    if (matches != null && matches.groupCount == 2) {
      tags = matches.group(1)!.split(' ').map((t) => t.substring(1)).toList();
      serviceName = matches.group(2)!;

      return ValueServiceExpression(serviceName, tags, rangeType);
    } else {
      throw FormatException('Invalid format for ValueServiceExpression: $line');
    }
  }

  @override
  String toScenarioCode() {
    // [any]({#tag1} {#tag2} ...).{serviceName}

    String code = '';

    if (rangeType == RangeType.ANY) {
      code += 'any';
    }

    code += '(${tags.map((item) => '#$item').join(' ')}).$serviceName';

    return code;
  }

  ValueServiceExpression copyWith({
    String? serviceName,
    List<String>? tags,
    RangeType? rangeType,
  }) {
    return ValueServiceExpression(
      serviceName ?? this.serviceName,
      tags ?? this.tags,
      rangeType ?? this.rangeType,
    );
  }
}
