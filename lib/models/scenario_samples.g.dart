// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario_samples.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScenarioSamplesImpl _$$ScenarioSamplesImplFromJson(
        Map<String, dynamic> json) =>
    _$ScenarioSamplesImpl(
      samples: (json['samples'] as List<dynamic>)
          .map((e) => ScenarioCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScenarioSamplesImplToJson(
        _$ScenarioSamplesImpl instance) =>
    <String, dynamic>{
      'samples': instance.samples,
    };

_$ScenarioCategoryImpl _$$ScenarioCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ScenarioCategoryImpl(
      category: json['category'] as String,
      category_description: json['category_description'] as String,
      scenarios: (json['scenarios'] as List<dynamic>)
          .map((e) => ScenarioSampleData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScenarioCategoryImplToJson(
        _$ScenarioCategoryImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'category_description': instance.category_description,
      'scenarios': instance.scenarios,
    };

_$ScenarioSampleDataImpl _$$ScenarioSampleDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ScenarioSampleDataImpl(
      name: json['name'] as String,
      intro: json['intro'] as String,
      description: json['description'] as String,
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => ScenarioRequirement.fromJson(e as Map<String, dynamic>))
          .toList(),
      scenario_code: json['scenario_code'] as String,
    );

Map<String, dynamic> _$$ScenarioSampleDataImplToJson(
        _$ScenarioSampleDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'intro': instance.intro,
      'description': instance.description,
      'requirements': instance.requirements,
      'scenario_code': instance.scenario_code,
    };

_$ScenarioRequirementImpl _$$ScenarioRequirementImplFromJson(
        Map<String, dynamic> json) =>
    _$ScenarioRequirementImpl(
      thing: json['thing'] as String,
      service: json['service'] as String,
    );

Map<String, dynamic> _$$ScenarioRequirementImplToJson(
        _$ScenarioRequirementImpl instance) =>
    <String, dynamic>{
      'thing': instance.thing,
      'service': instance.service,
    };
