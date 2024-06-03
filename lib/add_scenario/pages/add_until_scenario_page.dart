import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_until_scenario_view_model.dart';
import 'package:mysmax_playground/add_scenario/widgets/literal_block_widget.dart';
import 'package:mysmax_playground/add_scenario/widgets/value_service_block_widget.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/models/enums/condition_type.dart';
import 'package:mysmax_playground/models/thing_value.dart';
import 'package:mysmax_playground/widgets/home_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../models/tag.dart';

class AddUntilScenarioPage extends StatefulWidget {
  final Block? parentBlock;
  final WaitUntilBlock? untilBlock;
  const AddUntilScenarioPage({Key? key, this.parentBlock, this.untilBlock})
      : super(key: key);

  Future push(BuildContext context) {
    final viewModel = AddUntilScenarioViewModel();
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  _AddUntilScenarioPageState createState() => _AddUntilScenarioPageState();
}

class _AddUntilScenarioPageState extends State<AddUntilScenarioPage> {
  final TextEditingController _firstValueTextController =
      TextEditingController();
  final TextEditingController _lastValueTextController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LinedAppBar.buildWithTitle(
        title: '분기 실행',
        actions: [
          TextButton(
            onPressed: () {
              final viewModel = context.read<AddUntilScenarioViewModel>();
              final parentViewModel = context.read<AddScenarioViewModel>();
              if (widget.parentBlock != null) {
                parentViewModel.addChildScenarioItem(
                  parent: widget.parentBlock!,
                  child: viewModel.createBlock(),
                );
              } else if (widget.untilBlock != null) {
                parentViewModel.updateScenarioItem(
                    widget.untilBlock!, viewModel.createBlock());
              } else {
                parentViewModel.addScenarioItem(viewModel.createBlock());
              }
              Navigator.pop(context);
            },
            child: Text("완료"),
          ),
        ],
        backgroundColor: const Color(0xffF8F9FD),
      ),
      backgroundColor: const Color(0xffF8F9FD),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var viewModel = context.watch<AddUntilScenarioViewModel>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildFirstValues(),
            const SizedBox(height: 15),
            _buildConditionValues(),
            const SizedBox(height: 15),
            _buildLastValues(),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstValues() {
    var mqttViewModel = context.watch<MqttViewModel>();
    var viewModel = context.watch<AddUntilScenarioViewModel>();
    if (viewModel.firstValue != null) {
      return ValueServiceBlockWidget(
        viewModel.firstValueToExpression(),
        onBlockChanged: (changedBlock) {
          viewModel.firstValueRangeType =
              changedBlock.valueServiceExpression.rangeType;
          viewModel.firstValue = viewModel.firstValue?.copyWith(
            tags: changedBlock.valueServiceExpression.tags.map((e) {
              return Tag(name: e);
            }).toList(),
          );
        },
      );
    }
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      title: viewModel.firstValue != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(viewModel.firstValue!.name),
              ],
            )
          : Text("센서, 디바이스 상태", style: AppTextStyles.size17Bold.singleLine),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _firstValueTextController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '센서 검색',
                hintStyle: AppTextStyles.size14Regular
                    .heightWith(1)
                    .copyWith(color: Color(0xffadb3c6)),
                suffixIcon: Icon(Icons.search),
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
        ),
        ...mqttViewModel.serviceValueList
            .map((e) => _buildFirstValueItem(e))
            .toList(),
      ],
    );
  }

  Widget _buildFirstValueItem(ThingValue value) {
    var viewModel = context.watch<AddUntilScenarioViewModel>();
    return GestureDetector(
      onTap: () {
        viewModel.firstValue = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Expanded(
                child: Text(
              value.name,
              style: AppTextStyles.size16Medium.singleLine,
            )),
            if (viewModel.firstValue == value)
              const Icon(
                Icons.check,
                color: Color(0xff45507B),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionValues() {
    var mqttViewModel = context.watch<MqttViewModel>();
    var viewModel = context.watch<AddUntilScenarioViewModel>();
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      title: viewModel.conditionType != null
          ? Text(viewModel.conditionType!.toTitle,
              style: AppTextStyles.size17Bold.singleLine)
          : Text("센서, 디바이스 상태"),
      children:
          ConditionType.values.map((e) => _buildConditionTypeItem(e)).toList(),
    );
  }

  Widget _buildConditionTypeItem(ConditionType value) {
    var viewModel = context.watch<AddUntilScenarioViewModel>();
    return GestureDetector(
      onTap: () {
        viewModel.conditionType = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Text(
              value.toTitle,
            ),
            const Spacer(),
            if (viewModel.conditionType == value)
              const Icon(
                Icons.check,
                color: Color(0xff45507B),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastValues() {
    var mqttViewModel = context.watch<MqttViewModel>();
    var viewModel = context.watch<AddUntilScenarioViewModel>();
    if (viewModel.lastValue != null) {
      if (viewModel.lastValue is ThingValue) {
        return ValueServiceBlockWidget(
          viewModel.lastValueToExpression(),
          onBlockChanged: (changedBlock) {
            viewModel.lastValueRangeType =
                changedBlock.valueServiceExpression.rangeType;
            viewModel.lastValue = (viewModel.lastValue as ThingValue).copyWith(
              tags: changedBlock.valueServiceExpression.tags.map((e) {
                return Tag(name: e);
              }).toList(),
            );
          },
        );
      } else if (viewModel.lastValue is LiteralExpression) {
        return LiteralBlockWidget(viewModel.lastValue,
            onBlockChanged: (changedBlock) {
          viewModel.lastValue = changedBlock;
        });
      }
    }
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      title: viewModel.lastValue != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(viewModel.lastValue!.name),
              ],
            )
          : Text("센서, 디바이스 상태", style: AppTextStyles.size17Bold.singleLine),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _lastValueTextController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '센서 검색',
                hintStyle: AppTextStyles.size14Regular
                    .heightWith(1)
                    .copyWith(color: Color(0xffadb3c6)),
                suffixIcon: Icon(Icons.search),
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
        ),
        ...mqttViewModel.serviceValueList
            .map((e) => _buildLastValueItem(e))
            .toList(),
        _buildNumberWidget(() {
          if (viewModel.firstValue?.type == 'double') {
            viewModel.lastValue =
                LiteralExpression(0.0, literalType: LiteralType.DOUBLE);
          } else {
            viewModel.lastValue =
                LiteralExpression(0, literalType: LiteralType.INTEGER);
          }
        }),
        _buildStringWidget(() {
          viewModel.lastValue =
              LiteralExpression('', literalType: LiteralType.STRING);
        }),
        _buildVarialbeWidget(() {}),
      ],
    );
  }

  Widget _buildLastValueItem(ThingValue value) {
    var viewModel = context.watch<AddUntilScenarioViewModel>();
    return GestureDetector(
      onTap: () {
        viewModel.lastValue = value;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Expanded(
                child: Text(
              value.name,
              style: AppTextStyles.size16Medium.singleLine,
            )),
            if (viewModel.lastValue == value)
              const Icon(
                Icons.check,
                color: Color(0xff45507B),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberWidget(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Text(
              "숫자",
              style: AppTextStyles.size17Bold.singleLine,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStringWidget(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Text(
              "문자",
              style: AppTextStyles.size17Bold.singleLine,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVarialbeWidget(VoidCallback onTap) {
    return ExpansionTile(
      title: Text(
        "서비스 결과값",
        style: AppTextStyles.size17Bold.singleLine,
      ),
    );
  }
}
