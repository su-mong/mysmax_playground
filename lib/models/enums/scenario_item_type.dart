enum ScenarioItemType {
  If,
  Else,
  Service,
  Value,
  Device,
  Until,
  Loop,
}

extension ScenarioItemTypeExtension on ScenarioItemType {
  String get toName {
    switch (this) {
      case ScenarioItemType.If:
        return 'if';
      case ScenarioItemType.Else:
        return 'else';
      case ScenarioItemType.Service:
        return '서비스';
      case ScenarioItemType.Device:
        return '디바이스';
      case ScenarioItemType.Until:
        return '언제';
      case ScenarioItemType.Loop:
        return '반복';
      default:
        return '';
    }
  }
}
