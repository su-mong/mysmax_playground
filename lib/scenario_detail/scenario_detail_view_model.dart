import 'package:flutter/material.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/scenario_mixin.dart';

class ScenarioDetailViewModel extends ChangeNotifier with ScenarioMixin {
  Scenario scenario;
  ScenarioDetailViewModel({required this.scenario});
  // Future initialize() async {
  //   rootBlock = ScenarioCodeParser(scenario.contents).parse();
  //   rootBlock.searchLevel(0);
  // }

  Future updateScenario(Scenario scenario) async {
    this.scenario = scenario;
    notifyListeners();
    // rootBlock = ScenarioCodeParser(scenario.contents).parse();
    // rootBlock.searchLevel(0);
    await loadScenario(this.scenario.contents);
  }
}
