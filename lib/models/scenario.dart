import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysmax_playground/models/enums/scenario_state.dart';
import 'package:mysmax_playground/models/scheduled_thing.dart';

part 'scenario.freezed.dart';
part 'scenario.g.dart';

// {
//   "id": 1,
//   "name": "a",
//   "contents": "(#thing1).func_no_arg()",
//   "state": "initialized",
//   "scheduled_things": [
//     {
//       "service": "_(#thing1).func_no_arg",
//       "things": [
//         {
//           "name": "thing1"
//         }
//       ]
//     }
//   ]
// }

@freezed
class Scenario with _$Scenario {
  const factory Scenario({
    required int id,
    required String name,
    required String contents,
    required ScenarioState state,
    int? is_opened,
    int? priority,
    required List<ScheduledThing> scheduled_things,
  }) = _Scenario;

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);
}
