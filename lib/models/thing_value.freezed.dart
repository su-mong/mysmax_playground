// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thing_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThingValue _$ThingValueFromJson(Map<String, dynamic> json) {
  return _ThingValue.fromJson(json);
}

/// @nodoc
mixin _$ThingValue {
  String get name => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get is_private => throw _privateConstructorUsedError;
  int get is_opened => throw _privateConstructorUsedError;
  dynamic get latest_val =>
      throw _privateConstructorUsedError; // required String updated_on,
  String get type => throw _privateConstructorUsedError;
  Bound? get bound => throw _privateConstructorUsedError;
  List<Tag> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThingValueCopyWith<ThingValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThingValueCopyWith<$Res> {
  factory $ThingValueCopyWith(
          ThingValue value, $Res Function(ThingValue) then) =
      _$ThingValueCopyWithImpl<$Res, ThingValue>;
  @useResult
  $Res call(
      {String name,
      String? category,
      String description,
      int is_private,
      int is_opened,
      dynamic latest_val,
      String type,
      Bound? bound,
      List<Tag> tags});

  $BoundCopyWith<$Res>? get bound;
}

/// @nodoc
class _$ThingValueCopyWithImpl<$Res, $Val extends ThingValue>
    implements $ThingValueCopyWith<$Res> {
  _$ThingValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = freezed,
    Object? description = null,
    Object? is_private = null,
    Object? is_opened = null,
    Object? latest_val = freezed,
    Object? type = null,
    Object? bound = freezed,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      is_private: null == is_private
          ? _value.is_private
          : is_private // ignore: cast_nullable_to_non_nullable
              as int,
      is_opened: null == is_opened
          ? _value.is_opened
          : is_opened // ignore: cast_nullable_to_non_nullable
              as int,
      latest_val: freezed == latest_val
          ? _value.latest_val
          : latest_val // ignore: cast_nullable_to_non_nullable
              as dynamic,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      bound: freezed == bound
          ? _value.bound
          : bound // ignore: cast_nullable_to_non_nullable
              as Bound?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
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
abstract class _$$ThingValueImplCopyWith<$Res>
    implements $ThingValueCopyWith<$Res> {
  factory _$$ThingValueImplCopyWith(
          _$ThingValueImpl value, $Res Function(_$ThingValueImpl) then) =
      __$$ThingValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? category,
      String description,
      int is_private,
      int is_opened,
      dynamic latest_val,
      String type,
      Bound? bound,
      List<Tag> tags});

  @override
  $BoundCopyWith<$Res>? get bound;
}

/// @nodoc
class __$$ThingValueImplCopyWithImpl<$Res>
    extends _$ThingValueCopyWithImpl<$Res, _$ThingValueImpl>
    implements _$$ThingValueImplCopyWith<$Res> {
  __$$ThingValueImplCopyWithImpl(
      _$ThingValueImpl _value, $Res Function(_$ThingValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = freezed,
    Object? description = null,
    Object? is_private = null,
    Object? is_opened = null,
    Object? latest_val = freezed,
    Object? type = null,
    Object? bound = freezed,
    Object? tags = null,
  }) {
    return _then(_$ThingValueImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      is_private: null == is_private
          ? _value.is_private
          : is_private // ignore: cast_nullable_to_non_nullable
              as int,
      is_opened: null == is_opened
          ? _value.is_opened
          : is_opened // ignore: cast_nullable_to_non_nullable
              as int,
      latest_val: freezed == latest_val
          ? _value.latest_val
          : latest_val // ignore: cast_nullable_to_non_nullable
              as dynamic,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      bound: freezed == bound
          ? _value.bound
          : bound // ignore: cast_nullable_to_non_nullable
              as Bound?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThingValueImpl implements _ThingValue {
  const _$ThingValueImpl(
      {required this.name,
      this.category,
      required this.description,
      required this.is_private,
      required this.is_opened,
      required this.latest_val,
      required this.type,
      this.bound,
      required final List<Tag> tags})
      : _tags = tags;

  factory _$ThingValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThingValueImplFromJson(json);

  @override
  final String name;
  @override
  final String? category;
  @override
  final String description;
  @override
  final int is_private;
  @override
  final int is_opened;
  @override
  final dynamic latest_val;
// required String updated_on,
  @override
  final String type;
  @override
  final Bound? bound;
  final List<Tag> _tags;
  @override
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'ThingValue(name: $name, category: $category, description: $description, is_private: $is_private, is_opened: $is_opened, latest_val: $latest_val, type: $type, bound: $bound, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThingValueImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.is_private, is_private) ||
                other.is_private == is_private) &&
            (identical(other.is_opened, is_opened) ||
                other.is_opened == is_opened) &&
            const DeepCollectionEquality()
                .equals(other.latest_val, latest_val) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.bound, bound) || other.bound == bound) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      category,
      description,
      is_private,
      is_opened,
      const DeepCollectionEquality().hash(latest_val),
      type,
      bound,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThingValueImplCopyWith<_$ThingValueImpl> get copyWith =>
      __$$ThingValueImplCopyWithImpl<_$ThingValueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThingValueImplToJson(
      this,
    );
  }
}

abstract class _ThingValue implements ThingValue {
  const factory _ThingValue(
      {required final String name,
      final String? category,
      required final String description,
      required final int is_private,
      required final int is_opened,
      required final dynamic latest_val,
      required final String type,
      final Bound? bound,
      required final List<Tag> tags}) = _$ThingValueImpl;

  factory _ThingValue.fromJson(Map<String, dynamic> json) =
      _$ThingValueImpl.fromJson;

  @override
  String get name;
  @override
  String? get category;
  @override
  String get description;
  @override
  int get is_private;
  @override
  int get is_opened;
  @override
  dynamic get latest_val;
  @override // required String updated_on,
  String get type;
  @override
  Bound? get bound;
  @override
  List<Tag> get tags;
  @override
  @JsonKey(ignore: true)
  _$$ThingValueImplCopyWith<_$ThingValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
