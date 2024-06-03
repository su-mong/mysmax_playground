// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return _Service.fromJson(json);
}

/// @nodoc
mixin _$Service {
  String get middleware => throw _privateConstructorUsedError;
  String get hierarchy => throw _privateConstructorUsedError;
  List<Thing> get things => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceCopyWith<Service> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceCopyWith<$Res> {
  factory $ServiceCopyWith(Service value, $Res Function(Service) then) =
      _$ServiceCopyWithImpl<$Res, Service>;
  @useResult
  $Res call({String middleware, String hierarchy, List<Thing> things});
}

/// @nodoc
class _$ServiceCopyWithImpl<$Res, $Val extends Service>
    implements $ServiceCopyWith<$Res> {
  _$ServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? middleware = null,
    Object? hierarchy = null,
    Object? things = null,
  }) {
    return _then(_value.copyWith(
      middleware: null == middleware
          ? _value.middleware
          : middleware // ignore: cast_nullable_to_non_nullable
              as String,
      hierarchy: null == hierarchy
          ? _value.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String,
      things: null == things
          ? _value.things
          : things // ignore: cast_nullable_to_non_nullable
              as List<Thing>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceImplCopyWith<$Res> implements $ServiceCopyWith<$Res> {
  factory _$$ServiceImplCopyWith(
          _$ServiceImpl value, $Res Function(_$ServiceImpl) then) =
      __$$ServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String middleware, String hierarchy, List<Thing> things});
}

/// @nodoc
class __$$ServiceImplCopyWithImpl<$Res>
    extends _$ServiceCopyWithImpl<$Res, _$ServiceImpl>
    implements _$$ServiceImplCopyWith<$Res> {
  __$$ServiceImplCopyWithImpl(
      _$ServiceImpl _value, $Res Function(_$ServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? middleware = null,
    Object? hierarchy = null,
    Object? things = null,
  }) {
    return _then(_$ServiceImpl(
      middleware: null == middleware
          ? _value.middleware
          : middleware // ignore: cast_nullable_to_non_nullable
              as String,
      hierarchy: null == hierarchy
          ? _value.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String,
      things: null == things
          ? _value._things
          : things // ignore: cast_nullable_to_non_nullable
              as List<Thing>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceImpl implements _Service {
  const _$ServiceImpl(
      {required this.middleware,
      required this.hierarchy,
      required final List<Thing> things})
      : _things = things;

  factory _$ServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceImplFromJson(json);

  @override
  final String middleware;
  @override
  final String hierarchy;
  final List<Thing> _things;
  @override
  List<Thing> get things {
    if (_things is EqualUnmodifiableListView) return _things;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_things);
  }

  @override
  String toString() {
    return 'Service(middleware: $middleware, hierarchy: $hierarchy, things: $things)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceImpl &&
            (identical(other.middleware, middleware) ||
                other.middleware == middleware) &&
            (identical(other.hierarchy, hierarchy) ||
                other.hierarchy == hierarchy) &&
            const DeepCollectionEquality().equals(other._things, _things));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, middleware, hierarchy,
      const DeepCollectionEquality().hash(_things));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      __$$ServiceImplCopyWithImpl<_$ServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceImplToJson(
      this,
    );
  }
}

abstract class _Service implements Service {
  const factory _Service(
      {required final String middleware,
      required final String hierarchy,
      required final List<Thing> things}) = _$ServiceImpl;

  factory _Service.fromJson(Map<String, dynamic> json) = _$ServiceImpl.fromJson;

  @override
  String get middleware;
  @override
  String get hierarchy;
  @override
  List<Thing> get things;
  @override
  @JsonKey(ignore: true)
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
