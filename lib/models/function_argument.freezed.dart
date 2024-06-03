// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'function_argument.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FunctionArgument _$FunctionArgumentFromJson(Map<String, dynamic> json) {
  return _FunctionArgument.fromJson(json);
}

/// @nodoc
mixin _$FunctionArgument {
  ArgumentType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  Bound? get bound => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FunctionArgumentCopyWith<FunctionArgument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FunctionArgumentCopyWith<$Res> {
  factory $FunctionArgumentCopyWith(
          FunctionArgument value, $Res Function(FunctionArgument) then) =
      _$FunctionArgumentCopyWithImpl<$Res, FunctionArgument>;
  @useResult
  $Res call(
      {ArgumentType type, String name, int order, Bound? bound, dynamic value});

  $BoundCopyWith<$Res>? get bound;
}

/// @nodoc
class _$FunctionArgumentCopyWithImpl<$Res, $Val extends FunctionArgument>
    implements $FunctionArgumentCopyWith<$Res> {
  _$FunctionArgumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? order = null,
    Object? bound = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ArgumentType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      bound: freezed == bound
          ? _value.bound
          : bound // ignore: cast_nullable_to_non_nullable
              as Bound?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoundCopyWith<$Res>? get bound {
    if (_value.bound == null) {
      return null;
    }

    return $BoundCopyWith<$Res>(_value.bound!, (value) {
      return _then(_value.copyWith(bound: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FunctionArgumentImplCopyWith<$Res>
    implements $FunctionArgumentCopyWith<$Res> {
  factory _$$FunctionArgumentImplCopyWith(_$FunctionArgumentImpl value,
          $Res Function(_$FunctionArgumentImpl) then) =
      __$$FunctionArgumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ArgumentType type, String name, int order, Bound? bound, dynamic value});

  @override
  $BoundCopyWith<$Res>? get bound;
}

/// @nodoc
class __$$FunctionArgumentImplCopyWithImpl<$Res>
    extends _$FunctionArgumentCopyWithImpl<$Res, _$FunctionArgumentImpl>
    implements _$$FunctionArgumentImplCopyWith<$Res> {
  __$$FunctionArgumentImplCopyWithImpl(_$FunctionArgumentImpl _value,
      $Res Function(_$FunctionArgumentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? order = null,
    Object? bound = freezed,
    Object? value = freezed,
  }) {
    return _then(_$FunctionArgumentImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ArgumentType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      bound: freezed == bound
          ? _value.bound
          : bound // ignore: cast_nullable_to_non_nullable
              as Bound?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FunctionArgumentImpl implements _FunctionArgument {
  const _$FunctionArgumentImpl(
      {required this.type,
      required this.name,
      required this.order,
      this.bound,
      this.value});

  factory _$FunctionArgumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FunctionArgumentImplFromJson(json);

  @override
  final ArgumentType type;
  @override
  final String name;
  @override
  final int order;
  @override
  final Bound? bound;
  @override
  final dynamic value;

  @override
  String toString() {
    return 'FunctionArgument(type: $type, name: $name, order: $order, bound: $bound, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FunctionArgumentImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.bound, bound) || other.bound == bound) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, name, order, bound,
      const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FunctionArgumentImplCopyWith<_$FunctionArgumentImpl> get copyWith =>
      __$$FunctionArgumentImplCopyWithImpl<_$FunctionArgumentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FunctionArgumentImplToJson(
      this,
    );
  }
}

abstract class _FunctionArgument implements FunctionArgument {
  const factory _FunctionArgument(
      {required final ArgumentType type,
      required final String name,
      required final int order,
      final Bound? bound,
      final dynamic value}) = _$FunctionArgumentImpl;

  factory _FunctionArgument.fromJson(Map<String, dynamic> json) =
      _$FunctionArgumentImpl.fromJson;

  @override
  ArgumentType get type;
  @override
  String get name;
  @override
  int get order;
  @override
  Bound? get bound;
  @override
  dynamic get value;
  @override
  @JsonKey(ignore: true)
  _$$FunctionArgumentImplCopyWith<_$FunctionArgumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
