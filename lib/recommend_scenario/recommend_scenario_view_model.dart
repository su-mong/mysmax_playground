import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysmax_playground/models/scenario_samples.dart';

class RecommendScenarioViewModel extends ChangeNotifier {
  ScenarioSamples? _scenarioSamples;
  ScenarioSamples? get scenarioSamples => _scenarioSamples;
  set scenarioSamples(ScenarioSamples? value) {
    _scenarioSamples = value;
    notifyListeners();
  }

  Future loadScenarioSamples() async {
    final scenarioSamplesJson =
        await _loadJson('assets/json/scenario_samples.json');
    scenarioSamples = ScenarioSamples.fromJson(scenarioSamplesJson);
  }

  Future _loadJson(String filePath) async {
    final jsonString = await rootBundle.loadString(filePath);
    return json.decode(jsonString);
  }
}
