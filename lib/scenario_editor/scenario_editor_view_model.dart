import 'package:flutter/material.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/scenario_mixin.dart';

// Creator와 Editor가 나눠져야 함
// 지금은 ScenarioEditor가 Creator 역할을 하고 있음
class ScenarioEditorViewModel extends ChangeNotifier with ScenarioMixin {
  final Scenario? originScenario;
  ScenarioEditorViewModel({
    Scenario? scenario
  }) : originScenario = scenario {
    if(scenario == null) {
      addLoopBlock();
      addConditionBlock(parentBlock: rootBlock.blocks[0]);
      addFunctionServiceListBlock(parentBlock: rootBlock.blocks[0].blocks[0]);
    }
  }

  /*Future updateScenario(Scenario scenario) async {
    currentScenario = scenario;
    notifyListeners();
    // rootBlock = ScenarioCodeParser(scenario.contents).parse();
    // rootBlock.searchLevel(0);
    await loadScenario(currentScenario!.contents);
  }*/

  /// 빈 FunctionServiceListBlock 추가하기
  void addFunctionServiceListBlock({Block? parentBlock}) {
    if (parentBlock != null) {
      addChildScenarioItem(
        parent: parentBlock,
        child: FunctionServiceListBlock([]),
      );
    } else {
      addScenarioItem(FunctionServiceListBlock([]));
    }
  }

  /// 빈 ConditionBlock 추가하기
  void addConditionBlock({Block? parentBlock}) {
    if (parentBlock != null) {
      addChildScenarioItem(
        parent: parentBlock,
        child: ConditionBlock.empty(),
      );
    } else {
      addScenarioItem(
        ConditionBlock.empty(),
      );
    }
  }

  /// 빈 LoopBlock 추가하기
  void addLoopBlock({Block? parentBlock}) {
    if(parentBlock != null) {
      addChildScenarioItem(
        parent: parentBlock,
        child: LoopBlock.empty(),
      );
    } else {
      addScenarioItem(LoopBlock.empty());
    }
  }
}