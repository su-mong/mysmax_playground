// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thing_function.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThingFunctionImpl _$$ThingFunctionImplFromJson(Map<String, dynamic> json) =>
    _$ThingFunctionImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      exec_time: json['exec_time'] as int,
      energy: json['energy'] as int,
      is_private: json['is_private'] as int,
      is_opened: json['is_opened'] as int,
      return_type: json['return_type'] as String,
      use_arg: json['use_arg'] as int,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      arguments: (json['arguments'] as List<dynamic>?)
          ?.map((e) => FunctionArgument.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ThingFunctionImplToJson(_$ThingFunctionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'exec_time': instance.exec_time,
      'energy': instance.energy,
      'is_private': instance.is_private,
      'is_opened': instance.is_opened,
      'return_type': instance.return_type,
      'use_arg': instance.use_arg,
      'tags': instance.tags,
      'arguments': instance.arguments,
    };
