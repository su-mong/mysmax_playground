import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/models/tag.dart';

import '../core/scenario_code_parser/block.dart';
import 'function_argument.dart';

part 'thing_function.freezed.dart';
part 'thing_function.g.dart';

// {
//       "name": {string},
//       "description": {string},
//       "exec_time": {int|double},
//       "energy": {int|double},
//       "is_private": {0|1},
//       "is_opened": {0|1},
//       "is_available": {0|1},
//       "return_type": {"int"|"double"|"bool"|"string"|"binary"|"void"},
//       "use_arg": {0|1},
//       "tags": [
//         {
//           "name": {string}
//         },
//         ...
//       ],
//       "arguments": [
//         {
//           "type": {"int"|"double"|"bool"|"string"|"binary"},
//           "name": {string},
//           "order": {int},
//           "bound": {
//             "min_value": {int|double},
//             "max_value": {int|double}
//           }
//         },
//         ...
//       ]
//     },

@freezed
class ThingFunction with _$ThingFunction {
  const factory ThingFunction({
    required String name,
    required String description,
    required String category,
    required int exec_time,
    required int energy,
    required int is_private,
    required int is_opened,
    // required int is_available,
    required String return_type,
    required int use_arg,
    List<Tag>? tags,
    List<FunctionArgument>? arguments,
  }) = _ThingFunction;

  factory ThingFunction.fromJson(Map<String, dynamic> json) =>
      _$ThingFunctionFromJson(json);

  operator ==(o) => o is ThingFunction && o.name == name;
}

extension ThingFunctionExtension on ThingFunction {
  List<FunctionArgument>? sortedArguments() {
    var list = List<FunctionArgument>.from(arguments ?? []);
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  bool get canExecute {
    return use_arg == 0 ||
        (use_arg == 1 &&
            (arguments?.every(
                    (e) => e.value != null && e.value.toString().isNotEmpty) ??
                false));
  }

  FunctionServiceBlock toBlock({
    required bool isAll,
    required List<String> selectedTags,
    required String? variableName,
  }) {
    return FunctionServiceBlock(
      name,
      selectedTags,
      return_type.toFunctionServiceReturnType,
      arguments?.map((e) => e.toLiteralExpression).toList() ?? [],
      variableName,
      isAll ? RangeType.ALL : RangeType.AUTO,
    );
  }

  FunctionServiceBlock toBlockV2({
    required RangeType rangeType,
    required List<String> selectedDeviceTags,
    required String? variableName,
  }) {
    return FunctionServiceBlock(
      name,
      selectedDeviceTags,
      return_type.toFunctionServiceReturnType,
      arguments?.map((e) => e.toLiteralExpression).toList() ?? [],
      variableName,
      rangeType,
    );
  }
}
