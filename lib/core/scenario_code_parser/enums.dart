// ignore_for_file: constant_identifier_names

enum BlockType {
  UNDEFINED,
  ROOT,
  LOOP,
  IF,
  // ELSE_IF,
  ELSE,
  WAIT_UNTIL,
  VALUE_SERVICE,
  FUNCTION_SERVICE,
  EOF_BLOCK,
  EMPTY_BLOCK,
  /// 작성자: 우수몽
  /// FunctionServiceBlock 여러 개를 순서대로 리스트로 저장하는 블록. 바뀐 UI에 대응하기 위해 추가했다.
  SERVICES,
  /// IfBlock + WaitUntilBlock 둘 중 하나를 보여주기 위한 용도. ScenarioEditor에서 사용하기 위한 것이다.
  CONDITION,
}

enum ExpressionType {
  UNDEFINED,
  LITERAL,
  PERIOD,
  CONDITION,
  VALUE_SERVICE,
}

enum LiteralType {
  UNDEFINED,
  INTEGER,
  DOUBLE,
  BOOL,
  STRING,
  VARIABLE,
}

enum PeriodType {
  UNDEFINED(''),
  MSEC('밀리초'),
  SEC('초'),
  MIN('분'),
  HOUR('시간'),
  DAY('일');

  final String unitName;
  const PeriodType(this.unitName);

  @override
  String toString() => unitName;

  static List<PeriodType> get enableList => [PeriodType.SEC, PeriodType.MIN, PeriodType.HOUR, PeriodType.DAY];
}

enum ValueServiceType {
  UNDEFINED,
  INTEGER,
  DOUBLE,
  BOOL,
  STRING,
  BINARY,
}

enum FunctionServiceReturnType {
  UNDEFINED,
  VOID,
  INTEGER,
  DOUBLE,
  BOOL,
  STRING,
  BINARY,
}

enum FunctionArgumentType {
  UNDEFINED,
  INTEGER,
  DOUBLE,
  BOOL,
  STRING,
  BINARY,
}

enum Operator {
  UNDEFINED(null),
  EQUAL('= (같다)'),
  NOT_EQUAL('≠ (같지 않다)'),
  GREATER_THAN('< (크다)'),
  GREATER_THAN_OR_EQUAL('<= (크거나 같다)'),
  LESS_THAN('> (작다)'),
  LESS_THAN_OR_EQUAL('>= (작거나 같다)'),
  AND(null),
  OR(null),
  NOT(null);

  final String? title;
  const Operator(this.title);
}

enum LoopMode {
  UNDEFINED,
  MANUAL,
  DAILY,
  WEEKLY,
  WEEKDAYSELECT,
}

enum WeekDay {
  UNDEFINED,
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY;

  static List<WeekDay> get enableList => [
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
  ];
}

enum TimeServiceType {
  UNDEFINED,
  DATETIME,
  DATE,
  TIME,
  WEEKDAY,
}

extension OperatorExtension on Operator {
  String get value {
    switch (this) {
      case Operator.EQUAL:
        return "==";
      case Operator.NOT_EQUAL:
        return "!=";
      case Operator.GREATER_THAN:
        return ">";
      case Operator.GREATER_THAN_OR_EQUAL:
        return ">=";
      case Operator.LESS_THAN:
        return "<";
      case Operator.LESS_THAN_OR_EQUAL:
        return "<=";
      case Operator.AND:
        return "and";
      case Operator.OR:
        return "or";
      case Operator.NOT:
        return "not";
      default:
        return '';
    }
  }

  String get toNamed {
    switch (this) {
      case Operator.EQUAL:
        return '==';
      case Operator.NOT_EQUAL:
        return '!=';
      case Operator.GREATER_THAN:
        return '>';
      case Operator.GREATER_THAN_OR_EQUAL:
        return '>=';
      case Operator.LESS_THAN:
        return '<';
      case Operator.LESS_THAN_OR_EQUAL:
        return '<=';
      default:
        return '';
    }
  }

  String get toTitle {
    switch (this) {
      case Operator.EQUAL:
        return '${this.toNamed} (같다)';
      case Operator.NOT_EQUAL:
        return '${this.toNamed} (다르다)';
      case Operator.GREATER_THAN:
        return '${this.toNamed} (크다)';
      case Operator.GREATER_THAN_OR_EQUAL:
        return '${this.toNamed} (크거나 같다)';
      case Operator.LESS_THAN:
        return '${this.toNamed} (작다)';
      case Operator.LESS_THAN_OR_EQUAL:
        return '${this.toNamed} (작거나 같다)';
      default:
        return '';
    }
  }

  String get toDisplayName {
    switch (this) {
      case Operator.EQUAL:
        return '같다';
      case Operator.NOT_EQUAL:
        return '다르다';
      case Operator.GREATER_THAN:
        return '크다';
      case Operator.GREATER_THAN_OR_EQUAL:
        return '크거나 같다';
      case Operator.LESS_THAN:
        return '작다';
      case Operator.LESS_THAN_OR_EQUAL:
        return '작거나 같다';
      case Operator.AND:
        return '그리고';
      case Operator.OR:
        return '또는';
      case Operator.NOT:
        return '아니다';
      default:
        return '';
    }
  }
}

extension CondOperator on Operator {
  static List<Operator> get values => [
        Operator.UNDEFINED,
        Operator.AND,
        Operator.OR,
        Operator.NOT,
      ];
}

extension ComparisonOperators on Operator {
  static List<Operator> get values => [
        Operator.UNDEFINED,
        Operator.EQUAL,
        Operator.NOT_EQUAL,
        Operator.GREATER_THAN,
        Operator.GREATER_THAN_OR_EQUAL,
        Operator.LESS_THAN,
        Operator.LESS_THAN_OR_EQUAL,
      ];
}

enum RangeType {
  UNDEFINED,
  ANY,
  ALL,
  AUTO,
}

enum ServiceType {
  UNDEFINED,
  VALUE,
  FUNCTION,
}

extension CondOperatorExtension on Operator {
  bool get isConditional {
    return this == Operator.AND || this == Operator.OR || this == Operator.NOT;
  }

  String get symbol {
    switch (this) {
      case Operator.AND:
        return "and";
      case Operator.OR:
        return "or";
      case Operator.NOT:
        return "not";
      default:
        return '';
    }
  }

  static Operator fromString(String value) {
    switch (value.toLowerCase()) {
      case 'and':
        return Operator.AND;
      case 'or':
        return Operator.OR;
      case 'not':
        return Operator.NOT;
      default:
        return Operator.UNDEFINED;
    }
  }
}

var operatorList = [
  Operator.EQUAL,
  Operator.NOT_EQUAL,
  Operator.GREATER_THAN,
  Operator.GREATER_THAN_OR_EQUAL,
  Operator.LESS_THAN,
  Operator.LESS_THAN_OR_EQUAL,
];

extension ComparisonOperatorsExtension on Operator {
  bool get isComparison {
    return this == Operator.EQUAL ||
        this == Operator.NOT_EQUAL ||
        this == Operator.GREATER_THAN ||
        this == Operator.GREATER_THAN_OR_EQUAL ||
        this == Operator.LESS_THAN ||
        this == Operator.LESS_THAN_OR_EQUAL;
  }

  String get symbol {
    switch (this) {
      case Operator.EQUAL:
        return "==";
      case Operator.NOT_EQUAL:
        return "!=";
      case Operator.GREATER_THAN:
        return ">";
      case Operator.GREATER_THAN_OR_EQUAL:
        return ">=";
      case Operator.LESS_THAN:
        return "<";
      case Operator.LESS_THAN_OR_EQUAL:
        return "<=";
      default:
        return '';
    }
  }

  static Operator fromString(String value) {
    switch (value) {
      case "==":
        return Operator.EQUAL;
      case "!=":
        return Operator.NOT_EQUAL;
      case ">":
        return Operator.GREATER_THAN;
      case ">=":
        return Operator.GREATER_THAN_OR_EQUAL;
      case "<":
        return Operator.LESS_THAN;
      case "<=":
        return Operator.LESS_THAN_OR_EQUAL;
      default:
        return Operator.UNDEFINED;
    }
  }
}

extension PeriodTypeExtension on PeriodType {
  static PeriodType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'MSEC':
        return PeriodType.MSEC;
      case 'SEC':
        return PeriodType.SEC;
      case 'MIN':
        return PeriodType.MIN;
      case 'HOUR':
        return PeriodType.HOUR;
      case 'DAY':
        return PeriodType.DAY;
      default:
        return PeriodType.UNDEFINED;
    }
  }

  String toDisplayName(int? value) {
    if (value == null) return '';
    switch (this) {
      case PeriodType.MSEC:
        return '$value밀리초';
      case PeriodType.SEC:
        return '$value초';
      case PeriodType.MIN:
        return '$value분';
      case PeriodType.HOUR:
        return '$value시간';
      case PeriodType.DAY:
        return '매일';
      default:
        return '';
    }
  }

  String get toName {
    switch (this) {
      case PeriodType.MSEC:
        return '밀리초';
      case PeriodType.SEC:
        return '초';
      case PeriodType.MIN:
        return '분';
      case PeriodType.HOUR:
        return '시간';
      case PeriodType.DAY:
        return '매일';
      default:
        return '';
    }
  }

  String get value {
    switch (this) {
      case PeriodType.MSEC:
        return 'MSEC';
      case PeriodType.SEC:
        return 'SEC';
      case PeriodType.MIN:
        return 'MIN';
      case PeriodType.HOUR:
        return 'HOUR';
      case PeriodType.DAY:
        return 'DAY';
      default:
        return '';
    }
  }
}

extension LiteralTypeExtension on LiteralType {
  String get toDisplayName {
    switch (this) {
      case LiteralType.INTEGER:
        return '숫자';
      case LiteralType.DOUBLE:
        return '실수';
      case LiteralType.BOOL:
        return '불리언';
      case LiteralType.STRING:
        return '문자열';
      case LiteralType.VARIABLE:
        return '변수';
      default:
        return '';
    }
  }
}

extension FunctionServiceReturnTypeParser on String {
  FunctionServiceReturnType get toFunctionServiceReturnType {
    switch (toLowerCase()) {
      case 'void':
        return FunctionServiceReturnType.VOID;
      case 'int':
        return FunctionServiceReturnType.INTEGER;
      case 'double':
        return FunctionServiceReturnType.DOUBLE;
      case 'bool':
        return FunctionServiceReturnType.BOOL;
      case 'string':
        return FunctionServiceReturnType.STRING;
      case 'binary':
        return FunctionServiceReturnType.BINARY;
      default:
        return FunctionServiceReturnType.UNDEFINED;
    }
  }
}

extension WeekdayExtension on WeekDay {
  String get value {
    switch (this) {
      case WeekDay.MONDAY:
        return 'Monday';
      case WeekDay.TUESDAY:
        return 'Tuesday';
      case WeekDay.WEDNESDAY:
        return 'Wednesday';
      case WeekDay.THURSDAY:
        return 'Thursday';
      case WeekDay.FRIDAY:
        return 'Friday';
      case WeekDay.SATURDAY:
        return 'Saturday';
      case WeekDay.SUNDAY:
        return 'Sunday';
      default:
        return '';
    }
  }

  String get toWeekDayString {
    switch (this) {
      case WeekDay.MONDAY:
        return '월요일';
      case WeekDay.TUESDAY:
        return '화요일';
      case WeekDay.WEDNESDAY:
        return '수요일';
      case WeekDay.THURSDAY:
        return '목요일';
      case WeekDay.FRIDAY:
        return '금요일';
      case WeekDay.SATURDAY:
        return '토요일';
      case WeekDay.SUNDAY:
        return '일요일';
      default:
        return '';
    }
  }

  int get toInt {
    switch (this) {
      case WeekDay.MONDAY:
        return 1;
      case WeekDay.TUESDAY:
        return 2;
      case WeekDay.WEDNESDAY:
        return 3;
      case WeekDay.THURSDAY:
        return 4;
      case WeekDay.FRIDAY:
        return 5;
      case WeekDay.SATURDAY:
        return 6;
      case WeekDay.SUNDAY:
        return 7;
      default:
        return 0;
    }
  }

  String get toWeekDayShortString {
    switch (this) {
      case WeekDay.MONDAY:
        return '월';
      case WeekDay.TUESDAY:
        return '화';
      case WeekDay.WEDNESDAY:
        return '수';
      case WeekDay.THURSDAY:
        return '목';
      case WeekDay.FRIDAY:
        return '금';
      case WeekDay.SATURDAY:
        return '토';
      case WeekDay.SUNDAY:
        return '일';
      default:
        return '';
    }
  }

  static WeekDay fromString(String value) {
    switch (value.toLowerCase()) {
      case 'monday':
        return WeekDay.MONDAY;
      case 'tuesday':
        return WeekDay.TUESDAY;
      case 'wednesday':
        return WeekDay.WEDNESDAY;
      case 'thursday':
        return WeekDay.THURSDAY;
      case 'friday':
        return WeekDay.FRIDAY;
      case 'saturday':
        return WeekDay.SATURDAY;
      case 'sunday':
        return WeekDay.SUNDAY;
      default:
        return WeekDay.UNDEFINED;
    }
  }
}

extension TimeServiceTypeExtension on TimeServiceType {
  String get value {
    switch (this) {
      case TimeServiceType.DATETIME:
        return 'datetime_double';
      case TimeServiceType.DATE:
        return 'date_double';
      case TimeServiceType.TIME:
        return 'time_double';
      default:
        return '';
    }
  }

  static TimeServiceType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'datetime_double' || 'datetime':
        return TimeServiceType.DATETIME;
      case 'date_double' || 'date':
        return TimeServiceType.DATE;
      case 'time_double' || 'time':
        return TimeServiceType.TIME;
      case 'weekday':
        return TimeServiceType.WEEKDAY;
      default:
        return TimeServiceType.UNDEFINED;
    }
  }
}

extension WeekDayParser on int {
  WeekDay get toWeekDayEnum {
    switch (this) {
      case 0:
        return WeekDay.SUNDAY;
      case 1:
        return WeekDay.MONDAY;
      case 2:
        return WeekDay.TUESDAY;
      case 3:
        return WeekDay.WEDNESDAY;
      case 4:
        return WeekDay.THURSDAY;
      case 5:
        return WeekDay.FRIDAY;
      case 6:
        return WeekDay.SATURDAY;

      default:
        return WeekDay.UNDEFINED;
    }
  }
}

extension LoopModeExtension on LoopMode {
  String get toNamed {
    switch (this) {
      case LoopMode.MANUAL:
        return '사용자 설정';
      case LoopMode.DAILY:
        return '매일';
      case LoopMode.WEEKLY:
        return '매주';
      case LoopMode.WEEKDAYSELECT:
        return '요일 선택';
      default:
        return '';
    }
  }

  String get toShortNamed {
    switch (this) {
      case LoopMode.MANUAL:
        return '사용자 설정';
      case LoopMode.DAILY:
        return '매일';
      case LoopMode.WEEKLY:
        return '매주';
      case LoopMode.WEEKDAYSELECT:
        return '평일';
      default:
        return '';
    }
  }
}
