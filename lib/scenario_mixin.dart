import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysmax_playground/core/scenario_code_parser/scenario_code_parser.dart';
import 'package:mysmax_playground/core/scenario_code_parser/variable.dart';

mixin ScenarioMixin on ChangeNotifier {
  String? _scenarioName;
  String get scenarioName => _scenarioName ?? '';
  set scenarioName(String value) {
    _scenarioName = value;
    notifyListeners();
  }

  RootBlock _rootBlock = RootBlock();
  RootBlock get rootBlock => _rootBlock;

  set rootBlock(RootBlock value) {
    _rootBlock = value;
    _rootBlock.searchLevel(0);
    notifyListeners();
  }

  Future loadScenario(String scenarioCode) async {
    rootBlock = ScenarioCodeParser(scenarioCode).parse();
    notifyListeners();
  }

  void clear() {
    rootBlock = RootBlock();
    notifyListeners();
  }

  // void addEmptyScenarioItem() {
  //   for (int i = 0; i < scenarioItems.length; i++) {
  //     // scenarioItems[i].level = scenarioItems[i].level + 1;
  //     scenarioItems[i] =
  //         scenarioItems[i].copyWith(level: scenarioItems[i].level + 1);
  //   }
  //   scenarioItems.insert(0, ScenarioItem());
  //   scenarioItems.add(ScenarioItem(type: ScenarioItemType.Else));
  //   notifyListeners();
  // }

  Future<bool> validate() async {
    if (scenarioName.isEmpty) {
      return false;
    }
    return rootBlock.blocks.isNotEmpty;
  }

  void addChildScenarioItem({
    required Block parent,
    required Block child,
  }) {
    rootBlock.addChild(parent, child);
    rootBlock.searchLevel(0);
    notifyListeners();
  }

  void addSameLevelScenarioItem({
    required Block currentBlock,
    required Block newBlock,
  }) {
    rootBlock.addSameLevel(currentBlock, newBlock);
    rootBlock.searchLevel(0);
    notifyListeners();
  }

  void addScenarioItem(Block block) {
    rootBlock.addBlock(block);
    rootBlock.searchLevel(0);
    notifyListeners();
  }

  void updateScenarioItem(Block currentBlock, Block changedBlock) {
    rootBlock.updateBlock(currentBlock, changedBlock);
    rootBlock.searchLevel(0);
    notifyListeners();
  }

  void removeScenarioItem(Block item) {
    rootBlock.removeBlock(item);
    rootBlock.searchLevel(0);
    notifyListeners();
  }

  List<String> get scenarioVariableList {
    return rootBlock.getVariableNames();
  }

  String? _variableSearchText;
  String get variableSearchText => _variableSearchText ?? '';
  set variableSearchText(String? value) {
    _variableSearchText = value;
    notifyListeners();
  }

  List<String> get searchVariableList {
    return rootBlock
        .getVariableNames()
        .where((element) => element.contains(variableSearchText))
        .toList();
  }

  /// 변수명 관련 코드 1) 시나리오에서 쓰이고 있는 모든 변수명 리스트
  List<Variable> get allVariableList => rootBlock.getVariablesWithNameAndType();

  /// 변수명 관련 코드 2) 서비스명을 바탕으로 새로운 변수명을 생성함
  String generateNewVariable(String serviceName) {
    String variableName = '$serviceName결과값${Random().nextInt(1000)}';

    while (allVariableList
        .where((variable) => variable.name == variableName)
        .isNotEmpty) {
      variableName = '$serviceName결과값${Random().nextInt(1000)}';
    }

    return variableName;
  }

  /// 변수명 관련 코드 3) 특정 타입에 해당하는 모든 변수명 리스트
  List<Variable> variableListByType(String type) => rootBlock
      .getVariablesWithNameAndType()
      .where((variable) => variable.type == type)
      .toList();
}
