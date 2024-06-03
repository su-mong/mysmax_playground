// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_thing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScheduledThing _$ScheduledThingFromJson(Map<String, dynamic> json) {
  return _ScheduledThing.fromJson(json);
}

/// @nodoc
mixin _$ScheduledThing {
  String get service => throw _privateConstructorUsedError;
  List<Tag> get things => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduledThingCopyWith<ScheduledThing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduledThingCopyWith<$Res> {
  factory $ScheduledThingCopyWith(
          ScheduledThing value, $Res Function(ScheduledThing) then) =
      _$ScheduledThingCopyWithImpl<$Res, ScheduledThing>;
  @useResult
  $Res call({String service, List<Tag> things});
}

/// @nodoc
class _$ScheduledThingCopyWithImpl<$Res, $Val extends ScheduledThing>
    implements $ScheduledThingCopyWith<$Res> {
  _$ScheduledThingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = null,
    Object? things = null,
  }) {
    return _then(_value.copyWith(
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      things: null == things
          ? _value.things
          : things // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduledThingImplCopyWith<$Res>
    implements $ScheduledThingCopyWith<$Res> {
  factory _$$ScheduledThingImplCopyWith(_$ScheduledThingImpl value,
          $Res Function(_$ScheduledThingImpl) then) =
      __$$ScheduledThingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String service, List<Tag> things});
}

/// @nodoc
class __$$ScheduledThingImplCopyWithImpl<$Res>
    extends _$ScheduledThingCopyWithImpl<$Res, _$ScheduledThingImpl>
    implements _$$ScheduledThingImplCopyWith<$Res> {
  __$$ScheduledThingImplCopyWithImpl(
      _$ScheduledThingImpl _value, $Res Function(_$ScheduledThingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = null,
    Object? things = null,
  }) {
    return _then(_$ScheduledThingImpl(
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      things: null == things
          ? _value._things
          : things // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduledThingImpl implements _ScheduledThing {
  const _$ScheduledThingImpl(
      {required this.service, required final List<Tag> things})
      : _things = things;

  factory _$ScheduledThingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduledThingImplFromJson(json);

  @override
  final String service;
  final List<Tag> _things;
  @override
  List<Tag> get things {
    if (_things is EqualUnmodifiableListView) return _things;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_things);
  }

  @override
  String toString() {
    return 'ScheduledThing(service: $service, things: $things)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduledThingImpl &&
            (identical(other.service, service) || other.service == service) &&
            const DeepCollectionEquality().equals(other._things, _things));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, service, const DeepCollectionEquality().hash(_things));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduledThingImplCopyWith<_$ScheduledThingImpl> get copyWith =>
      __$$ScheduledThingImplCopyWithImpl<_$ScheduledThingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduledThingImplToJson(
      this,
    );
  }
}

abstract class _ScheduledThing implements ScheduledThing {
  const factory _ScheduledThing(
      {required final String service,
      required final List<Tag> things}) = _$ScheduledThingImpl;

  factory _ScheduledThing.fromJson(Map<String, dynamic> json) =
      _$ScheduledThingImpl.fromJson;

  @override
  String get service;
  @override
  List<Tag> get things;
  @override
  @JsonKey(ignore: true)
  _$$ScheduledThingImplCopyWith<_$ScheduledThingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
