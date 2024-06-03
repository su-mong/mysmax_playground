import '../../core/scenario_code_parser/enums.dart';

enum ArgumentType {
  string,
  double,
  int,
  bool,
  binary,
}

extension ArgumentTypeExtension on ArgumentType {
  String get name {
    switch (this) {
      case ArgumentType.string:
        return 'string';
      case ArgumentType.double:
        return 'double';
      case ArgumentType.int:
        return 'int';
      case ArgumentType.bool:
        return 'bool';
      default:
        return '';
    }
  }

  LiteralType get toLiteralType {
    switch (this) {
      case ArgumentType.string:
        return LiteralType.STRING;
      case ArgumentType.double:
        return LiteralType.DOUBLE;
      case ArgumentType.int:
        return LiteralType.INTEGER;
      case ArgumentType.bool:
        return LiteralType.BOOL;
      default:
        return LiteralType.STRING;
    }
  }
}

extension StringExtension on String {
  ArgumentType get toArgumentType {
    switch (this) {
      case 'string':
        return ArgumentType.string;
      case 'double':
        return ArgumentType.double;
      case 'int':
        return ArgumentType.int;
      case 'bool':
        return ArgumentType.bool;
      default:
        return ArgumentType.string;
    }
  }
}
