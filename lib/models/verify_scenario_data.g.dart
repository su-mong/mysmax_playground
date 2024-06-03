// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_scenario_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerifyScenarioDataImpl _$$VerifyScenarioDataImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyScenarioDataImpl(
      name: json['name'] as String,
      error: (json['error'] as num).toInt(),
      error_string: json['error_string'] as String?,
    );

Map<String, dynamic> _$$VerifyScenarioDataImplToJson(
        _$VerifyScenarioDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'error': instance.error,
      'error_string': instance.error_string,
    };
