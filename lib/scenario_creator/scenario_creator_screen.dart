import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/scenario_creator/cards/scenario_creator_conditions_card_view.dart';
import 'package:mysmax_playground/scenario_creator/cards/scenario_creator_loop_card_view.dart';
import 'package:mysmax_playground/scenario_creator/cards/scenario_creator_services_card_view.dart';
import 'package:mysmax_playground/scenario_creator/scenario_creator_view_model.dart';
import 'package:mysmax_playground/scenario_item_widget.dart';
import 'package:mysmax_playground/scenario_mixin.dart';
import 'package:provider/provider.dart';

class ScenarioCreatorScreen extends StatefulWidget {
  final Scenario? scenario;

  const ScenarioCreatorScreen({
    super.key,
    this.scenario,
  });

  Future<void> push(BuildContext context) {
    final viewModel = ScenarioCreatorViewModel();

    return ChangeNotifierProvider<ScenarioCreatorViewModel>.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  State<StatefulWidget> createState() => _ScenarioCreatorScreenState();
}

class _ScenarioCreatorScreenState extends State<StatefulWidget> {
  bool _showScenario = false;

  @override
  Widget build(BuildContext context) {
    final creatorViewModel = context.watch<ScenarioCreatorViewModel>();

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 65, 0, 72),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tmpButtonWithCard(
                      text: _showScenario
                          ? creatorViewModel.rootBlock.toScenarioCode()
                          : '',
                      onClick: () {
                        setState(() {
                          _showScenario = true;
                        });
                      },
                      buttonText: '현재 시나리오 로딩',
                    ),
                    const SizedBox(height: 24),
                    ChangeNotifierProvider<ScenarioMixin>.value(
                        value: creatorViewModel,
                        child: Column(children: [
                          ScenarioCreatorServicesCardView(
                              onUpdateBlock: (block) {
                                creatorViewModel
                                    .onUpdateFunctionServiceListBlock(block);
                              },
                              tagList: const [Tag(name: 'test01')],
                              getThingFunctionListByTag: (tag) => context
                                  .read<MqttViewModel>()
                                  .serviceFunctionListByTagForTest(),
                              getAllThingsByThingFunction: context
                                  .read<MqttViewModel>()
                                  .allDevicesForService,
                              variableList: creatorViewModel.allVariableList,
                              generateNewVariable:
                                  creatorViewModel.generateNewVariable,
                              serviceFunctionByName: context
                                  .read<MqttViewModel>()
                                  .serviceFunctionByName),
                          SizedBox(height: 16),
                          ScenarioCreatorLoopCardView(onUpdateBlock: (block) {
                            creatorViewModel.onUpdateLoopBlock(block);
                          }),
                          SizedBox(height: 16),
                          ScenarioCreatorConditionsCardView(
                              onUpdateIfBlock: (block) {
                            creatorViewModel.onUpdateIfBlock(block);
                          }, onUpdateWaitUntilBlock: (block) {
                            creatorViewModel.onUpdateWaitUntilBlock(block);
                          }, onUpdateElseBlock: (block) {
                            creatorViewModel.onUpdateElseBlock(block);
                          }),
                          
                          if(creatorViewModel.elseBlock != null) ...[
                             SizedBox(height: 32),
                             Text(
                              '그렇지 않다면',
                              style: AppTextStyles.size18Bold
                                  .copyWith(color: const Color(0xFF282828)),
                            ),
                          SizedBox(height: 20),
                          ScenarioCreatorServicesCardView(
                              onUpdateBlock: (block) {
                                creatorViewModel
                                    .onUpdateElseFunctionServiceListBlock(
                                        block);
                              },
                              tagList: const [Tag(name: 'test01')],
                              getThingFunctionListByTag: (tag) => context
                                  .read<MqttViewModel>()
                                  .serviceFunctionListByTagForTest(),
                              getAllThingsByThingFunction: context
                                  .read<MqttViewModel>()
                                  .allDevicesForService,
                              variableList: creatorViewModel.allVariableList,
                              generateNewVariable:
                                  creatorViewModel.generateNewVariable,
                              serviceFunctionByName: context
                                  .read<MqttViewModel>()
                                  .serviceFunctionByName)
                          ],
                        ])),
                  ],
                ),
              ),
            ),
            Container(
              height: 65,
              padding: const EdgeInsets.only(left: 30),
              alignment: Alignment.centerLeft,
              color: AppColors.cardBackground,
              child: Text(
                '시나리오 생성',
                style: AppTextStyles.size18Bold.singleLine.copyWith(
                  height: 29 / 18,
                  color: const Color(0xFF282828),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: AppColors.cardBackground,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        backgroundColor: const Color(0xFFF0F2F9),
                        textStyle: AppTextStyles.size16Medium,
                        foregroundColor: const Color(0xFF3F424B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: 25),
                    TextButton(
                      onPressed: () {
                        creatorViewModel.fillRootBlock();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        backgroundColor: creatorViewModel.validateBlocks
                            ? const Color(0xFF5D7CFF)
                            : const Color(0xFFF0F2F9),
                        textStyle: AppTextStyles.size16Medium,
                        foregroundColor: creatorViewModel.validateBlocks
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF3F424B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('완료'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tmpButtonWithCard({
    required String text,
    required VoidCallback onClick,
    required String buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: onClick,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              backgroundColor: const Color(0xFF5D7CFF),
              textStyle: AppTextStyles.size16Medium,
              foregroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(buttonText),
          ),
          const SizedBox(height: 16),
          Text(text),
        ],
      ),
    );
  }

  /*
  Widget _old() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScenarioCreatorContentsCardView(
          tagList: [Tag(name: '내 방'), Tag(name: '거실'), Tag(name: '부엌'), Tag(name: '안방'), Tag(name: '복도'), Tag(name: '현관'), Tag(name: '방 2'), Tag(name: '방 3')],
          getServiceFunctionListByTag: (Tag tag) => [],
        ),

        const SizedBox(height: 20),
        ScenarioCreatorOptionsCardView(),

        const SizedBox(height: 16),
        ScenarioCreatorDurationCardView(null),

        const SizedBox(height: 16),
        ScenarioCreatorConditionsCardView(),

        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            '그렇지 않다면',
            style: AppTextStyles.size18Bold.singleLine.copyWith(
              height: 29 / 18,
              color: const Color(0xFF282828),
            ),
          ),
        ),

        const SizedBox(height: 22),
        ScenarioCreatorContentsCardView(
          tagList: [Tag(name: '내 방'), Tag(name: '거실'), Tag(name: '부엌'), Tag(name: '안방'), Tag(name: '복도'), Tag(name: '현관'), Tag(name: '방 2'), Tag(name: '방 3')],
          getServiceFunctionListByTag: (Tag tag) => [],
        ),

        const SizedBox(height: 90),
      ],
    );
  }
  */
}
