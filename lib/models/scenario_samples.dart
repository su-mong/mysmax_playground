import 'package:freezed_annotation/freezed_annotation.dart';

part 'scenario_samples.freezed.dart';
part 'scenario_samples.g.dart';

// {
// "samples": [
// {
// "category": "스마트홈",
// "category_description": "집에서 할 수 있는 시나리오를 소개시켜드려요.",
// "scenarios": [
// {
// "name": "실내 청결 관리",
// "intro": "집 청소를 자동화해보세요.",
// "description": "다양한 청소 기기를 통해 집안 청소 자동화를 담당합니다.",
// "requirements": [
// {
// "thing": "RobotCleaner",
// "service": "on"
// },
// {
// "thing": "RobotCleaner",
// "service": "off"
// },
// {
// "thing": "RobotCleaner",
// "service": "setRobotCleanerCleaningMode"
// },
// {
// "thing": "RobotCleaner",
// "service": "switch"
// },
// {
// "thing": "Speaker",
// "service": "play"
// }
// ],
// "scenario_code": "loop (1 HOUR) { if ( (#RobotCleaner).switch == 'off' ) { (#RobotCleaner).setRobotCleanerCleaningMode(); Speaker.play('청소를 시작합니다.'); } else { (#RobotCleaner).off(); (#Speaker).play('청소를 종료합니다.'); } }"
// }
// ]
// },
// {
// "category": "엔터테인먼트",
// "category_description": "집에서 즐길 수 있는 다양한 엔터테인먼트 시나리오를 소개시켜드려요.",
// "scenarios": [
// {
// "name": "음악 감상",
// "intro": "집에서 음악을 즐기세요.",
// "description": "집안의 스피커를 통해 음악을 감상합니다.",
// "requirements": [
// {
// "thing": "Speaker",
// "service": "play"
// }
// ],
// "scenario_code": "Speaker.play('음악을 재생합니다.');"
// }
// ]
// },
// {
// "category": "보안",
// "category_description": "집의 보안을 강화하는 시나리오를 소개시켜드려요.",
// "scenarios": [
// {
// "name": "외출 모드",
// "intro": "집을 비욕할 때 집의 보안을 강화하세요.",
// "description": "집안의 모든 장치를 꺼서 외출 모드로 전환합니다.",
// "requirements": [
// {
// "thing": "Light",
// "service": "off"
// },
// {
// "thing": "AirConditioner",
// "service": "off"
// },
// {
// "thing": "DoorLock",
// "service": "open"
// },
// {
// "thing": "DoorLock",
// "service": "close"
// }
// ],
// "scenario_code": "(#Light).off(); (#AirConditioner).off(); (#DoorLock).close();"
// }
// ]
// }
// ]
// }

@freezed
class ScenarioSamples with _$ScenarioSamples {
  const factory ScenarioSamples({
    required List<ScenarioCategory> samples,
  }) = _ScenarioSamples;

  factory ScenarioSamples.fromJson(Map<String, dynamic> json) =>
      _$ScenarioSamplesFromJson(json);
}

@freezed
class ScenarioCategory with _$ScenarioCategory {
  const factory ScenarioCategory({
    required String category,
    required String category_description,
    required List<ScenarioSampleData> scenarios,
  }) = _ScenarioCategory;

  factory ScenarioCategory.fromJson(Map<String, dynamic> json) =>
      _$ScenarioCategoryFromJson(json);
}

@freezed
class ScenarioSampleData with _$ScenarioSampleData {
  const factory ScenarioSampleData({
    required String name,
    required String intro,
    required String description,
    required List<ScenarioRequirement> requirements,
    required String scenario_code,
  }) = _ScenarioSampleData;

  factory ScenarioSampleData.fromJson(Map<String, dynamic> json) =>
      _$ScenarioSampleDataFromJson(json);
}

@freezed
class ScenarioRequirement with _$ScenarioRequirement {
  const factory ScenarioRequirement({
    required String thing,
    required String service,
  }) = _ScenarioRequirement;

  factory ScenarioRequirement.fromJson(Map<String, dynamic> json) =>
      _$ScenarioRequirementFromJson(json);
}
