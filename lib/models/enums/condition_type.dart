import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';

enum ConditionType {
  equal,
  notEqual,
  greaterThan,
  greaterThanOrEqual,
  lessThan,
  lessThanOrEqual,
}

extension ConditionTypeExtension on ConditionType {
  String get toName {
    switch (this) {
      case ConditionType.equal:
        return '=';
      case ConditionType.notEqual:
        return '!=';
      case ConditionType.greaterThan:
        return '>';
      case ConditionType.greaterThanOrEqual:
        return '>=';
      case ConditionType.lessThan:
        return '<';
      case ConditionType.lessThanOrEqual:
        return '<=';
      default:
        return '';
    }
  }

  String get toTitle {
    switch (this) {
      case ConditionType.equal:
        return '${this.toName} (같다)';
      case ConditionType.notEqual:
        return '${this.toName} (다르다)';
      case ConditionType.greaterThan:
        return '${this.toName} (크다)';
      case ConditionType.greaterThanOrEqual:
        return '${this.toName} (크거나 같다)';
      case ConditionType.lessThan:
        return '${this.toName} (작다)';
      case ConditionType.lessThanOrEqual:
        return '${this.toName} (작거나 같다)';
      default:
        return '';
    }
  }

  Operator get toOperator {
    switch (this) {
      case ConditionType.equal:
        return Operator.EQUAL;
      case ConditionType.notEqual:
        return Operator.NOT_EQUAL;
      case ConditionType.greaterThan:
        return Operator.GREATER_THAN;
      case ConditionType.greaterThanOrEqual:
        return Operator.GREATER_THAN_OR_EQUAL;
      case ConditionType.lessThan:
        return Operator.LESS_THAN;
      case ConditionType.lessThanOrEqual:
        return Operator.LESS_THAN_OR_EQUAL;
      default:
        return Operator.UNDEFINED;
    }
  }
}
