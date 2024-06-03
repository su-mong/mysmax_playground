import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/add_scenario_screen.dart';
import 'package:mysmax_playground/add_scenario/pages/add_condition_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_loop_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_service_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_until_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/main.dart';
import 'package:mysmax_playground/recommend_scenario/pages/recommend_scenario_category_page.dart';
import 'package:mysmax_playground/recommend_scenario/recommend_scenario_view_model.dart';
import 'package:mysmax_playground/scenario_mixin.dart';
import 'package:provider/provider.dart';

class AddScenarioExamplePage extends StatefulWidget {
  const AddScenarioExamplePage({Key? key}) : super(key: key);

  Future push(BuildContext context) {
    var viewModel = context.read<AddScenarioViewModel>();
    return ChangeNotifierProvider<ScenarioMixin>.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  _AddScenarioExamplePageState createState() => _AddScenarioExamplePageState();
}

class _AddScenarioExamplePageState extends State<AddScenarioExamplePage> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AddScenarioViewModel>();
    var recommendViewModel = context.watch<RecommendScenarioViewModel>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '시나리오 만들기',
            style: AppTextStyles.size17Medium.singleLine,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(
              bottom: 200,
            ),
            child: Column(children: [
              Row(
                children: [
                  Text(
                    '시나리오 유형',
                    style: AppTextStyles.size16Bold.singleLine,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildScenarioAction(
                  onPressed: () async {
                    var context = App.navigatorKey.currentContext!;
                    Navigator.pop(context);
                    const AddScenarioScreen().push(context);
                    const AddServiceScenarioPage().push(context).then((value) {
                      if (viewModel.rootBlock.blocks.isEmpty) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  title: '서비스 실행',
                  subtitle: '내가 실행 버튼을 누를 때 실행해요.',
                  example: '예) 오늘 날씨에 맞는 음악 재생해줘'),
              const SizedBox(height: 8),
              _buildScenarioAction(
                  onPressed: () {
                    var context = App.navigatorKey.currentContext!;
                    Navigator.pop(context);
                    const AddScenarioScreen().push(context);
                    const AddConditionScenarioPage()
                        .push(context)
                        .then((value) {
                      if (viewModel.rootBlock.blocks.isEmpty) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  title: '분기 실행 (if-else)',
                  subtitle: '어떤 조건을 기준으로 다르게 실행해요.',
                  example: '예) 사람이 없으면 로봇 청소기를 켜고, 있으면 꺼줘'),
              const SizedBox(height: 8),
              _buildScenarioAction(
                  onPressed: () {
                    var context = App.navigatorKey.currentContext!;
                    Navigator.pop(context);
                    const AddScenarioScreen().push(context);
                    const AddLoopScenarioPage().push(context).then((value) {
                      if (viewModel.rootBlock.blocks.isEmpty) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  title: '반복 실행',
                  subtitle: '원하는 작업을 설정한 시간에 주기적으로 실행해요.',
                  example: '예) 3시간에 한 번 환기해줘'),
              const SizedBox(height: 8),
              _buildScenarioAction(
                  onPressed: () {
                    var context = App.navigatorKey.currentContext!;
                    Navigator.pop(context);
                    const AddScenarioScreen().push(context);
                    const AddUntilScenarioPage().push(context).then((value) {
                      if (viewModel.rootBlock.blocks.isEmpty) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  title: '조건 실행 (until)',
                  subtitle: '어떤 조건이 만족할 때까지 기다렸다가 실행해요.',
                  example: '예) 아침이 되면 창문을 열어줘'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    '추천 시나리오',
                    style: AppTextStyles.size16Bold.singleLine,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              recommendViewModel.scenarioSamples == null
                  ? const SizedBox()
                  : Column(
                      children: recommendViewModel.scenarioSamples!.samples
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildScenarioAction(
                                onPressed: () {
                                  RecommendScenarioCategoryPage(
                                    category: e,
                                  ).pushByPageRoute(context);
                                },
                                title: e.category,
                                subtitle: e.category_description,
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ]),
          ),
        ));
  }

  Widget _buildScenarioAction({
    VoidCallback? onPressed,
    required String title,
    required String subtitle,
    String? example,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Color(0xff46517d).withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.size17Bold.singleLine,
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style: AppTextStyles.size12Medium.singleLine.copyWith(
                        color: const Color(0xff3f424b),
                      )),
                  if (example != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      example,
                      style: AppTextStyles.size11Medium.singleLine.copyWith(
                        color: const Color(0xff8f94a4),
                      ),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
