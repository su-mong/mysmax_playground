// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_scenario_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerifyScenarioData _$VerifyScenarioDataFromJson(Map<String, dynamic> json) {
  return _VerifyScenarioData.fromJson(json);
}

/// @nodoc
mixin _$VerifyScenarioData {
  String get name => throw _privateConstructorUsedError;
  int get error => throw _privateConstructorUsedError;
  String? get error_string => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerifyScenarioDataCopyWith<VerifyScenarioData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyScenarioDataCopyWith<$Res> {
  factory $VerifyScenarioDataCopyWith(
          VerifyScenarioData value, $Res Function(VerifyScenarioData) then) =
      _$VerifyScenarioDataCopyWithImpl<$Res, VerifyScenarioData>;
  @useResult
  $Res call({String name, int error, String? error_string});
}

/// @nodoc
class _$VerifyScenarioDataCopyWithImpl<$Res, $Val extends VerifyScenarioData>
    implements $VerifyScenarioDataCopyWith<$Res> {
  _$VerifyScenarioDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? error = null,
    Object? error_string = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      error_string: freezed == error_string
          ? _value.error_string
          : error_string // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyScenarioDataImplCopyWith<$Res>
    implements $VerifyScenarioDataCopyWith<$Res> {
  factory _$$VerifyScenarioDataImplCopyWith(_$VerifyScenarioDataImpl value,
          $Res Function(_$VerifyScenarioDataImpl) then) =
      __$$VerifyScenarioDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int error, String? error_string});
}

/// @nodoc
class __$$VerifyScenarioDataImplCopyWithImpl<$Res>
    extends _$VerifyScenarioDataCopyWithImpl<$Res, _$VerifyScenarioDataImpl>
    implements _$$VerifyScenarioDataImplCopyWith<$Res> {
  __$$VerifyScenarioDataImplCopyWithImpl(_$VerifyScenarioDataImpl _value,
      $Res Function(_$VerifyScenarioDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? error = null,
    Object? error_string = freezed,
  }) {
    return _then(_$VerifyScenarioDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      error_string: freezed == error_string
          ? _value.error_string
          : error_string // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyScenarioDataImpl implements _VerifyScenarioData {
  const _$VerifyScenarioDataImpl(
      {required this.name, required this.error, required this.error_string});

  factory _$VerifyScenarioDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyScenarioDataImplFromJson(json);

  @override
  final String name;
  @override
  final int error;
  @override
  final String? error_string;

  @override
  String toString() {
    return 'VerifyScenarioData(name: $name, error: $error, error_string: $error_string)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyScenarioDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.error_string, error_string) ||
                other.error_string == error_string));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, error, error_string);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyScenarioDataImplCopyWith<_$VerifyScenarioDataImpl> get copyWith =>
      __$$VerifyScenarioDataImplCopyWithImpl<_$VerifyScenarioDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyScenarioDataImplToJson(
      this,
    );
  }
}

abstract class _VerifyScenarioData implements VerifyScenarioData {
  const factory _VerifyScenarioData(
      {required final String name,
      required final int error,
      required final String? error_string}) = _$VerifyScenarioDataImpl;

  factory _VerifyScenarioData.fromJson(Map<String, dynamic> json) =
      _$VerifyScenarioDataImpl.fromJson;

  @override
  String get name;
  @override
  int get error;
  @override
  String? get error_string;
  @override
  @JsonKey(ignore: true)
  _$$VerifyScenarioDataImplCopyWith<_$VerifyScenarioDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
