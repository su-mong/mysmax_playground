import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/scenario_code_parser/expression.dart';
import 'bound.dart';
import 'enums/argument_type.dart';

part 'function_argument.freezed.dart';
part 'function_argument.g.dart';

// {
//           "type": {"int"|"double"|"bool"|"string"|"binary"},
//           "name": {string},
//           "order": {int},
//           "bound": {
//             "min_value": {int|double},
//             "max_value": {int|double}
//           }
//         }

@freezed
class FunctionArgument with _$FunctionArgument {
  const factory FunctionArgument({
    required ArgumentType type,
    required String name,
    required int order,
    Bound? bound,
    dynamic value,
  }) = _FunctionArgument;

  factory FunctionArgument.fromJson(Map<String, dynamic> json) =>
      _$FunctionArgumentFromJson(json);
}

extension FunctionArgumentExtension on FunctionArgument {
  LiteralExpression get toLiteralExpression {
    return LiteralExpression(
      value,
      literalType: type.toLiteralType,
    );
  }
}
