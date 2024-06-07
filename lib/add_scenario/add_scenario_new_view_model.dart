import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/scenario_samples.dart';

class AddScenarioNewViewModel extends ChangeNotifier {
  ScenarioSamples? _scenarioSamples;
  ScenarioSamples? get scenarioSamples => _scenarioSamples;
  set scenarioSamples(ScenarioSamples? value) {
    _scenarioSamples = value;
    notifyListeners();
  }

  Future<void> loadRecommendScenario() async {
    final scenarioSamplesString = await rootBundle.loadString('assets/json/scenario_samples.json');
    final scenarioSamplesJson = json.decode(scenarioSamplesString);
    scenarioSamples = ScenarioSamples.fromJson(scenarioSamplesJson);
  }
}