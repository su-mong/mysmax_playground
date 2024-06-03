import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/pages/add_condition_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_loop_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_service_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_until_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/scenario_item_widget.dart';
import 'package:mysmax_playground/scenario_mixin.dart';
import 'package:provider/provider.dart';

class AddScenarioScreen extends StatefulWidget {
  const AddScenarioScreen({Key? key}) : super(key: key);

  Future push(BuildContext context, {String? scenarioCode}) async {
    var viewModel = context.read<AddScenarioViewModel>();

    if (scenarioCode != null) {
      viewModel.loadScenario(scenarioCode);
    }
    return ChangeNotifierProvider<ScenarioMixin>.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  _AddScenarioScreenState createState() => _AddScenarioScreenState();
}

class _AddScenarioScreenState extends State<AddScenarioScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ScenarioMixin>();
    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '시나리오 만들기',
                style: AppTextStyles.size17Medium.singleLine,
              ),
              backgroundColor: const Color(0xff8F9FD),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (await viewModel.validate()) {
                      var mqttViewModel = context.read<MqttViewModel>();
                      mqttViewModel.verifyScenarioData = null;
                      await mqttViewModel.verifyScenario(
                        name: _searchController.text, // scenario name
                        text: viewModel.rootBlock
                            .toScenarioCode(), // scenario code
                      );
                      await Future.delayed(const Duration(seconds: 1));
                      if (mqttViewModel.verifyScenarioData?.error == 0) {
                        await mqttViewModel.addScenario(
                          name: _searchController.text, // scenario name
                          text: viewModel.rootBlock
                              .toScenarioCode(), // scenario code
                          priority: 1,
                        );
                        await mqttViewModel.getScenarioList();
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              mqttViewModel.verifyScenarioData?.error_string ??
                                  "시나리오 생성 실패"),
                        ));
                      }
                    }
                  },
                  child: Text("완료"),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.defaultTextColor,
                    textStyle: AppTextStyles.size15Medium.singleLine,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xffF8F9FD),
            floatingActionButton: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Color(0xff46517D).withOpacity(0.2),
              splashRadius: 12,
              onSelected: (String result) {
                if (result == '서비스') {
                  AddServiceScenarioPage().push(context);
                } else if (result == '조건') {
                  AddConditionScenarioPage().push(context);
                } else if (result == '반복') {
                  AddLoopScenarioPage().push(context);
                } else if (result == '조건부') {
                  AddUntilScenarioPage().push(context);
                }
              },
              itemBuilder: (BuildContext buildContext) {
                return [
                  PopupMenuItem(
                    value: '서비스',
                    child: Text('서비스',
                        style: AppTextStyles.size13Medium.singleLine
                            .copyWith(color: Color(0xff3F424B))),
                  ),
                  PopupMenuItem(
                    value: '조건',
                    child: Text('조건',
                        style: AppTextStyles.size13Medium.singleLine
                            .copyWith(color: Color(0xff3F424B))),
                  ),
                  PopupMenuItem(
                    value: '반복',
                    child: Text('반복',
                        style: AppTextStyles.size13Medium.singleLine
                            .copyWith(color: Color(0xff3F424B))),
                  ),
                  PopupMenuItem(
                    value: '조건부',
                    child: Text('조건부',
                        style: AppTextStyles.size13Medium.singleLine
                            .copyWith(color: Color(0xff3F424B))),
                  ),
                ];
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xff5D7CFF),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    const SizedBox(height: 3.3),
                    Text("블럭",
                        style: AppTextStyles.size11Medium.singleLine
                            .copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     // viewModel.addEmptyScenarioItem();
            //   },
            //   child: const Icon(Icons.add),
            // ),
            body: _buildBody(),
          ),
        ),
        onWillPop: () async {
          var mqttViewModel = context.read<MqttViewModel>();
          mqttViewModel.verifyScenarioData = null;
          var viewModel = context.read<AddScenarioViewModel>();
          viewModel.clear();
          return true;
        });
  }

  Widget _buildBody() {
    var viewModel = context.watch<ScenarioMixin>();
    return ExtendedNestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: AppColors.cardBackground,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  viewModel.scenarioName = value;
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '시나리오 이름',
                  hintStyle: AppTextStyles.size14Regular
                      .heightWith(1)
                      .copyWith(color: Color(0xffadb3c6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xffe9ecf5),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xffe9ecf5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: ScenarioItemWidget(
            viewModel.rootBlock,
            editMode: true,
          ),
        ),
      ),
    );
  }
}
