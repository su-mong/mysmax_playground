import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/connect_hub_screen.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/recommend_scenario/recommend_scenario_view_model.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_variable_list_widget.dart';
import 'package:mysmax_playground/scenario_main/scenario_page.dart';
import 'package:mysmax_playground/widgets/number_slider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
  late Locale locale;

  @override
  void initState() {
    locale = Locale.fromSubtags(languageCode: Intl.getCurrentLocale());
    super.initState();
  }

  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MqttViewModel>(
          create: (_) => MqttViewModel()..initialize(),
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
        locale: locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('he', ''), // Hebrew, no country code
          const Locale.fromSubtags(languageCode: 'zh')
        ],
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
  int _value = 2;
  double _valueDouble = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberSlider(
              enabled: false,
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value.toInt();
                });
              },
              min: 1,
              max: 10,
            ),
            NumberSlider(
              enabled: true,
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value.toInt();
                });
              },
              min: 1,
              max: 10,
            ),
            const SizedBox(height: 36),
            NumberSlider(
              enabled: false,
              value: _valueDouble,
              onChanged: (value) {
                setState(() {
                  _valueDouble = value.toDouble();
                });
              },
              min: 1,
              max: 10,
            ),
            NumberSlider(
              enabled: true,
              value: _valueDouble,
              onChanged: (value) {
                setState(() {
                  _valueDouble = value.toDouble();
                });
              },
              min: 1,
              max: 10,
            ),
          ],
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