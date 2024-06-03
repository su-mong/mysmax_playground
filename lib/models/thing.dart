import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysmax_playground/models/thing_function.dart';
import 'package:mysmax_playground/models/thing_value.dart';

part 'thing.freezed.dart';
part 'thing.g.dart';

// {
// 	"name": {string},
// 	"is_alive": {0|1},
// 	"is_super": {0|1},
// 	"is_parallel": {0|1},
// 	"hierarchy": {"local"|"parent"|"child"},
// 	"middleware": {string},
// 	"error": {0|-1|-5}, // 0: no_error(exist), -1: invaild name string, -5: Thing not exist
// 	"alive_cycle": {int|double},
//   "values": [
//     {
//       "name": {string},
//       "description": {string},
//       "is_private": {0|1},
//       "is_opened": {0|1},
//       "latest_val": {int|double|str|bool},
//       "updated_on": {string},
//       "type": {"int"|"double"|"bool"|"string"|"binary"},
//       "bound": {
//         "min_value": {int|double},
//         "max_value": {int|double}
//       },
//       "tags": [
//         {
//           "name": {string}
//         }
//         ...
//       ]
//     }
//     ...
//   ],
//   "functions": [
//     {
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
//     ...
//   ],
// }
@freezed
class Thing with _$Thing {
  const factory Thing({
    required String name,
    required String nick_name,
    String? category,
    String? version,
    required String description,
    required int is_alive,
    required int is_super,
    required int is_parallel,
    required int is_manager,
    required int is_matter,
    required int alive_cycle,
    String? hierarchy,
    String? middleware,
    int? error,
    required List<ThingValue> values,
    required List<ThingFunction> functions,
  }) = _Thing;

  factory Thing.fromJson(Map<String, dynamic> json) => _$ThingFromJson(json);
}

extension ThingExtension on Thing {
  int get is_opened {
    bool valuesOpened = values.any((element) => element.is_opened == 1);
    bool functionsOpened = functions.any((element) => element.is_opened == 1);
    return valuesOpened || functionsOpened ? 1 : 0;
  }
}
