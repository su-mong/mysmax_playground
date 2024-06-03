// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thing_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThingValueImpl _$$ThingValueImplFromJson(Map<String, dynamic> json) =>
    _$ThingValueImpl(
      name: json['name'] as String,
      category: json['category'] as String?,
      description: json['description'] as String,
      is_private: json['is_private'] as int,
      is_opened: json['is_opened'] as int,
      latest_val: json['latest_val'],
      type: json['type'] as String,
      bound: json['bound'] == null
          ? null
          : Bound.fromJson(json['bound'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ThingValueImplToJson(_$ThingValueImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'is_private': instance.is_private,
      'is_opened': instance.is_opened,
      'latest_val': instance.latest_val,
      'type': instance.type,
      'bound': instance.bound,
      'tags': instance.tags,
    };
