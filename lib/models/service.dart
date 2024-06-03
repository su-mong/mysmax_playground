import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysmax_playground/models/thing.dart';

part 'service.freezed.dart';
part 'service.g.dart';

// {
// "middleware": "MySSIX-MW-Lv1-0_D45D64A628DB",
// "hierarchy": "local",
// "things": [
// {
// "name": "weather_builtin_big_thing",
// "nick_name": "weather_builtin_big_thing",
// "description": "",
// "is_alive": 1,
// "is_super": 0,
// "is_parallel": 1,
// "is_manager": 0,
// "is_matter": 0,
// "alive_cycle": 60,
// "values": [],
// "functions": [
// {
// "name": "humid",
// "description": "No Information",
// "return_type": "double",
// "use_arg": 0,
// "is_private": 0,
// "is_opened": 0,
// "is_available": 0,
// "exec_time": 5000,
// "energy": 0,
// "tags": [
// {
// "name": "big_thing"
// },
// {
// "name": "weather"
// },
// {
// "name": "weather_builtin_big_thing"
// }
// ]
// },
// {
// "name": "pressure",
// "description": "No Information",
// "return_type": "double",
// "use_arg": 0,
// "is_private": 0,
// "is_opened": 0,
// "is_available": 0,
// "exec_time": 5000,
// "energy": 0,
// "tags": [
// {
// "name": "big_thing"
// },
// {
// "name": "weather"
// },
// {
// "name": "weather_builtin_big_thing"
// }
// ]
// },
// {
// "name": "temp",
// "description": "No Information",
// "return_type": "double",
// "use_arg": 0,
// "is_private": 0,
// "is_opened": 0,
// "is_available": 0,
// "exec_time": 5000,
// "energy": 0,
// "tags": [
// {
// "name": "big_thing"
// },
// {
// "name": "weather"
// },
// {
// "name": "weather_builtin_big_thing"
// }
// ]
// },
// {
// "name": "weather",
// "description": "No Information",
// "return_type": "string",
// "use_arg": 0,
// "is_private": 0,
// "is_opened": 0,
// "is_available": 0,
// "exec_time": 5000,
// "energy": 0,
// "tags": [
// {
// "name": "big_thing"
// },
// {
// "name": "weather"
// },
// {
// "name": "weather_builtin_big_thing"
// }
// ]
// },
// {
// "name": "weather_info",
// "description": "No Information",
// "return_type": "string",
// "use_arg": 1,
// "is_private": 0,
// "is_opened": 0,
// "is_available": 0,
// "exec_time": 5000,
// "energy": 0,
// "tags": [
// {
// "name": "big_thing"
// },
// {
// "name": "weather"
// },
// {
// "name": "weather_builtin_big_thing"
// }
// ],
// "arguments": [
// {
// "name": "lat",
// "order": 0,
// "type": "double",
// "bound": {
// "min_value": "0.00",
// "max_value": "10000.00"
// }
// },
// {
// "name": "lon",
// "order": 1,
// "type": "double",
// "bound": {
// "min_value": "0.00",
// "max_value": "10000.00"
// }
// },
// {
// "name": "location",
// "order": 2,
// "type": "string",
// "bound": {
// "min_value": "0",
// "max_value": "10000"
// }
// }
// ]
// }
// ]
// }
// ]
// }

@freezed
class Service with _$Service {
  const factory Service({
    required String middleware,
    required String hierarchy,
    required List<Thing> things,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}
