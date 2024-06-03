import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysmax_playground/add_scenario/add_scenario_screen.dart';
import 'package:mysmax_playground/add_scenario/widgets/scenario_item_widget.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/models/enums/scenario_state.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/models/scenario_samples.dart';
import 'package:mysmax_playground/scenario_detail/scenario_detail_view_model.dart';
import 'package:provider/provider.dart';

class RecommendScenarioDetailPage extends StatefulWidget {
  final ScenarioSampleData data;

  static Future push(BuildContext context, {required ScenarioSampleData data}) {
    var viewModel = ScenarioDetailViewModel(
      scenario: Scenario(
        id: 1,
        name: data.name,
        contents: data.scenario_code,
        state: ScenarioState.initialized,
        scheduled_things: [],
      ),
    );
    viewModel.loadScenario(viewModel.scenario.contents);

    return ChangeNotifierProvider<ScenarioDetailViewModel>.value(
      value: viewModel,
      child: RecommendScenarioDetailPage(data: data),
    ).pushByPageRoute(context);
  }

  const RecommendScenarioDetailPage({Key? key, required this.data})
      : super(key: key);

  @override
  _RecommendScenarioDetailPageState createState() =>
      _RecommendScenarioDetailPageState();
}

class _RecommendScenarioDetailPageState
    extends State<RecommendScenarioDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data.name,
          style: AppTextStyles.size17Medium.singleLine,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              const AddScenarioScreen()
                  .push(context, scenarioCode: widget.data.scenario_code);
            },
            child: Text(
              "사용하기",
              style: AppTextStyles.size15Medium.singleLine,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(
            bottom: 200,
          ),
          child: Column(children: [
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  '설명',
                  style: AppTextStyles.size16Bold.singleLine,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildContainer(
              Text(
                widget.data.description,
                style: AppTextStyles.size13Medium,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  '필요한 서비스',
                  style: AppTextStyles.size16Bold.singleLine,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildContainer(
              Column(
                children: [
                  for (var requirement in widget.data.requirements)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildRequirement(requirement),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildScenario(),
          ]),
        ),
      ),
    );
  }

  Widget _buildScenario() {
    var viewModel = context.watch<ScenarioDetailViewModel>();
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        '필요한 서비스',
        style: AppTextStyles.size16Bold.singleLine,
      ),
      children: [
        ScenarioItemWidget(
          viewModel.rootBlock,
        )
      ],
    );
  }

  Widget _buildRequirement(ScenarioRequirement requirement) {
    var mqttViewModel = context.read<MqttViewModel>();
    bool containsThing = mqttViewModel.containsThing(requirement.thing);
    return Row(
      children: [
        Text(
          requirement.service,
          style: AppTextStyles.size13Medium.singleLine,
        ),
        const Spacer(),
        if (containsThing)
          SvgPicture.asset(
            'assets/icons/checked.svg',
            width: 20,
            height: 20,
          )
        else
          SvgPicture.asset(
            'assets/icons/not_checked.svg',
            width: 20,
            height: 20,
          ),
      ],
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Color(0xff46517d).withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
