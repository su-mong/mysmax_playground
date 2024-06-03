// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scenario_samples.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScenarioSamples _$ScenarioSamplesFromJson(Map<String, dynamic> json) {
  return _ScenarioSamples.fromJson(json);
}

/// @nodoc
mixin _$ScenarioSamples {
  List<ScenarioCategory> get samples => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScenarioSamplesCopyWith<ScenarioSamples> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioSamplesCopyWith<$Res> {
  factory $ScenarioSamplesCopyWith(
          ScenarioSamples value, $Res Function(ScenarioSamples) then) =
      _$ScenarioSamplesCopyWithImpl<$Res, ScenarioSamples>;
  @useResult
  $Res call({List<ScenarioCategory> samples});
}

/// @nodoc
class _$ScenarioSamplesCopyWithImpl<$Res, $Val extends ScenarioSamples>
    implements $ScenarioSamplesCopyWith<$Res> {
  _$ScenarioSamplesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? samples = null,
  }) {
    return _then(_value.copyWith(
      samples: null == samples
          ? _value.samples
          : samples // ignore: cast_nullable_to_non_nullable
              as List<ScenarioCategory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScenarioSamplesImplCopyWith<$Res>
    implements $ScenarioSamplesCopyWith<$Res> {
  factory _$$ScenarioSamplesImplCopyWith(_$ScenarioSamplesImpl value,
          $Res Function(_$ScenarioSamplesImpl) then) =
      __$$ScenarioSamplesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ScenarioCategory> samples});
}

/// @nodoc
class __$$ScenarioSamplesImplCopyWithImpl<$Res>
    extends _$ScenarioSamplesCopyWithImpl<$Res, _$ScenarioSamplesImpl>
    implements _$$ScenarioSamplesImplCopyWith<$Res> {
  __$$ScenarioSamplesImplCopyWithImpl(
      _$ScenarioSamplesImpl _value, $Res Function(_$ScenarioSamplesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? samples = null,
  }) {
    return _then(_$ScenarioSamplesImpl(
      samples: null == samples
          ? _value._samples
          : samples // ignore: cast_nullable_to_non_nullable
              as List<ScenarioCategory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioSamplesImpl implements _ScenarioSamples {
  const _$ScenarioSamplesImpl({required final List<ScenarioCategory> samples})
      : _samples = samples;

  factory _$ScenarioSamplesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioSamplesImplFromJson(json);

  final List<ScenarioCategory> _samples;
  @override
  List<ScenarioCategory> get samples {
    if (_samples is EqualUnmodifiableListView) return _samples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_samples);
  }

  @override
  String toString() {
    return 'ScenarioSamples(samples: $samples)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioSamplesImpl &&
            const DeepCollectionEquality().equals(other._samples, _samples));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_samples));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioSamplesImplCopyWith<_$ScenarioSamplesImpl> get copyWith =>
      __$$ScenarioSamplesImplCopyWithImpl<_$ScenarioSamplesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioSamplesImplToJson(
      this,
    );
  }
}

abstract class _ScenarioSamples implements ScenarioSamples {
  const factory _ScenarioSamples(
      {required final List<ScenarioCategory> samples}) = _$ScenarioSamplesImpl;

  factory _ScenarioSamples.fromJson(Map<String, dynamic> json) =
      _$ScenarioSamplesImpl.fromJson;

  @override
  List<ScenarioCategory> get samples;
  @override
  @JsonKey(ignore: true)
  _$$ScenarioSamplesImplCopyWith<_$ScenarioSamplesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScenarioCategory _$ScenarioCategoryFromJson(Map<String, dynamic> json) {
  return _ScenarioCategory.fromJson(json);
}

/// @nodoc
mixin _$ScenarioCategory {
  String get category => throw _privateConstructorUsedError;
  String get category_description => throw _privateConstructorUsedError;
  List<ScenarioSampleData> get scenarios => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScenarioCategoryCopyWith<ScenarioCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioCategoryCopyWith<$Res> {
  factory $ScenarioCategoryCopyWith(
          ScenarioCategory value, $Res Function(ScenarioCategory) then) =
      _$ScenarioCategoryCopyWithImpl<$Res, ScenarioCategory>;
  @useResult
  $Res call(
      {String category,
      String category_description,
      List<ScenarioSampleData> scenarios});
}

/// @nodoc
class _$ScenarioCategoryCopyWithImpl<$Res, $Val extends ScenarioCategory>
    implements $ScenarioCategoryCopyWith<$Res> {
  _$ScenarioCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? category_description = null,
    Object? scenarios = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      category_description: null == category_description
          ? _value.category_description
          : category_description // ignore: cast_nullable_to_non_nullable
              as String,
      scenarios: null == scenarios
          ? _value.scenarios
          : scenarios // ignore: cast_nullable_to_non_nullable
              as List<ScenarioSampleData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScenarioCategoryImplCopyWith<$Res>
    implements $ScenarioCategoryCopyWith<$Res> {
  factory _$$ScenarioCategoryImplCopyWith(_$ScenarioCategoryImpl value,
          $Res Function(_$ScenarioCategoryImpl) then) =
      __$$ScenarioCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String category,
      String category_description,
      List<ScenarioSampleData> scenarios});
}

/// @nodoc
class __$$ScenarioCategoryImplCopyWithImpl<$Res>
    extends _$ScenarioCategoryCopyWithImpl<$Res, _$ScenarioCategoryImpl>
    implements _$$ScenarioCategoryImplCopyWith<$Res> {
  __$$ScenarioCategoryImplCopyWithImpl(_$ScenarioCategoryImpl _value,
      $Res Function(_$ScenarioCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? category_description = null,
    Object? scenarios = null,
  }) {
    return _then(_$ScenarioCategoryImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      category_description: null == category_description
          ? _value.category_description
          : category_description // ignore: cast_nullable_to_non_nullable
              as String,
      scenarios: null == scenarios
          ? _value._scenarios
          : scenarios // ignore: cast_nullable_to_non_nullable
              as List<ScenarioSampleData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioCategoryImpl implements _ScenarioCategory {
  const _$ScenarioCategoryImpl(
      {required this.category,
      required this.category_description,
      required final List<ScenarioSampleData> scenarios})
      : _scenarios = scenarios;

  factory _$ScenarioCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioCategoryImplFromJson(json);

  @override
  final String category;
  @override
  final String category_description;
  final List<ScenarioSampleData> _scenarios;
  @override
  List<ScenarioSampleData> get scenarios {
    if (_scenarios is EqualUnmodifiableListView) return _scenarios;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scenarios);
  }

  @override
  String toString() {
    return 'ScenarioCategory(category: $category, category_description: $category_description, scenarios: $scenarios)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.category_description, category_description) ||
                other.category_description == category_description) &&
            const DeepCollectionEquality()
                .equals(other._scenarios, _scenarios));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category, category_description,
      const DeepCollectionEquality().hash(_scenarios));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioCategoryImplCopyWith<_$ScenarioCategoryImpl> get copyWith =>
      __$$ScenarioCategoryImplCopyWithImpl<_$ScenarioCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioCategoryImplToJson(
      this,
    );
  }
}

abstract class _ScenarioCategory implements ScenarioCategory {
  const factory _ScenarioCategory(
          {required final String category,
          required final String category_description,
          required final List<ScenarioSampleData> scenarios}) =
      _$ScenarioCategoryImpl;

  factory _ScenarioCategory.fromJson(Map<String, dynamic> json) =
      _$ScenarioCategoryImpl.fromJson;

  @override
  String get category;
  @override
  String get category_description;
  @override
  List<ScenarioSampleData> get scenarios;
  @override
  @JsonKey(ignore: true)
  _$$ScenarioCategoryImplCopyWith<_$ScenarioCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScenarioSampleData _$ScenarioSampleDataFromJson(Map<String, dynamic> json) {
  return _ScenarioSampleData.fromJson(json);
}

/// @nodoc
mixin _$ScenarioSampleData {
  String get name => throw _privateConstructorUsedError;
  String get intro => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<ScenarioRequirement> get requirements =>
      throw _privateConstructorUsedError;
  String get scenario_code => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScenarioSampleDataCopyWith<ScenarioSampleData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioSampleDataCopyWith<$Res> {
  factory $ScenarioSampleDataCopyWith(
          ScenarioSampleData value, $Res Function(ScenarioSampleData) then) =
      _$ScenarioSampleDataCopyWithImpl<$Res, ScenarioSampleData>;
  @useResult
  $Res call(
      {String name,
      String intro,
      String description,
      List<ScenarioRequirement> requirements,
      String scenario_code});
}

/// @nodoc
class _$ScenarioSampleDataCopyWithImpl<$Res, $Val extends ScenarioSampleData>
    implements $ScenarioSampleDataCopyWith<$Res> {
  _$ScenarioSampleDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? intro = null,
    Object? description = null,
    Object? requirements = null,
    Object? scenario_code = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      intro: null == intro
          ? _value.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requirements: null == requirements
          ? _value.requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as List<ScenarioRequirement>,
      scenario_code: null == scenario_code
          ? _value.scenario_code
          : scenario_code // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScenarioSampleDataImplCopyWith<$Res>
    implements $ScenarioSampleDataCopyWith<$Res> {
  factory _$$ScenarioSampleDataImplCopyWith(_$ScenarioSampleDataImpl value,
          $Res Function(_$ScenarioSampleDataImpl) then) =
      __$$ScenarioSampleDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String intro,
      String description,
      List<ScenarioRequirement> requirements,
      String scenario_code});
}

/// @nodoc
class __$$ScenarioSampleDataImplCopyWithImpl<$Res>
    extends _$ScenarioSampleDataCopyWithImpl<$Res, _$ScenarioSampleDataImpl>
    implements _$$ScenarioSampleDataImplCopyWith<$Res> {
  __$$ScenarioSampleDataImplCopyWithImpl(_$ScenarioSampleDataImpl _value,
      $Res Function(_$ScenarioSampleDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? intro = null,
    Object? description = null,
    Object? requirements = null,
    Object? scenario_code = null,
  }) {
    return _then(_$ScenarioSampleDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      intro: null == intro
          ? _value.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requirements: null == requirements
          ? _value._requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as List<ScenarioRequirement>,
      scenario_code: null == scenario_code
          ? _value.scenario_code
          : scenario_code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioSampleDataImpl implements _ScenarioSampleData {
  const _$ScenarioSampleDataImpl(
      {required this.name,
      required this.intro,
      required this.description,
      required final List<ScenarioRequirement> requirements,
      required this.scenario_code})
      : _requirements = requirements;

  factory _$ScenarioSampleDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioSampleDataImplFromJson(json);

  @override
  final String name;
  @override
  final String intro;
  @override
  final String description;
  final List<ScenarioRequirement> _requirements;
  @override
  List<ScenarioRequirement> get requirements {
    if (_requirements is EqualUnmodifiableListView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requirements);
  }

  @override
  final String scenario_code;

  @override
  String toString() {
    return 'ScenarioSampleData(name: $name, intro: $intro, description: $description, requirements: $requirements, scenario_code: $scenario_code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioSampleDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._requirements, _requirements) &&
            (identical(other.scenario_code, scenario_code) ||
                other.scenario_code == scenario_code));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, intro, description,
      const DeepCollectionEquality().hash(_requirements), scenario_code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioSampleDataImplCopyWith<_$ScenarioSampleDataImpl> get copyWith =>
      __$$ScenarioSampleDataImplCopyWithImpl<_$ScenarioSampleDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioSampleDataImplToJson(
      this,
    );
  }
}

abstract class _ScenarioSampleData implements ScenarioSampleData {
  const factory _ScenarioSampleData(
      {required final String name,
      required final String intro,
      required final String description,
      required final List<ScenarioRequirement> requirements,
      required final String scenario_code}) = _$ScenarioSampleDataImpl;

  factory _ScenarioSampleData.fromJson(Map<String, dynamic> json) =
      _$ScenarioSampleDataImpl.fromJson;

  @override
  String get name;
  @override
  String get intro;
  @override
  String get description;
  @override
  List<ScenarioRequirement> get requirements;
  @override
  String get scenario_code;
  @override
  @JsonKey(ignore: true)
  _$$ScenarioSampleDataImplCopyWith<_$ScenarioSampleDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScenarioRequirement _$ScenarioRequirementFromJson(Map<String, dynamic> json) {
  return _ScenarioRequirement.fromJson(json);
}

/// @nodoc
mixin _$ScenarioRequirement {
  String get thing => throw _privateConstructorUsedError;
  String get service => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScenarioRequirementCopyWith<ScenarioRequirement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioRequirementCopyWith<$Res> {
  factory $ScenarioRequirementCopyWith(
          ScenarioRequirement value, $Res Function(ScenarioRequirement) then) =
      _$ScenarioRequirementCopyWithImpl<$Res, ScenarioRequirement>;
  @useResult
  $Res call({String thing, String service});
}

/// @nodoc
class _$ScenarioRequirementCopyWithImpl<$Res, $Val extends ScenarioRequirement>
    implements $ScenarioRequirementCopyWith<$Res> {
  _$ScenarioRequirementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thing = null,
    Object? service = null,
  }) {
    return _then(_value.copyWith(
      thing: null == thing
          ? _value.thing
          : thing // ignore: cast_nullable_to_non_nullable
              as String,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScenarioRequirementImplCopyWith<$Res>
    implements $ScenarioRequirementCopyWith<$Res> {
  factory _$$ScenarioRequirementImplCopyWith(_$ScenarioRequirementImpl value,
          $Res Function(_$ScenarioRequirementImpl) then) =
      __$$ScenarioRequirementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String thing, String service});
}

/// @nodoc
class __$$ScenarioRequirementImplCopyWithImpl<$Res>
    extends _$ScenarioRequirementCopyWithImpl<$Res, _$ScenarioRequirementImpl>
    implements _$$ScenarioRequirementImplCopyWith<$Res> {
  __$$ScenarioRequirementImplCopyWithImpl(_$ScenarioRequirementImpl _value,
      $Res Function(_$ScenarioRequirementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thing = null,
    Object? service = null,
  }) {
    return _then(_$ScenarioRequirementImpl(
      thing: null == thing
          ? _value.thing
          : thing // ignore: cast_nullable_to_non_nullable
              as String,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioRequirementImpl implements _ScenarioRequirement {
  const _$ScenarioRequirementImpl({required this.thing, required this.service});

  factory _$ScenarioRequirementImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioRequirementImplFromJson(json);

  @override
  final String thing;
  @override
  final String service;

  @override
  String toString() {
    return 'ScenarioRequirement(thing: $thing, service: $service)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioRequirementImpl &&
            (identical(other.thing, thing) || other.thing == thing) &&
            (identical(other.service, service) || other.service == service));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, thing, service);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioRequirementImplCopyWith<_$ScenarioRequirementImpl> get copyWith =>
      __$$ScenarioRequirementImplCopyWithImpl<_$ScenarioRequirementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioRequirementImplToJson(
      this,
    );
  }
}

abstract class _ScenarioRequirement implements ScenarioRequirement {
  const factory _ScenarioRequirement(
      {required final String thing,
      required final String service}) = _$ScenarioRequirementImpl;

  factory _ScenarioRequirement.fromJson(Map<String, dynamic> json) =
      _$ScenarioRequirementImpl.fromJson;

  @override
  String get thing;
  @override
  String get service;
  @override
  @JsonKey(ignore: true)
  _$$ScenarioRequirementImplCopyWith<_$ScenarioRequirementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
