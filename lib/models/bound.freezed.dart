// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bound.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Bound _$BoundFromJson(Map<String, dynamic> json) {
  return _Bound.fromJson(json);
}

/// @nodoc
mixin _$Bound {
  dynamic get min_value => throw _privateConstructorUsedError;
  dynamic get max_value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BoundCopyWith<Bound> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoundCopyWith<$Res> {
  factory $BoundCopyWith(Bound value, $Res Function(Bound) then) =
      _$BoundCopyWithImpl<$Res, Bound>;
  @useResult
  $Res call({dynamic min_value, dynamic max_value});
}

/// @nodoc
class _$BoundCopyWithImpl<$Res, $Val extends Bound>
    implements $BoundCopyWith<$Res> {
  _$BoundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min_value = freezed,
    Object? max_value = freezed,
  }) {
    return _then(_value.copyWith(
      min_value: freezed == min_value
          ? _value.min_value
          : min_value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      max_value: freezed == max_value
          ? _value.max_value
          : max_value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoundImplCopyWith<$Res> implements $BoundCopyWith<$Res> {
  factory _$$BoundImplCopyWith(
          _$BoundImpl value, $Res Function(_$BoundImpl) then) =
      __$$BoundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic min_value, dynamic max_value});
}

/// @nodoc
class __$$BoundImplCopyWithImpl<$Res>
    extends _$BoundCopyWithImpl<$Res, _$BoundImpl>
    implements _$$BoundImplCopyWith<$Res> {
  __$$BoundImplCopyWithImpl(
      _$BoundImpl _value, $Res Function(_$BoundImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min_value = freezed,
    Object? max_value = freezed,
  }) {
    return _then(_$BoundImpl(
      min_value: freezed == min_value
          ? _value.min_value
          : min_value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      max_value: freezed == max_value
          ? _value.max_value
          : max_value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoundImpl implements _Bound {
  const _$BoundImpl({this.min_value, this.max_value});

  factory _$BoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoundImplFromJson(json);

  @override
  final dynamic min_value;
  @override
  final dynamic max_value;

  @override
  String toString() {
    return 'Bound(min_value: $min_value, max_value: $max_value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoundImpl &&
            const DeepCollectionEquality().equals(other.min_value, min_value) &&
            const DeepCollectionEquality().equals(other.max_value, max_value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(min_value),
      const DeepCollectionEquality().hash(max_value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoundImplCopyWith<_$BoundImpl> get copyWith =>
      __$$BoundImplCopyWithImpl<_$BoundImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoundImplToJson(
      this,
    );
  }
}

abstract class _Bound implements Bound {
  const factory _Bound({final dynamic min_value, final dynamic max_value}) =
      _$BoundImpl;

  factory _Bound.fromJson(Map<String, dynamic> json) = _$BoundImpl.fromJson;

  @override
  dynamic get min_value;
  @override
  dynamic get max_value;
  @override
  @JsonKey(ignore: true)
  _$$BoundImplCopyWith<_$BoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
