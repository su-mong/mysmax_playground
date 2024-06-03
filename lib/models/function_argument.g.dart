// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_argument.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FunctionArgumentImpl _$$FunctionArgumentImplFromJson(
        Map<String, dynamic> json) =>
    _$FunctionArgumentImpl(
      type: $enumDecode(_$ArgumentTypeEnumMap, json['type']),
      name: json['name'] as String,
      order: json['order'] as int,
      bound: json['bound'] == null
          ? null
          : Bound.fromJson(json['bound'] as Map<String, dynamic>),
      value: json['value'],
    );

Map<String, dynamic> _$$FunctionArgumentImplToJson(
        _$FunctionArgumentImpl instance) =>
    <String, dynamic>{
      'type': _$ArgumentTypeEnumMap[instance.type]!,
      'name': instance.name,
      'order': instance.order,
      'bound': instance.bound,
      'value': instance.value,
    };

const _$ArgumentTypeEnumMap = {
  ArgumentType.string: 'string',
  ArgumentType.double: 'double',
  ArgumentType.int: 'int',
  ArgumentType.bool: 'bool',
  ArgumentType.binary: 'binary',
};
