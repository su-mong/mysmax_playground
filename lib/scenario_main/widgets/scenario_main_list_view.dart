import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/models/enums/scenario_state.dart';
import 'package:mysmax_playground/models/scenario.dart';

class ScenarioMainListView extends StatelessWidget {
  final List<Scenario> _scenarioList;
  final bool Function(int index) isExpanded;
  final void Function(int index, bool isExpanded) onExpansionChanged;

  final void Function(int index) playOrStop;
  final void Function(String name) refresh;
  final void Function(String contents) copy;
  final void Function(String name) delete;
  
  const ScenarioMainListView(
    this._scenarioList, {
    super.key,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.playOrStop,
    required this.refresh,
    required this.copy,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _scenarioList.length,
      itemBuilder: (_, index) => Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
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
          child: ExpansionTile(
            initiallyExpanded: false,
            shape: const Border(),
            tilePadding: const EdgeInsets.symmetric(horizontal: 11),
            onExpansionChanged: (isExpanded) => onExpansionChanged(index, isExpanded),
            title: Row(
              children: [
                SvgPicture.asset('assets/icons/trash.svg'),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _scenarioList[index].name,
                    style: AppTextStyles.size16Bold.singleLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => playOrStop(index),
                  child: SvgPicture.asset(
                    _scenarioList[index].state == ScenarioState.running
                        ? 'assets/icons/stop.svg'
                        : 'assets/icons/play.svg',
                  ),
                ),
              ],
            ),
            trailing: SvgPicture.asset(
              isExpanded(index)
                  ? 'assets/icons/expansion_up.svg'
                  : 'assets/icons/expansion_down.svg',
            ),

            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  const Spacer(flex: 40),
                  _dateTimeWidget(
                    startDateTime: DateTime(2023, 5, 1, 13, 50),
                    endDateTime: DateTime(2023, 10, 1, 14),
                  ),
                  const Spacer(flex: 78),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _bottomIconButton(
                    icon: 'assets/icons/refresh.svg',
                    onClick: () => refresh(_scenarioList[index].name),
                  ),
                  const SizedBox(width: 10),
                  _bottomIconButton(
                    icon: 'assets/icons/copy.svg',
                    onClick: () => copy(_scenarioList[index].contents),
                  ),
                  const SizedBox(width: 10),
                  _bottomIconButton(
                    icon: 'assets/icons/trash.svg',
                    onClick: () => delete(_scenarioList[index].name),
                  ),
                  const SizedBox(width: 3),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 9),
    );
  }

  Widget _dateTimeWidget({
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat("yyyy년 M월 d일\nHH시 mm분").format(startDateTime),
              style: AppTextStyles.size10Medium.copyWith(
                height: 15 / 10,
                color: const Color(0xFF5D7CFF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 3),
            Text(
              '부터',
              style: AppTextStyles.size10Medium.copyWith(
                height: 15 / 10,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              DateFormat("yyyy년 M월 d일\nHH시 mm분").format(endDateTime),
              style: AppTextStyles.size10Medium.copyWith(
                height: 15 / 10,
                color: const Color(0xFF5D7CFF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 3),
            Text(
              '까지',
              style: AppTextStyles.size10Medium.copyWith(
                height: 15 / 10,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            __weekCircle('월', isSelected: true),
            const SizedBox(width: 2.37),
            __weekCircle('화', isSelected: true),
            const SizedBox(width: 2.37),
            __weekCircle('수', isSelected: true),
            const SizedBox(width: 2.37),
            __weekCircle('목', isSelected: true),
            const SizedBox(width: 2.37),
            __weekCircle('금', isSelected: false),
            const SizedBox(width: 2.37),
            __weekCircle('토', isSelected: false),
            const SizedBox(width: 2.37),
            __weekCircle('일', isSelected: false),
            const SizedBox(width: 31.79),
            Text(
              '10분',
              style: AppTextStyles.size8Medium.copyWith(
                color: const Color(0xFF5D7CFF),
                height: 20 / 8,
              ),
            ),
            Text(
              ' 마다',
              style: AppTextStyles.size8Medium.copyWith(
                height: 20 / 8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bottomIconButton({required String icon, required VoidCallback onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          icon,
          height: 15,
        ),
      ),
    );
  }

  Widget __weekCircle(String week, {required bool isSelected}) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFFFFF),
        border: Border.all(
          width: 0.47,
          color: isSelected ? const Color(0xFF5D7CFF) : const Color(0xFFE9ECF5),
        ),
      ),
      child: Center(
        child: Text(
          week,
          style: AppTextStyles.custom(
            fontWeight: FontWeight.w500,
            fontSize: 6.63,
            height: 8.3 / 6.63,
            color: isSelected ? const Color(0xFF5D7CFF) : const Color(0xFF3F424B),
          ),
        ),
      ),
    );
  }
}