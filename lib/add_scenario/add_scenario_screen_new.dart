import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysmax_playground/add_scenario/add_scenario_new_view_model.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/scenario_editor/scenario_editor_screen.dart';
import 'package:provider/provider.dart';

import '../scenario_creator/scenario_creator_screen.dart';

class AddScenarioScreen extends StatefulWidget {
  const AddScenarioScreen({super.key});

  Future<void> push(BuildContext context) {
    final viewModel = AddScenarioNewViewModel();
    viewModel.loadRecommendScenario();
    return ChangeNotifierProvider<AddScenarioNewViewModel>.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  State<StatefulWidget> createState() => _AddScenarioScreenState();
}

class _AddScenarioScreenState extends State<AddScenarioScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddScenarioNewViewModel>();

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: false,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        titleSpacing: 30,
        title: Text(
          '시나리오 생성',
          style: AppTextStyles.size18Bold.singleLine.copyWith(
            height: 29 / 18,
            color: const Color(0xFF282828),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScenarioAction(
                  onPressed: () async {
                    const ScenarioCreatorScreen().push(context);
                  },
                  title: '직접 만들기',
                  subtitle: '일상을 자동화하기 위해 시나리오를 직접 생성해 보세요.',
                  example: ' 예) 매일 저녁 7시에 거실 불을 켜줘'
              ),

              const SizedBox(height: 34),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Divider(height: 1, color: Color(0xFFE1E4E5)),
              ),
              const SizedBox(height: 37),

              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/compass.svg',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '추천 시나리오',
                    style: AppTextStyles.size16Bold.singleLine,
                  ),
                ],
              ),

              if(viewModel.scenarioSamples != null)
                ...List.generate(
                  viewModel.scenarioSamples!.samples.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildScenarioAction(
                      onPressed: () {
                        ScenarioEditorScreen.fromScenarioSampleData(
                          viewModel.scenarioSamples!.samples[index].scenarios[0],
                        ).push(context);
                      },
                      title: viewModel.scenarioSamples!.samples[index].category,
                      subtitle: viewModel.scenarioSamples!.samples[index].category_description,
                      example: viewModel.scenarioSamples!.samples[index].scenarios[0].name,
                    ),
                  ),
                ),

              /*const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
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
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                      backgroundColor: const Color(0xFF5D7CFF),
                      textStyle: AppTextStyles.size16Medium,
                      foregroundColor: const Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('다음'),
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioAction({
    VoidCallback? onPressed,
    required String title,
    required String subtitle,
    required String example,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff46517d).withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.size17Bold.singleLine,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: AppTextStyles.size12Medium.singleLine,
            ),
            const SizedBox(height: 4),
            Text(
              example,
              style: AppTextStyles.size11Regular.singleLine.copyWith(
                color: const Color(0xFF8F94A4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}