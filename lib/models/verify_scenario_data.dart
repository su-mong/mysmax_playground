import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_scenario_data.freezed.dart';
part 'verify_scenario_data.g.dart';

@freezed
class VerifyScenarioData with _$VerifyScenarioData {
  const factory VerifyScenarioData({
    required String name,
    required int error,
    required String? error_string,
  }) = _VerifyScenarioData;

  factory VerifyScenarioData.fromJson(Map<String, dynamic> json) =>
      _$VerifyScenarioDataFromJson(json);
}
