import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysmax_playground/add_scenario/pages/add_scenario_example_page.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/models/enums/scenario_state.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/models/scheduled_thing.dart';
import 'package:mysmax_playground/models/service.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/scenario_creator/scenario_creator_screen.dart';
import 'package:mysmax_playground/scenario_detail/scenario_detail_screen.dart';
import 'package:mysmax_playground/scenario_editor/scenario_editor_screen.dart';
import 'package:mysmax_playground/scenario_main/widgets/scenario_main_list_view.dart';
import 'package:provider/provider.dart';

import '../add_scenario/add_scenario_screen_new.dart';
import '../app_text_styles.dart';
import '../colors.dart';

class ScenarioPage extends StatefulWidget {
  static final List<Scenario> allScenario = [
    const Scenario(
      id: 0,
      name: '시나리오 0',
      contents: '시나리오 0 내용',
      state: ScenarioState.created,
      scheduled_things: [
        ScheduledThing(
          service: '서비스 0',
          things: [Tag(name: '태그 0'), Tag(name: '태그 1'), Tag(name: '태그 2')],
        ),
      ],
    ),
    const Scenario(
      id: 1,
      name: '시나리오 1',
      contents: '시나리오 1 내용',
      state: ScenarioState.created,
      scheduled_things: [
        ScheduledThing(
          service: '서비스 1-1',
          things: [Tag(name: '태그 3'), Tag(name: '태그 4'), Tag(name: '태그 5')],
        ),
        ScheduledThing(
          service: '서비스 1-2',
          things: [Tag(name: '태그 6'), Tag(name: '태그 7')],
        ),
      ],
    ),
  ];

  const ScenarioPage({super.key});

  @override
  State<ScenarioPage> createState() => _ScenarioPageState();
}

class _ScenarioPageState extends State<ScenarioPage> {
  final List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _isExpandedList
          .addAll(ScenarioPage.allScenario.map((_) => false).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        leading: const SizedBox(width: 18),
        title: Text('우리집', style: AppTextStyles.size17Bold),
        centerTitle: false,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Row(
              children: [
                const SizedBox(width: 12),
                Text("시나리오", style: AppTextStyles.size16Bold.singleLine),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    const AddScenarioScreen().push(context);

                    // const AddScenarioExamplePage().push(context);

                    /*const ScenarioDetailScreen(
                      scenario: Scenario(
                        id: 0,
                        name: '시나리오 이름',
                        contents: """
  loop (1 DAY) {
	wait until ( (#clock).HOUR == 12);
	x = (#util).get_lunch_menu();
	(#speaker).tts(x);
	(#util).send_mail("점심 메뉴", x);
}
  """,
                        state: ScenarioState.executing,
                        scheduled_things: [
                          ScheduledThing(service: '서비스 1', things: [Tag(name: 'Thing 1'), Tag(name: 'Thing 2'), Tag(name: 'Thing 3')]),
                          ScheduledThing(service: '서비스 2', things: [Tag(name: 'Thing 4'), Tag(name: 'Thing 5')]),
                          ScheduledThing(service: '서비스 3', things: [Tag(name: 'Thing 6')]),
                        ],
                      )
                    ).push(context);*/

                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddScenarioScreen()),
                    );*/
                  },
                  child: SvgPicture.asset(
                    'assets/icons/add_new.svg',
                    width: 27,
                    height: 27,
                  ),
                ),
                const SizedBox(width: 2),
              ],
            ),
            const SizedBox(height: 9),
            ScenarioMainListView(
              ScenarioPage.allScenario,
              isExpanded: (index) => _isExpandedList[index],
              onExpansionChanged: (index, isExpanded) {
                setState(() {
                  _isExpandedList[index] = isExpanded;
                });
              },
              playOrStop: (int index) {
                print('playOrStop ${ScenarioPage.allScenario[index].name}');
              },
              refresh: (String name) => print('refresh $name'),
              copy: (String contents) => print('copy $contents'),
              delete: (String name) => print('delete $name'),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text("최근 실행", style: AppTextStyles.size16Bold.singleLine),
            ),
            const SizedBox(height: 12),
            _tmpScenarioDetailPage(),
          ],
        ),
      ),
    );
  }

  Widget _noRecentScenarioList() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        '최근에 실행한 내용이 없습니다.',
        style: AppTextStyles.size11Medium.copyWith(
          height: 15 / 11,
          letterSpacing: -0.22,
          color: const Color(0xFF8D929A),
        ),
      ),
    );
  }

  Widget _tmpScenarioDetailPage() {
    final viewModel = context.read<MqttViewModel>();

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewModel.scenarioList.length,
        itemBuilder: (_, index) => GestureDetector(
          onTap: () {
            ScenarioEditorScreen(scenario: viewModel.scenarioList[index])
                .push(context);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF46517D).withAlpha(6),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              viewModel.scenarioList[index].name,
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
      ),
    );
  }

  /*Widget _buildScenarioCard(Scenario scenario) {
    // var mqttViewModel = context.watch<MqttViewModel>();
    /*bool isDisabled = scenario.is_opened != 1 &&
        mqttViewModel.modeType != ModeType.owner &&
        mqttViewModel.modeType != ModeType.admin;*/
    return GestureDetector(
      onTap: !isDisabled
          ? () {
              ScenarioDetailScreen(scenario: scenario).push(context);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: ShapeDecoration(
          color: isDisabled ? Color(0xffeef0f7) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          shadows: !isDisabled
              ? const [
                  BoxShadow(
                    color: Color(0x0F45507D),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      scenario.name,
                      style: AppTextStyles.size16Bold.singleLine.copyWith(
                        color: isDisabled ? Color(0xffADB3C6) : null,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (scenario.state == ScenarioState.running) ...[
                  _buildBottomButton(
                    iconPath: 'assets/icons/stop.svg',
                    onPressed: isDisabled
                        ? null
                        : () async {
                            var viewModel = context.read<MqttViewModel>();
                            await viewModel.stopScenario(scenario.name);
                            await viewModel.getScenarioList();
                          },
                  ),
                ] else ...[
                  _buildBottomButton(
                    iconPath: 'assets/icons/play.svg',
                    onPressed: isDisabled
                        ? null
                        : () async {
                            var viewModel = context.read<MqttViewModel>();
                            await viewModel.runScenario(scenario.name);
                            await viewModel.getScenarioList();
                          },
                  ),
                ],
                _buildBottomButton(
                  iconPath: 'assets/icons/refresh.svg',
                  onPressed: isDisabled
                      ? null
                      : () async {
                          var viewModel = context.read<MqttViewModel>();
                          await viewModel.updateScenario(scenario.name);
                          await viewModel.getScenarioList();
                        },
                ),
                _buildBottomButton(
                  iconPath: 'assets/icons/copy.svg',
                  onPressed: isDisabled
                      ? null
                      : () async {
                          const AddScenarioScreen()
                              .push(context, scenarioCode: scenario.contents);
                        },
                ),
                _buildBottomButton(
                  iconPath: 'assets/icons/trash.svg',
                  onPressed: isDisabled
                      ? null
                      : () async {
                          var viewModel = context.read<MqttViewModel>();
                          await viewModel.deleteScenario(scenario.name);
                          await viewModel.getScenarioList();
                        },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required String iconPath,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
        onTap: onPressed,
        child: SvgPicture.asset(
          iconPath,
          height: 18,
          fit: BoxFit.fitHeight,
        ));
  }

  Widget _buildIcon() {
    return Container(
      width: 19,
      height: 19,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.68, 0.74),
          end: Alignment(0.68, -0.74),
          colors: [Color(0xFF8198F5), Color(0xFF83CDF6)],
        ),
        shape: OvalBorder(),
      ),
    );
  }*/
}
