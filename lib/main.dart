import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/connect_hub_screen.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/recommend_scenario/recommend_scenario_view_model.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_variable_list_widget.dart';
import 'package:mysmax_playground/scenario_main/scenario_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MqttViewModel>(
          create: (_) => MqttViewModel(),
        ),
        ChangeNotifierProvider<AddScenarioViewModel>(
          create: (_) => AddScenarioViewModel(),
        ),
        ChangeNotifierProvider<RecommendScenarioViewModel>(
          create: (_) => RecommendScenarioViewModel()..loadScenarioSamples(),
        ),

      ],
      child: MaterialApp(
        navigatorKey: App.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ScenarioPage(),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<StatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<String> variableList = ['off01', 'on01', 'on02', 'getWeather01'];
  String? initialSelectedVariable;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ExpansionTile(
            title: Text('Variable'),
            children: [
              EditorVariableListWidget(
                isVariableForLeftSide: true,
                variableList: variableList,
                initialSelectedVariable: initialSelectedVariable,
                addNewVariable: () {
                  setState(() {
                    variableList.add('newVariable');
                    initialSelectedVariable = 'newVariable';
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Status {
  none(''),
  waiting('대기중'),
  connecting('연결중'),
  registering('등록중'),
  finish('등록완료');

  final String message;
  const Status(this.message);
}