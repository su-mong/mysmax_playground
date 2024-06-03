import 'package:freezed_annotation/freezed_annotation.dart';

part 'bound.freezed.dart';
part 'bound.g.dart';

@freezed
class Bound with _$Bound {
  const factory Bound({
    dynamic min_value,
    dynamic max_value,
  }) = _Bound;

  factory Bound.fromJson(Map<String, dynamic> json) => _$BoundFromJson(json);
}
