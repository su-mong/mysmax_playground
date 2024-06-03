import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysmax_playground/models/tag.dart';

part 'scheduled_thing.freezed.dart';
part 'scheduled_thing.g.dart';

//  {
//       "service": "_(#thing1).func_no_arg",
//       "things": [
//         {
//           "name": "thing1"
//         }
//       ]
//     }

@freezed
class ScheduledThing with _$ScheduledThing {
  const factory ScheduledThing({
    required String service,
    required List<Tag> things,
  }) = _ScheduledThing;

  factory ScheduledThing.fromJson(Map<String, dynamic> json) =>
      _$ScheduledThingFromJson(json);
}
