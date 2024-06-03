// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_thing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduledThingImpl _$$ScheduledThingImplFromJson(Map<String, dynamic> json) =>
    _$ScheduledThingImpl(
      service: json['service'] as String,
      things: (json['things'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScheduledThingImplToJson(
        _$ScheduledThingImpl instance) =>
    <String, dynamic>{
      'service': instance.service,
      'things': instance.things,
    };
