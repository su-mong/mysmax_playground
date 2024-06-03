// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThingImpl _$$ThingImplFromJson(Map<String, dynamic> json) => _$ThingImpl(
      name: json['name'] as String,
      nick_name: json['nick_name'] as String,
      category: json['category'] as String?,
      version: json['version'] as String?,
      description: json['description'] as String,
      is_alive: json['is_alive'] as int,
      is_super: json['is_super'] as int,
      is_parallel: json['is_parallel'] as int,
      is_manager: json['is_manager'] as int,
      is_matter: json['is_matter'] as int,
      alive_cycle: json['alive_cycle'] as int,
      hierarchy: json['hierarchy'] as String?,
      middleware: json['middleware'] as String?,
      error: json['error'] as int?,
      values: (json['values'] as List<dynamic>)
          .map((e) => ThingValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      functions: (json['functions'] as List<dynamic>)
          .map((e) => ThingFunction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ThingImplToJson(_$ThingImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nick_name': instance.nick_name,
      'category': instance.category,
      'version': instance.version,
      'description': instance.description,
      'is_alive': instance.is_alive,
      'is_super': instance.is_super,
      'is_parallel': instance.is_parallel,
      'is_manager': instance.is_manager,
      'is_matter': instance.is_matter,
      'alive_cycle': instance.alive_cycle,
      'hierarchy': instance.hierarchy,
      'middleware': instance.middleware,
      'error': instance.error,
      'values': instance.values,
      'functions': instance.functions,
    };
