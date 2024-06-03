// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScenarioImpl _$$ScenarioImplFromJson(Map<String, dynamic> json) =>
    _$ScenarioImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      contents: json['contents'] as String,
      state: $enumDecode(_$ScenarioStateEnumMap, json['state']),
      is_opened: json['is_opened'] as int?,
      priority: json['priority'] as int?,
      scheduled_things: (json['scheduled_things'] as List<dynamic>)
          .map((e) => ScheduledThing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScenarioImplToJson(_$ScenarioImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contents': instance.contents,
      'state': _$ScenarioStateEnumMap[instance.state]!,
      'is_opened': instance.is_opened,
      'priority': instance.priority,
      'scheduled_things': instance.scheduled_things,
    };

const _$ScenarioStateEnumMap = {
  ScenarioState.created: 'created',
  ScenarioState.scheduling: 'scheduling',
  ScenarioState.initialized: 'initialized',
  ScenarioState.running: 'running',
  ScenarioState.executing: 'executing',
  ScenarioState.stucked: 'stucked',
  ScenarioState.completed: 'completed',
};
