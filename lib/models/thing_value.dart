import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';
import 'package:mysmax_playground/models/bound.dart';
import 'package:mysmax_playground/models/tag.dart';

part 'thing_value.freezed.dart';
part 'thing_value.g.dart';

@freezed
class ThingValue with _$ThingValue {
  const factory ThingValue({
    required String name,
    String? category,
    required String description,
    required int is_private,
    required int is_opened,
    required dynamic latest_val,
    // required String updated_on,
    required String type,
    Bound? bound,
    required List<Tag> tags,
  }) = _ThingValue;

  factory ThingValue.fromJson(Map<String, dynamic> json) =>
      _$ThingValueFromJson(json);
}

extension ThingValueExtension on ThingValue {
  ValueServiceExpression toValueServiceExpression(RangeType rangeType) {
    return ValueServiceExpression(
      name,
      tags.map((e) => e.name).toList(),
      rangeType,
    );
  }
}
