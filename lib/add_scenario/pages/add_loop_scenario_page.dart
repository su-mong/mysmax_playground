import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_loop_scenario_view_model.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/core/app_widgets.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/helper/date_time_helper.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/widgets/home_app_bar.dart';
import 'package:mysmax_playground/widgets/toggleable_date_picker.dart';
import 'package:mysmax_playground/widgets/toggleable_time_picker.dart';
import 'package:provider/provider.dart';
import 'package:wheel_picker/wheel_picker.dart';

class AddLoopScenarioPage extends StatefulWidget {
  final Block? parentBlock;
  final LoopBlock? loopBlock;
  const AddLoopScenarioPage({Key? key, this.parentBlock, this.loopBlock})
      : super(key: key);

  Future push(BuildContext context, {int level = 0}) {
    final viewModel = AddLoopScenarioViewModel();
    if (loopBlock != null) {
      viewModel.loadBlock(loopBlock!);
    }
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  _AddLoopScenarioPageState createState() => _AddLoopScenarioPageState();
}

class _AddLoopScenarioPageState extends State<AddLoopScenarioPage> {
  final durationTypeWheel = WheelPickerController(itemCount: 4);
  final weekDayWheel = WheelPickerController(itemCount: 7);
  final mSecWheel = WheelPickerController(itemCount: 1000);
  final secWheel = WheelPickerController(itemCount: 60);
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AddLoopScenarioViewModel>();
    return AppWidgets.scaffold(
      appBar: LinedAppBar.buildWithTitle(
        title: '반복 실행',
        actions: [
          TextButton(
            onPressed: () {
              var parentViewModel = context.read<AddScenarioViewModel>();
              if (widget.parentBlock != null) {
                parentViewModel.addChildScenarioItem(
                    parent: widget.parentBlock!, child: viewModel.data);
              } else if (widget.loopBlock != null) {
                parentViewModel.updateScenarioItem(
                    widget.loopBlock!, viewModel.data);
              } else {
                parentViewModel.addScenarioItem(viewModel.data);
              }
              Navigator.pop(context);
            },
            child: Text("완료"),
            style: TextButton.styleFrom(
              textStyle: AppTextStyles.size15Medium.singleLine,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 18),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var viewModel = context.watch<AddLoopScenarioViewModel>();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              _buildChip(
                text: '사용자 설정',
                onPressed: () => viewModel.loopType = LoopMode.MANUAL,
                isSelected: viewModel.loopType == LoopMode.MANUAL,
              ),
              const SizedBox(width: 8),
              _buildChip(
                text: '매일',
                onPressed: () => viewModel.loopType = LoopMode.DAILY,
                isSelected: viewModel.loopType == LoopMode.DAILY,
              ),
              const SizedBox(width: 8),
              _buildChip(
                text: '매주',
                onPressed: () => viewModel.loopType = LoopMode.WEEKLY,
                isSelected: viewModel.loopType == LoopMode.WEEKLY,
              ),
              const SizedBox(width: 8),
              _buildChip(
                text: '요일 선택',
                onPressed: () => viewModel.loopType = LoopMode.WEEKDAYSELECT,
                isSelected: viewModel.loopType == LoopMode.WEEKDAYSELECT,
              ),
            ],
          ),
          if (viewModel.loopType == LoopMode.MANUAL) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                const Spacer(),
                _buildTimeWheel(viewModel.durationType),
                const SizedBox(width: 8),
                _buildTypeWheel(),
                const SizedBox(width: 16),
                Text(
                  "마다",
                  style: AppTextStyles.size17Medium.singleLine.copyWith(
                    color: const Color(0xFF3F424B),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
          const SizedBox(height: 25),
          Row(
            children: [
              _buildChip(
                text: '시작 시간',
                onPressed: () {
                  viewModel.openStartTimePicker =
                      !viewModel.openStartTimePicker;
                },
                isSelected: viewModel.openStartTimePicker,
              ),
              const SizedBox(width: 8),
              _buildChip(
                text: '종료 시간',
                onPressed: () {
                  viewModel.openEndTimePicker = !viewModel.openEndTimePicker;
                },
                isSelected: viewModel.openEndTimePicker,
              ),
            ],
          ),
          if (viewModel.loopType != LoopMode.MANUAL) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                const Spacer(),
                if (viewModel.loopType == LoopMode.WEEKLY) ...[
                  _buildWeekDayWheel(),
                  const SizedBox(width: 8),
                ],
                Container(
                  height: 126,
                  width: 218,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: ToggleableTimePicker(
                    initialDate: DateTime.now(),
                    isToggled: true,
                    onDateTimeChanged: (DateTime value) {
                      if (viewModel.loopTime == null) {
                        viewModel.loopTime = value;
                      } else {
                        viewModel.loopTime =
                            viewModel.loopTime!.copyWithTime(time: value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "에",
                  style: AppTextStyles.size17Medium.singleLine.copyWith(
                    color: const Color(0xFF3F424B),
                  ),
                ),
                const Spacer(),
              ],
            )
          ],
          if (viewModel.loopType == LoopMode.WEEKDAYSELECT) ...[
            const SizedBox(height: 15),
            Row(
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: _buildChip(
                      text: index.toWeekDayEnum.toWeekDayShortString,
                      onPressed: () {
                        if (viewModel.weekDays.contains(index)) {
                          viewModel.removeWeekDay(index);
                        } else {
                          viewModel.addWeekDay(index);
                        }
                      },
                      isSelected: viewModel.weekDays.contains(index)),
                );
              }),
            )
          ],
          if (viewModel.openStartTimePicker) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Spacer(),
                Container(
                  height: 126,
                  width: 218,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: ToggleableDatePicker(
                    initialDate: DateTime.now(),
                    isToggled: true,
                    onDateTimeChanged: (DateTime value) {
                      if (viewModel.startTime == null) {
                        viewModel.startTime = value;
                      } else {
                        viewModel.startTime =
                            viewModel.startTime!.copyWithDate(date: value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "부터",
                  style: AppTextStyles.size17Medium.singleLine.copyWith(
                    color: const Color(0xFF3F424B),
                  ),
                ),
                const Spacer(),
              ],
            ),
            if (viewModel.loopType == LoopMode.MANUAL) ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  const Spacer(),
                  Container(
                    height: 126,
                    width: 218,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: ToggleableTimePicker(
                      initialDate: DateTime.now(),
                      isToggled: true,
                      onDateTimeChanged: (DateTime value) {
                        if (viewModel.startTime == null) {
                          viewModel.startTime = value;
                        } else {
                          viewModel.startTime =
                              viewModel.startTime!.copyWithTime(time: value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "부터",
                    style: AppTextStyles.size17Medium.singleLine.copyWith(
                      color: const Color(0xFF3F424B),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            ]
          ],
          if (viewModel.openEndTimePicker) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Spacer(),
                Container(
                  height: 126,
                  width: 218,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: ToggleableDatePicker(
                    initialDate: DateTime.now(),
                    isToggled: true,
                    onDateTimeChanged: (DateTime value) {
                      if (viewModel.endTime == null) {
                        viewModel.endTime = value;
                      } else {
                        viewModel.endTime =
                            viewModel.endTime!.copyWithDate(date: value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "까지",
                  style: AppTextStyles.size17Medium.singleLine.copyWith(
                    color: const Color(0xFF3F424B),
                  ),
                ),
                const Spacer(),
              ],
            ),
            if (viewModel.loopType == LoopMode.MANUAL) ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  const Spacer(),
                  Container(
                    height: 126,
                    width: 218,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: ToggleableTimePicker(
                      initialDate: DateTime.now(),
                      isToggled: true,
                      onDateTimeChanged: (DateTime value) {
                        viewModel.endTime = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "까지",
                    style: AppTextStyles.size17Medium.singleLine.copyWith(
                      color: const Color(0xFF3F424B),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            ],
          ]
        ],
      ),
    );
  }

  Widget _buildTimeWheel(PeriodType durationType) {
    return Container(
      width: 83,
      height: 126,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: IndexedStack(
            alignment: Alignment.center,
            index: durationType == PeriodType.MSEC ? 0 : 1,
            children: [
              SizedBox(
                width: 100,
                child: WheelPicker(
                  controller: mSecWheel,
                  builder: (context, index) => Text("${index + 1}",
                      style: AppTextStyles.size19Medium.singleLine),
                  selectedIndexColor: Color(0xff3F424B),
                  onIndexChanged: (index) {
                    var viewmodel = context.read<AddLoopScenarioViewModel>();
                    viewmodel.loopValue = index + 1;
                  },
                  style: const WheelPickerStyle(
                    size: 126,
                    squeeze: 0.75,
                    diameterRatio: 0.8,
                    surroundingOpacity: 0.25,
                    magnification: 1.2,
                  ),
                ),
              ),
              WheelPicker(
                controller: secWheel,
                builder: (context, index) => Text("${index + 1}",
                    style: AppTextStyles.size19Medium.singleLine),
                selectedIndexColor: Color(0xff3F424B),
                onIndexChanged: (index) {
                  var viewmodel = context.read<AddLoopScenarioViewModel>();
                  viewmodel.loopValue = index + 1;
                },
                style: const WheelPickerStyle(
                  size: 126,
                  squeeze: 0.75,
                  diameterRatio: 0.8,
                  surroundingOpacity: 0.25,
                  magnification: 1.2,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildTypeWheel() {
    var viewmodel = context.watch<AddLoopScenarioViewModel>();
    return Container(
      width: 83,
      height: 126,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: WheelPicker(
        builder: (context, index) => Text("${durationType[index].toName}",
            style: AppTextStyles.size19Medium.singleLine),
        controller: durationTypeWheel,
        selectedIndexColor: Color(0xff3F424B),
        onIndexChanged: (index) {
          viewmodel.durationType = durationType[index];
          setState(() {});
        },
        style: const WheelPickerStyle(
          size: 126,
          squeeze: 0.75,
          diameterRatio: 0.8,
          surroundingOpacity: 0.25,
          magnification: 1.2,
        ),
      ),
    );
  }

  Widget _buildWeekDayWheel() {
    var viewmodel = context.watch<AddLoopScenarioViewModel>();
    return Container(
      width: 83,
      height: 126,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: WheelPicker(
        builder: (context, index) => Text(index.toWeekDayEnum.toWeekDayString,
            style: AppTextStyles.size19Medium.singleLine),
        controller: weekDayWheel,
        selectedIndexColor: Color(0xff3F424B),
        onIndexChanged: (index) {
          viewmodel.weekDay = index;
          setState(() {});
        },
        style: const WheelPickerStyle(
          size: 126,
          squeeze: 0.75,
          diameterRatio: 0.8,
          surroundingOpacity: 0.25,
          magnification: 1.2,
        ),
      ),
    );
  }

  Widget _buildChip({
    required String text,
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1,
                  color: isSelected ? Color(0xFF5D7CFF) : Color(0xFFE9ECF5)),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: AppTextStyles.size14Medium.singleLine.copyWith(
                  color: isSelected ? Color(0xFF5D7CFF) : Color(0xFF3F424B),
                ),
              ),
            ],
          ),
        ));
  }
}
