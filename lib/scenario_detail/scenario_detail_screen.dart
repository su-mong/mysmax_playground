import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/core/app_widgets.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/scenario_detail/scenario_detail_view_model.dart';
import 'package:mysmax_playground/scenario_item_widget.dart';
import 'package:mysmax_playground/scenario_mixin.dart';
import 'package:mysmax_playground/widgets/home_app_bar.dart';
import 'package:provider/provider.dart';

class ScenarioDetailScreen extends StatefulWidget {
  final Scenario scenario;
  const ScenarioDetailScreen({super.key, required this.scenario});

  Future push(BuildContext context) {
    var viewModel = ScenarioDetailViewModel(scenario: scenario);
    viewModel.loadScenario(viewModel.scenario.contents);
    return ChangeNotifierProvider<ScenarioDetailViewModel>.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ScenarioDetailViewModel>();
    return AppWidgets.scaffold(
      appBar: LinedAppBar.buildWithTitle(
        title: viewModel.scenario.name,
        bottom: _buildBottomWidget(),
      ),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 18,
                bottom: 13,
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '시나리오 코드',
                              style: AppTextStyles.size14Bold,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              viewModel.rootBlock.toScenarioCode(),
                              style: AppTextStyles.size13Regular,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    )
                  );

                  print('Current Scenario : ${viewModel.rootBlock.toScenarioCode()}');
                },
                child: Text(
                  "시나리오 내용",
                  style: AppTextStyles.size16Bold.singleLine,
                ),
              ),
            ),
            ChangeNotifierProvider<ScenarioMixin>.value(
              value: viewModel,
              child: ScenarioItemWidget(
                viewModel.rootBlock,
                editMode: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildBottomWidget() {
    var viewModel = context.watch<ScenarioDetailViewModel>();
    return PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(
            top: 8,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "상태",
                    style: AppTextStyles.size11Medium.singleLine
                        .copyWith(color: Color(0xff8f94a4)),
                  ),
                  const SizedBox(width: 6),
                  Text(viewModel.scenario.state.name,
                      style: AppTextStyles.size13Medium.singleLine),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "우선순위",
                    style: AppTextStyles.size11Medium.singleLine
                        .copyWith(color: Color(0xff8f94a4)),
                  ),
                  const SizedBox(width: 6),
                  Text((viewModel.scenario.priority ?? -1).toString(),
                      style: AppTextStyles.size13Medium.singleLine),
                  const Spacer(),
                  Text("공개", style: AppTextStyles.size13Medium.singleLine),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 18,
                    child: Switch(
                      value: viewModel.scenario.is_opened == 1,
                      thumbColor: MaterialStateProperty.all(Colors.white),
                      activeColor: const Color(0xff5d7cff),
                      onChanged: (value) async {
                        print("value: $value");
                        await viewModel.updateScenario(
                          viewModel.scenario.copyWith(
                            is_opened: value ? 1 : 0,
                          ),
                        );

                        /// GET List<Scenario>
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ));
  }
}
