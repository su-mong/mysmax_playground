import 'package:flutter/material.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_condition_scenario_view_model.dart';
import 'package:mysmax_playground/add_scenario/view_models/add_scenario_view_model.dart';
import 'package:mysmax_playground/add_scenario/widgets/literal_block_widget.dart';
import 'package:mysmax_playground/add_scenario/widgets/value_service_block_widget.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/navigator_helper.dart';
import 'package:mysmax_playground/models/thing_value.dart';
import 'package:mysmax_playground/widgets/home_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../models/tag.dart';

class AddConditionScenarioPage extends StatefulWidget {
  final Block? parentBlock;
  final IfBlock? ifBlock;
  const AddConditionScenarioPage({Key? key, this.parentBlock, this.ifBlock})
      : super(key: key);

  Future push(BuildContext context) {
    final viewModel = AddConditionScenarioViewModel();
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: this,
    ).pushByPageRoute(context);
  }

  @override
  _AddConditionScenarioPageState createState() =>
      _AddConditionScenarioPageState();
}

class _AddConditionScenarioPageState extends State<AddConditionScenarioPage> {
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
              final viewModel = context.read<AddConditionScenarioViewModel>();
              final parentViewModel = context.read<AddScenarioViewModel>();
              print(viewModel.createBlock().toScenarioCode());
              if (widget.parentBlock != null) {
                parentViewModel.addChildScenarioItem(
                  parent: widget.parentBlock!,
                  child: viewModel.createBlock(),
                );
              } else if (widget.ifBlock != null) {
                parentViewModel.updateScenarioItem(
                    widget.ifBlock!, viewModel.createBlock());
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var viewModel = context.read<AddConditionScenarioViewModel>();
          viewModel.addCondition();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add),
            Text(
              "조건문",
              style: AppTextStyles.size11Medium.singleLine
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xffF8F9FD),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 150),
      itemBuilder: (context, index) {
        return _buildConditionItem(index);
      },
      separatorBuilder: (context, index) {
        return _buildOperator(index);
      },
      itemCount: viewModel.conditions.length,
    );
  }

  Widget _buildOperator(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          _buildOperatorItem(index, Operator.AND),
          const SizedBox(width: 7),
          _buildOperatorItem(index, Operator.OR),
        ],
      ),
    );
  }

  Widget _buildOperatorItem(int index, Operator value) {
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    bool isSelected = viewModel.operators[index] == value;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          viewModel.setOperator(index, value);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(41),
            side: BorderSide(
              color: isSelected
                  ? const Color(0xff5D7CFF)
                  : const Color(0xffE9ECF5),
            ),
          ),
        ),
        child: Text(
          value.toDisplayName,
          style: AppTextStyles.size14Medium.singleLine.copyWith(
            color:
                isSelected ? const Color(0xff5D7CFF) : const Color(0xff8F94A4),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionItem(int index) {
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildFirstValues(index),
        const SizedBox(height: 15),
        _buildConditionValues(index),
        const SizedBox(height: 15),
        _buildLastValues(index),
      ],
    );
  }

  Widget _buildFirstValues(int index) {
    var mqttViewModel = context.watch<MqttViewModel>();
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    var item = viewModel.conditions[index];
    if (item.firstValue != null && item.firstValue is ValueServiceExpression) {
      return ValueServiceBlockWidget(
        item.firstValue,
        onBlockChanged: (changedBlock) {
          viewModel.setFirstValueRangeType(
              index, changedBlock.valueServiceExpression.rangeType);
          viewModel.setFirstValue(
              index,
              item.firstValue?.copyWith(
                tags: changedBlock.valueServiceExpression.tags.map((e) {
                  return Tag(name: e);
                }).toList(),
              ));
        },
      );
    } else if (item.firstValue != null &&
        item.firstValue is LiteralExpression) {
      return LiteralBlockWidget(item.firstValue,
          onBlockChanged: (changedBlock) {
        viewModel.setFirstValue(index, changedBlock);
      });
    }
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      title: item.firstValue != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.firstValue!.name),
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
            .map((e) => _buildFirstValueItem(e, item.firstValue, (value) {
          viewModel.setFirstValue(
              index, value.toValueServiceExpression(RangeType.AUTO));
                }))
            .toList(),
      ],
    );
  }

  Widget _buildFirstValueItem(ThingValue value, ThingValue? currentValue,
      Function(ThingValue) onChangeValue) {
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    return GestureDetector(
      onTap: () {
        onChangeValue(value);
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
            if (currentValue == value)
              const Icon(
                Icons.check,
                color: Color(0xff45507B),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionValues(int index) {
    var mqttViewModel = context.watch<MqttViewModel>();
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    var item = viewModel.conditions[index];
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      title: item.conditionType != null
          ? Text(item.conditionType!.toTitle,
              style: AppTextStyles.size17Bold.singleLine)
          : Text("=(같다)"),
      children:
          operatorList.map((e) => _buildConditionTypeItem(index, e)).toList(),
    );
  }

  Widget _buildConditionTypeItem(int index, Operator value) {
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    return GestureDetector(
      onTap: () {
        viewModel.setConditionType(index, value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Text(
              value.toTitle,
            ),
            const Spacer(),
            if (viewModel.conditions[index].conditionType == value)
              const Icon(
                Icons.check,
                color: Color(0xff45507B),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastValues(int index) {
    var mqttViewModel = context.watch<MqttViewModel>();
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    var item = viewModel.conditions[index];
    if (item.lastValue != null) {
      if (item.lastValue is ValueServiceExpression) {
        return ValueServiceBlockWidget(
          item.lastValue,
          onBlockChanged: (changedBlock) {
            viewModel.setLastValueRangeType(
                index, changedBlock.valueServiceExpression.rangeType);
            viewModel.setLastValue(
                index,
                (item.lastValue as ThingValue).copyWith(
                  tags: changedBlock.valueServiceExpression.tags.map((e) {
                    return Tag(name: e);
                  }).toList(),
                ));
          },
        );
      } else if (item.lastValue is LiteralExpression) {
        return LiteralBlockWidget(item.lastValue,
            onBlockChanged: (changedBlock) {
          viewModel.setLastValue(index, changedBlock);
        });
      }
    }
    return ExpansionTile(
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      title: item.lastValue != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.lastValue!.name),
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
            .map((e) => _buildLastValueItem(index, e))
            .toList(),
        _buildNumberWidget(() {
          if (item.firstValue?.type == 'double') {
            viewModel.setLastValue(
                index, LiteralExpression(0.0, literalType: LiteralType.DOUBLE));
          } else {
            viewModel.setLastValue(
                index, LiteralExpression(0, literalType: LiteralType.INTEGER));
          }
        }),
        _buildStringWidget(() {
          viewModel.setLastValue(
              index, LiteralExpression('', literalType: LiteralType.STRING));
        }),
        _buildVarialbeWidget(() {}),
      ],
    );
  }

  Widget _buildLastValueItem(int index, ThingValue value) {
    var viewModel = context.watch<AddConditionScenarioViewModel>();
    return GestureDetector(
      onTap: () {
        viewModel.setLastValue(
            index, value.toValueServiceExpression(RangeType.AUTO));
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
            if (viewModel.conditions[index].lastValue == value)
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
