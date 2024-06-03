import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/models/scenario_samples.dart';
import 'package:mysmax_playground/recommend_scenario/pages/recommend_scenario_detail_page.dart';

class RecommendScenarioCategoryPage extends StatefulWidget {
  final ScenarioCategory category;
  const RecommendScenarioCategoryPage({Key? key, required this.category})
      : super(key: key);

  @override
  _RecommendScenarioCategoryPageState createState() =>
      _RecommendScenarioCategoryPageState();
}

class _RecommendScenarioCategoryPageState
    extends State<RecommendScenarioCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category.category,
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
                    '카테고리',
                    style: AppTextStyles.size16Bold.singleLine,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: widget.category.scenarios
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildScenarioAction(
                          onPressed: () {
                            RecommendScenarioDetailPage.push(context, data: e);
                          },
                          title: e.name,
                          subtitle: e.intro,
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
