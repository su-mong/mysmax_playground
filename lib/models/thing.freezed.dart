// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Thing _$ThingFromJson(Map<String, dynamic> json) {
  return _Thing.fromJson(json);
}

/// @nodoc
mixin _$Thing {
  String get name => throw _privateConstructorUsedError;
  String get nick_name => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get is_alive => throw _privateConstructorUsedError;
  int get is_super => throw _privateConstructorUsedError;
  int get is_parallel => throw _privateConstructorUsedError;
  int get is_manager => throw _privateConstructorUsedError;
  int get is_matter => throw _privateConstructorUsedError;
  int get alive_cycle => throw _privateConstructorUsedError;
  String? get hierarchy => throw _privateConstructorUsedError;
  String? get middleware => throw _privateConstructorUsedError;
  int? get error => throw _privateConstructorUsedError;
  List<ThingValue> get values => throw _privateConstructorUsedError;
  List<ThingFunction> get functions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThingCopyWith<Thing> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThingCopyWith<$Res> {
  factory $ThingCopyWith(Thing value, $Res Function(Thing) then) =
      _$ThingCopyWithImpl<$Res, Thing>;
  @useResult
  $Res call(
      {String name,
      String nick_name,
      String? category,
      String? version,
      String description,
      int is_alive,
      int is_super,
      int is_parallel,
      int is_manager,
      int is_matter,
      int alive_cycle,
      String? hierarchy,
      String? middleware,
      int? error,
      List<ThingValue> values,
      List<ThingFunction> functions});
}

/// @nodoc
class _$ThingCopyWithImpl<$Res, $Val extends Thing>
    implements $ThingCopyWith<$Res> {
  _$ThingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? nick_name = null,
    Object? category = freezed,
    Object? version = freezed,
    Object? description = null,
    Object? is_alive = null,
    Object? is_super = null,
    Object? is_parallel = null,
    Object? is_manager = null,
    Object? is_matter = null,
    Object? alive_cycle = null,
    Object? hierarchy = freezed,
    Object? middleware = freezed,
    Object? error = freezed,
    Object? values = null,
    Object? functions = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nick_name: null == nick_name
          ? _value.nick_name
          : nick_name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      is_alive: null == is_alive
          ? _value.is_alive
          : is_alive // ignore: cast_nullable_to_non_nullable
              as int,
      is_super: null == is_super
          ? _value.is_super
          : is_super // ignore: cast_nullable_to_non_nullable
              as int,
      is_parallel: null == is_parallel
          ? _value.is_parallel
          : is_parallel // ignore: cast_nullable_to_non_nullable
              as int,
      is_manager: null == is_manager
          ? _value.is_manager
          : is_manager // ignore: cast_nullable_to_non_nullable
              as int,
      is_matter: null == is_matter
          ? _value.is_matter
          : is_matter // ignore: cast_nullable_to_non_nullable
              as int,
      alive_cycle: null == alive_cycle
          ? _value.alive_cycle
          : alive_cycle // ignore: cast_nullable_to_non_nullable
              as int,
      hierarchy: freezed == hierarchy
          ? _value.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String?,
      middleware: freezed == middleware
          ? _value.middleware
          : middleware // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int?,
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<ThingValue>,
      functions: null == functions
          ? _value.functions
          : functions // ignore: cast_nullable_to_non_nullable
              as List<ThingFunction>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThingImplCopyWith<$Res> implements $ThingCopyWith<$Res> {
  factory _$$ThingImplCopyWith(
          _$ThingImpl value, $Res Function(_$ThingImpl) then) =
      __$$ThingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String nick_name,
      String? category,
      String? version,
      String description,
      int is_alive,
      int is_super,
      int is_parallel,
      int is_manager,
      int is_matter,
      int alive_cycle,
      String? hierarchy,
      String? middleware,
      int? error,
      List<ThingValue> values,
      List<ThingFunction> functions});
}

/// @nodoc
class __$$ThingImplCopyWithImpl<$Res>
    extends _$ThingCopyWithImpl<$Res, _$ThingImpl>
    implements _$$ThingImplCopyWith<$Res> {
  __$$ThingImplCopyWithImpl(
      _$ThingImpl _value, $Res Function(_$ThingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? nick_name = null,
    Object? category = freezed,
    Object? version = freezed,
    Object? description = null,
    Object? is_alive = null,
    Object? is_super = null,
    Object? is_parallel = null,
    Object? is_manager = null,
    Object? is_matter = null,
    Object? alive_cycle = null,
    Object? hierarchy = freezed,
    Object? middleware = freezed,
    Object? error = freezed,
    Object? values = null,
    Object? functions = null,
  }) {
    return _then(_$ThingImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nick_name: null == nick_name
          ? _value.nick_name
          : nick_name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      is_alive: null == is_alive
          ? _value.is_alive
          : is_alive // ignore: cast_nullable_to_non_nullable
              as int,
      is_super: null == is_super
          ? _value.is_super
          : is_super // ignore: cast_nullable_to_non_nullable
              as int,
      is_parallel: null == is_parallel
          ? _value.is_parallel
          : is_parallel // ignore: cast_nullable_to_non_nullable
              as int,
      is_manager: null == is_manager
          ? _value.is_manager
          : is_manager // ignore: cast_nullable_to_non_nullable
              as int,
      is_matter: null == is_matter
          ? _value.is_matter
          : is_matter // ignore: cast_nullable_to_non_nullable
              as int,
      alive_cycle: null == alive_cycle
          ? _value.alive_cycle
          : alive_cycle // ignore: cast_nullable_to_non_nullable
              as int,
      hierarchy: freezed == hierarchy
          ? _value.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String?,
      middleware: freezed == middleware
          ? _value.middleware
          : middleware // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int?,
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<ThingValue>,
      functions: null == functions
          ? _value._functions
          : functions // ignore: cast_nullable_to_non_nullable
              as List<ThingFunction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThingImpl implements _Thing {
  const _$ThingImpl(
      {required this.name,
      required this.nick_name,
      this.category,
      this.version,
      required this.description,
      required this.is_alive,
      required this.is_super,
      required this.is_parallel,
      required this.is_manager,
      required this.is_matter,
      required this.alive_cycle,
      this.hierarchy,
      this.middleware,
      this.error,
      required final List<ThingValue> values,
      required final List<ThingFunction> functions})
      : _values = values,
        _functions = functions;

  factory _$ThingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThingImplFromJson(json);

  @override
  final String name;
  @override
  final String nick_name;
  @override
  final String? category;
  @override
  final String? version;
  @override
  final String description;
  @override
  final int is_alive;
  @override
  final int is_super;
  @override
  final int is_parallel;
  @override
  final int is_manager;
  @override
  final int is_matter;
  @override
  final int alive_cycle;
  @override
  final String? hierarchy;
  @override
  final String? middleware;
  @override
  final int? error;
  final List<ThingValue> _values;
  @override
  List<ThingValue> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  final List<ThingFunction> _functions;
  @override
  List<ThingFunction> get functions {
    if (_functions is EqualUnmodifiableListView) return _functions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_functions);
  }

  @override
  String toString() {
    return 'Thing(name: $name, nick_name: $nick_name, category: $category, version: $version, description: $description, is_alive: $is_alive, is_super: $is_super, is_parallel: $is_parallel, is_manager: $is_manager, is_matter: $is_matter, alive_cycle: $alive_cycle, hierarchy: $hierarchy, middleware: $middleware, error: $error, values: $values, functions: $functions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThingImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nick_name, nick_name) ||
                other.nick_name == nick_name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.is_alive, is_alive) ||
                other.is_alive == is_alive) &&
            (identical(other.is_super, is_super) ||
                other.is_super == is_super) &&
            (identical(other.is_parallel, is_parallel) ||
                other.is_parallel == is_parallel) &&
            (identical(other.is_manager, is_manager) ||
                other.is_manager == is_manager) &&
            (identical(other.is_matter, is_matter) ||
                other.is_matter == is_matter) &&
            (identical(other.alive_cycle, alive_cycle) ||
                other.alive_cycle == alive_cycle) &&
            (identical(other.hierarchy, hierarchy) ||
                other.hierarchy == hierarchy) &&
            (identical(other.middleware, middleware) ||
                other.middleware == middleware) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            const DeepCollectionEquality()
                .equals(other._functions, _functions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      nick_name,
      category,
      version,
      description,
      is_alive,
      is_super,
      is_parallel,
      is_manager,
      is_matter,
      alive_cycle,
      hierarchy,
      middleware,
      error,
      const DeepCollectionEquality().hash(_values),
      const DeepCollectionEquality().hash(_functions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThingImplCopyWith<_$ThingImpl> get copyWith =>
      __$$ThingImplCopyWithImpl<_$ThingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThingImplToJson(
      this,
    );
  }
}

abstract class _Thing implements Thing {
  const factory _Thing(
      {required final String name,
      required final String nick_name,
      final String? category,
      final String? version,
      required final String description,
      required final int is_alive,
      required final int is_super,
      required final int is_parallel,
      required final int is_manager,
      required final int is_matter,
      required final int alive_cycle,
      final String? hierarchy,
      final String? middleware,
      final int? error,
      required final List<ThingValue> values,
      required final List<ThingFunction> functions}) = _$ThingImpl;

  factory _Thing.fromJson(Map<String, dynamic> json) = _$ThingImpl.fromJson;

  @override
  String get name;
  @override
  String get nick_name;
  @override
  String? get category;
  @override
  String? get version;
  @override
  String get description;
  @override
  int get is_alive;
  @override
  int get is_super;
  @override
  int get is_parallel;
  @override
  int get is_manager;
  @override
  int get is_matter;
  @override
  int get alive_cycle;
  @override
  String? get hierarchy;
  @override
  String? get middleware;
  @override
  int? get error;
  @override
  List<ThingValue> get values;
  @override
  List<ThingFunction> get functions;
  @override
  @JsonKey(ignore: true)
  _$$ThingImplCopyWith<_$ThingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
