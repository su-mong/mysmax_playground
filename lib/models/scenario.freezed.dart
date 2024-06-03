// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Scenario _$ScenarioFromJson(Map<String, dynamic> json) {
  return _Scenario.fromJson(json);
}

/// @nodoc
mixin _$Scenario {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get contents => throw _privateConstructorUsedError;
  ScenarioState get state => throw _privateConstructorUsedError;
  int? get is_opened => throw _privateConstructorUsedError;
  int? get priority => throw _privateConstructorUsedError;
  List<ScheduledThing> get scheduled_things =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScenarioCopyWith<Scenario> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioCopyWith<$Res> {
  factory $ScenarioCopyWith(Scenario value, $Res Function(Scenario) then) =
      _$ScenarioCopyWithImpl<$Res, Scenario>;
  @useResult
  $Res call(
      {int id,
      String name,
      String contents,
      ScenarioState state,
      int? is_opened,
      int? priority,
      List<ScheduledThing> scheduled_things});
}

/// @nodoc
class _$ScenarioCopyWithImpl<$Res, $Val extends Scenario>
    implements $ScenarioCopyWith<$Res> {
  _$ScenarioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contents = null,
    Object? state = null,
    Object? is_opened = freezed,
    Object? priority = freezed,
    Object? scheduled_things = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contents: null == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ScenarioState,
      is_opened: freezed == is_opened
          ? _value.is_opened
          : is_opened // ignore: cast_nullable_to_non_nullable
              as int?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduled_things: null == scheduled_things
          ? _value.scheduled_things
          : scheduled_things // ignore: cast_nullable_to_non_nullable
              as List<ScheduledThing>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScenarioImplCopyWith<$Res>
    implements $ScenarioCopyWith<$Res> {
  factory _$$ScenarioImplCopyWith(
          _$ScenarioImpl value, $Res Function(_$ScenarioImpl) then) =
      __$$ScenarioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String contents,
      ScenarioState state,
      int? is_opened,
      int? priority,
      List<ScheduledThing> scheduled_things});
}

/// @nodoc
class __$$ScenarioImplCopyWithImpl<$Res>
    extends _$ScenarioCopyWithImpl<$Res, _$ScenarioImpl>
    implements _$$ScenarioImplCopyWith<$Res> {
  __$$ScenarioImplCopyWithImpl(
      _$ScenarioImpl _value, $Res Function(_$ScenarioImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contents = null,
    Object? state = null,
    Object? is_opened = freezed,
    Object? priority = freezed,
    Object? scheduled_things = null,
  }) {
    return _then(_$ScenarioImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contents: null == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ScenarioState,
      is_opened: freezed == is_opened
          ? _value.is_opened
          : is_opened // ignore: cast_nullable_to_non_nullable
              as int?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduled_things: null == scheduled_things
          ? _value._scheduled_things
          : scheduled_things // ignore: cast_nullable_to_non_nullable
              as List<ScheduledThing>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioImpl implements _Scenario {
  const _$ScenarioImpl(
      {required this.id,
      required this.name,
      required this.contents,
      required this.state,
      this.is_opened,
      this.priority,
      required final List<ScheduledThing> scheduled_things})
      : _scheduled_things = scheduled_things;

  factory _$ScenarioImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String contents;
  @override
  final ScenarioState state;
  @override
  final int? is_opened;
  @override
  final int? priority;
  final List<ScheduledThing> _scheduled_things;
  @override
  List<ScheduledThing> get scheduled_things {
    if (_scheduled_things is EqualUnmodifiableListView)
      return _scheduled_things;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scheduled_things);
  }

  @override
  String toString() {
    return 'Scenario(id: $id, name: $name, contents: $contents, state: $state, is_opened: $is_opened, priority: $priority, scheduled_things: $scheduled_things)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contents, contents) ||
                other.contents == contents) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.is_opened, is_opened) ||
                other.is_opened == is_opened) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality()
                .equals(other._scheduled_things, _scheduled_things));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      contents,
      state,
      is_opened,
      priority,
      const DeepCollectionEquality().hash(_scheduled_things));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioImplCopyWith<_$ScenarioImpl> get copyWith =>
      __$$ScenarioImplCopyWithImpl<_$ScenarioImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioImplToJson(
      this,
    );
  }
}

abstract class _Scenario implements Scenario {
  const factory _Scenario(
      {required final int id,
      required final String name,
      required final String contents,
      required final ScenarioState state,
      final int? is_opened,
      final int? priority,
      required final List<ScheduledThing> scheduled_things}) = _$ScenarioImpl;

  factory _Scenario.fromJson(Map<String, dynamic> json) =
      _$ScenarioImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get contents;
  @override
  ScenarioState get state;
  @override
  int? get is_opened;
  @override
  int? get priority;
  @override
  List<ScheduledThing> get scheduled_things;
  @override
  @JsonKey(ignore: true)
  _$$ScenarioImplCopyWith<_$ScenarioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
