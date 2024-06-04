import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysmax_playground/add_scenario/pages/add_condition_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_loop_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_service_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/pages/add_until_scenario_page.dart';
import 'package:mysmax_playground/add_scenario/widgets/scenario_service_item.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/date_time_helper.dart';
import 'package:mysmax_playground/models/enums/scenario_item_type.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/models/thing.dart';
import 'package:mysmax_playground/scenario_mixin.dart';
import 'package:mysmax_playground/widgets/radio_toggle.dart';
import 'package:mysmax_playground/widgets/tag_list_widget.dart';
import 'package:provider/provider.dart';

class ScenarioItemWidget<T extends Block> extends StatefulWidget {
  final T item;

  const ScenarioItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  _ScenarioItemWidgetState createState() => _ScenarioItemWidgetState();
}

class _ScenarioItemWidgetState<T extends Block>
    extends State<ScenarioItemWidget> {
  bool isEditTagMode = false;

  TextEditingController _variableController = TextEditingController();
  FocusNode _variableFocusNode = FocusNode();

  TextEditingController _tagController = TextEditingController();
  FocusNode _tagFocusNode = FocusNode();

  List<String> selectedTags = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: widget.item.getLeftPadding().toDouble(),
            right: 18,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                width: 3,
                color: widget.item.getColor(),
              ),
              bottom: const BorderSide(
                width: 1,
                color: Color(0xffE2E5ED),
              ),
            ),
          ),
          child: Builder(
            builder: (context) {
              if (widget.item is FunctionServiceBlock) {
                return _buildScenarioService(
                    widget.item as FunctionServiceBlock);
              } else if (widget.item is ValueServiceBlock) {
                return _buildScenarioValue(widget.item as ValueServiceBlock);
              } else if (widget.item is LoopBlock) {
                return _buildScenarioLoop(widget.item as LoopBlock);
              } else if (widget.item is IfBlock) {
                return _buildScenarioCondition(widget.item as IfBlock);
              } else if (widget.item is WaitUntilBlock) {
                return _buildScenarioUntil(widget.item as WaitUntilBlock);
              } else if (widget.item is ElseBlock) {
                return _buildScenarioType("else");
              } else {
                return Container();
              }
            },
          ),
        ),
        ...widget.item.blocks.map((e) {
          return ScenarioItemWidget(
            e,
            // onChangeItem: (block) {
            //   setState(() {
            //     for (var e in changedItem.blocks) {
            //       if (e.uid == block.uid) {
            //         changedItem.updateBlock(e, block);
            //       }
            //     }
            //
            //     // c.blocks = c.blocks.map((e) {
            //     //   if (e.uid == block.uid) {
            //     //     return block;
            //     //   }
            //     //   return e;
            //     // }).toList();
            //   });
            //   widget.onChangeItem.call(changedItem);
            // },
          );
        }),
      ],
    );
  }

  Widget _buildScenarioCondition(IfBlock item) {
    return Column(
      children: [
        _buildScenarioType("if"),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xffF3F5FA),
        ),
        GestureDetector(
          onTap: () {
            AddConditionScenarioPage(ifBlock: item).push(context);
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 15,
            ).copyWith(right: 12),
            child: Row(
              children: [
                Expanded(child: Text.rich(item.condition.expressionTextSpan)),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/arrow_right.svg',
                    width: 22,
                    height: 22,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildScenarioUntil(WaitUntilBlock item) {
    return Column(
      children: [
        _buildScenarioType("Until"),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xffF3F5FA),
        ),
        GestureDetector(
          onTap: () {
            AddUntilScenarioPage(untilBlock: item).push(context);
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 15,
            ).copyWith(right: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text.rich(TextSpan(
                        style: AppTextStyles.size13Medium.singleLine,
                        children: [
                      item.condition?.leftExpressionTextSpan ?? TextSpan(),
                      TextSpan(
                        text: " ${item.condition?.operator.value} ",
                      ),
                      item.condition?.rightExpressionTextSpan ?? TextSpan(),
                    ]))),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/arrow_right.svg',
                    width: 22,
                    height: 22,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildScenarioType(String blockName) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 15,
      ).copyWith(right: 12),
      child: Row(
        children: [
          Text(
            blockName,
            style: AppTextStyles.size17Bold.singleLine,
          ),
          const Spacer(),
          SizedBox(
            height: 22,
            width: 22,
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Color(0xff46517D).withOpacity(0.2),
              splashRadius: 12,
              onSelected: (String result) {
                if (result == '삭제') {
                  var viewModel = context.read<ScenarioMixin>();
                  viewModel.removeScenarioItem(widget.item);
                }
              },
              padding: EdgeInsets.zero,
              // itemBuilder 에서 PopMenuItem 리스트 리턴해줘야 함.
              itemBuilder: (BuildContext buildContext) {
                return [
                  PopupMenuItem(
                    value: '삭제',
                    child: Text('삭제'),
                  )
                ];
              },
              iconSize: 22,
              icon: SvgPicture.asset('assets/icons/more_vert.svg'),
            ),
          ),
          PopupMenuButton<ScenarioItemType>(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/icons/add.svg',
              width: 22,
              height: 22,
            ),
            onSelected: (ScenarioItemType value) {
              _onMenuItemSelected(value);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            itemBuilder: (ctx) => [
              _buildPopupMenuItem('서비스', ScenarioItemType.Service),
              _buildPopupMenuItem('조건', ScenarioItemType.If),
              _buildPopupMenuItem('반복', ScenarioItemType.Loop),
              _buildPopupMenuItem('조건부', ScenarioItemType.Until),
              _buildPopupMenuItem('else', ScenarioItemType.Else),
            ],
          )

          // GestureDetector(
          //   onTap: () {
          //     // TODO: child용 item 추가 팝업
          //   },
          //   child: SvgPicture.asset(
          //     'assets/icons/add.svg',
          //     width: 22,
          //     height: 22,
          //   ),
          // )
        ],
      ),
    );
  }

  PopupMenuItem<ScenarioItemType> _buildPopupMenuItem(
      String title, ScenarioItemType type) {
    return PopupMenuItem<ScenarioItemType>(
      value: type,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.size13Medium.singleLine,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  _onMenuItemSelected(ScenarioItemType value) {
    switch (value) {
      case ScenarioItemType.Service:
        AddServiceScenarioPage(parentBlock: widget.item).push(context);
        break;
      case ScenarioItemType.If:
        AddConditionScenarioPage(parentBlock: widget.item).push(context);
        break;
      case ScenarioItemType.Loop:
        AddLoopScenarioPage(parentBlock: widget.item).push(context);
        break;
      case ScenarioItemType.Until:
        AddUntilScenarioPage(parentBlock: widget.item).push(context);
        break;
      case ScenarioItemType.Else:
        if (widget.item is IfBlock) {
          var viewModel = context.read<ScenarioMixin>();
          viewModel.addSameLevelScenarioItem(
              currentBlock: widget.item, newBlock: ElseBlock());
        }
        break;
      default:
        break;
    }
  }

  Widget _buildScenarioService(FunctionServiceBlock item) {
    return ScenarioServiceItem(
      item,
      onChanged: (block) {
        var viewModel = context.read<ScenarioMixin>();
        viewModel.updateScenarioItem(item, item.copyWith(block));
      },
    );
  }

  Widget _buildScenarioValue(ValueServiceBlock item) {
    var mqttViewModel = context.watch<MqttViewModel>();
    var value =
        mqttViewModel.getValueByName(item.valueServiceExpression.serviceName);
    var thingList = mqttViewModel
        .thingListByValueName(item.valueServiceExpression.serviceName);
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 15,
      ).copyWith(right: 12),
      title: Text(
        item.valueServiceExpression.serviceName,
        style: AppTextStyles.size17Bold.singleLine,
      ),
      iconColor: AppColors.defaultTextColor,
      collapsedIconColor: AppColors.defaultTextColor,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("태그",
                  style: AppTextStyles.size11Medium.singleLine.copyWith(
                    color: const Color(0xff8F94A4),
                  )),
              const SizedBox(height: 8),
              TagListWidget(
                totalTags: value?.tags ?? [],
                initialSelectedTags: item.valueServiceExpression.tags.map((e) {
                  return Tag(name: e);
                }).toList(),
                onAddTagChanged: (tag) {
                  for (var element in thingList) {
                    mqttViewModel.addTag(
                      thing: element.name,
                      service: item.valueServiceExpression.serviceName,
                      tag: tag.toString(),
                    );
                  }
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    mqttViewModel.getThingList();
                    mqttViewModel.getServiceList();
                  });
                },
                onIsEditTagModeChanged: (value) {
                  setState(() {
                    isEditTagMode = value;
                  });
                },
                isEditTagMode: isEditTagMode,
                controller: _tagController,
                focusNode: _tagFocusNode,
                onSelectedTagsChanged: (List<Tag> selectedTags) {
                  setState(() {
                    this.selectedTags =
                        selectedTags.map((e) => e.name).toList();
                    var changedItem = item.copyWith(
                      ValueServiceBlock(
                        item.valueServiceExpression.copyWith(
                            tags: selectedTags.map((e) {
                          return e.name;
                        }).toList()),
                        item.variableName,
                      ),
                    );
                    var scenarioViewModel = context.read<ScenarioMixin>();
                    scenarioViewModel.updateScenarioItem(
                        item, item.copyWith(changedItem));
                  });
                },
              ),
              // Row(
              //   children: [
              //     GestureDetector(
              //       child: SvgPicture.asset(
              //         'assets/icons/icon_add.svg',
              //         width: 25,
              //         height: 25,
              //       ),
              //     ),
              // ...(item.valueServiceExpression.tags ?? [])
              //     .map((e) => Container(
              //           margin: const EdgeInsets.only(right: 4),
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 9, vertical: 5),
              //           decoration: ShapeDecoration(
              //             color: Color(0xFFF0F2F9),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(14),
              //             ),
              //           ),
              //           child: Text(
              //             e,
              //             style: AppTextStyles.size11Medium.singleLine
              //                 .copyWith(
              //               color: const Color(0xff8F94A4),
              //             ),
              //           ),
              //         ))
              //   ],
              // )
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xffF3F5FA),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("디바이스",
                  style: AppTextStyles.size11Medium.singleLine.copyWith(
                    color: const Color(0xff8F94A4),
                  )),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      var viewModel = context.read<ScenarioMixin>();
                      viewModel.updateScenarioItem(
                          item,
                          item.copyWith(
                            ValueServiceBlock(
                                item.valueServiceExpression.copyWith(
                                  rangeType: RangeType.ANY,
                                ),
                                item.variableName),
                          ));
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      children: [
                        RadioToggleButton(
                          toggled: item.valueServiceExpression.rangeType ==
                              RangeType.ANY,
                          size: 15,
                          innerSize: 10,
                        ),
                        const SizedBox(width: 4),
                        Text("모두 선택",
                            style: AppTextStyles.size12Medium.singleLine),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () {
                      var viewModel = context.read<ScenarioMixin>();
                      viewModel.updateScenarioItem(
                          item,
                          item.copyWith(
                            ValueServiceBlock(
                                item.valueServiceExpression.copyWith(
                                  rangeType: RangeType.AUTO,
                                ),
                                item.variableName),
                          ));
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      children: [
                        RadioToggleButton(
                          toggled: item.valueServiceExpression.rangeType ==
                              RangeType.AUTO,
                          size: 15,
                          innerSize: 10,
                        ),
                        const SizedBox(width: 4),
                        Text("자동 선택",
                            style: AppTextStyles.size12Medium.singleLine),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Selector<MqttViewModel, List<Thing>>(
                  selector: (context, mqttViewModel) =>
                      mqttViewModel.thingListByValueName(
                          item.valueServiceExpression.serviceName),
                  builder: (context, things, child) {
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: things.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(things[index].name,
                                style: AppTextStyles.size13Medium.singleLine),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                    );
                  }),
              _buildVariableList(context, item: item),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildScenarioLoop(LoopBlock item) {
    return Column(
      children: [
        _buildScenarioType("반복"),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xffF3F5FA),
        ),
        GestureDetector(
          onTap: () {
            AddLoopScenarioPage(loopBlock: item).push(context);
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 15,
            ).copyWith(right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(item.loop?.loop_type.toNamed ?? '',
                      //     style: AppTextStyles.size17Bold.singleLine),
                      // const SizedBox(height: 7),
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.size13Medium.copyWith(
                            color: Color(0xFF3F424B),
                          ),
                          children: _buildLoopText(item),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/arrow_right.svg',
                    width: 22,
                    height: 22,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  List<InlineSpan> _buildLoopText(LoopBlock item) {
    switch (item.loopMode) {
      case LoopMode.MANUAL:
        return [
          if (item.period?.periodType != null) ...[
            TextSpan(
                text: item.period?.periodType
                        .toDisplayName(item.period?.period.value as int?) ??
                    '',
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 마다\n'),
          ],
          if (item.timeBound.isNotEmpty && item.timeBound[0] != null) ...[
            TextSpan(
                text: (item.timeBound[0] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 부터\n'),
          ],
          if (item.timeBound.length > 1 && item.timeBound[1] != null) ...[
            TextSpan(
                text: (item.timeBound[1] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 까지'),
          ],
        ];
      case LoopMode.DAILY:
        return [
          TextSpan(
              text: '매일',
              style: TextStyle(
                color: Color(0xFF5D7CFF),
              )),
          TextSpan(text: ' 마다\n'),
          if (item.timeBound[0] != null) ...[
            TextSpan(
                text: (item.timeBound[0] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 부터\n'),
          ],
          if (item.timeBound[1] != null) ...[
            TextSpan(
                text: (item.timeBound[1] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 까지'),
          ],
        ];
      /*case LoopMode.WEEKLY:
        return [
          TextSpan(
              text:
                  '매주 ${item.weekdays.map((e) => e.toWeekDayShortString).join(",")}요일',
              style: TextStyle(
                color: Color(0xFF5D7CFF),
              )),
          TextSpan(text: ' 마다\n'),
          if (item.timeBound[0] != null) ...[
            TextSpan(
                text: (item.timeBound[0] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 부터\n'),
          ],
          if (item.timeBound[1] != null) ...[
            TextSpan(
                text: (item.timeBound[1] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 까지'),
          ],
        ];*/
      case LoopMode.WEEKDAYSELECT:
        return [
          if (item.timeBound[0] != null) ...[
            TextSpan(
                text: (item.timeBound[0] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 부터\n'),
          ],
          if (item.timeBound[1] != null) ...[
            TextSpan(
                text: (item.timeBound[1] as DateTime).toDateTimeFullString(),
                style: TextStyle(
                  color: Color(0xFF5D7CFF),
                )),
            TextSpan(text: ' 까지'),
          ],
          TextSpan(
              text: item.weekdays.map((e) => e.toWeekDayShortString).join(","),
              style: TextStyle(
                color: Color(0xFF5D7CFF),
              )),
          TextSpan(text: '에'),
        ];
      default:
        return [];
    }
  }

  Widget _buildVariableList(BuildContext context,
      {required ValueServiceBlock item}) {
    var viewModel = context.watch<ScenarioMixin>();
    var variableList = viewModel.searchVariableList;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "변수값 저장",
            style: AppTextStyles.size11Medium.singleLine.copyWith(
              color: const Color(0xff8F94A4),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _variableController,
            onChanged: (value) async {
              viewModel.updateScenarioItem(
                  item,
                  item.copyWith(
                    ValueServiceBlock(item.valueServiceExpression, value),
                  ));
            },
            style: AppTextStyles.size12Regular.singleLine,
            focusNode: _variableFocusNode,
            decoration: InputDecoration(
              hintText: '변수명을 입력해주세요',
              hintStyle: AppTextStyles.size12Regular.singleLine.copyWith(
                color: Color(0xff8F94A4),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 6,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color(0xffE2E5ED),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var e = variableList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _variableController.text = e;
                      viewModel.updateScenarioItem(
                          item,
                          item.copyWith(
                            ValueServiceBlock(item.valueServiceExpression, e),
                          ));
                    });
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    child: Text(
                      e,
                      style: AppTextStyles.size13Medium.singleLine,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffF0f2f9),
                );
              },
              itemCount: variableList.length),
          if (_variableController.text.isNotEmpty &&
              !variableList
                  .any((element) => element == _variableController.text)) ...[
            Text.rich(TextSpan(
              children: [
                TextSpan(
                  text: '추가 ',
                  style: AppTextStyles.size11Medium.singleLine.copyWith(
                    color: Color(0xff8f94a4),
                  ),
                ),
                TextSpan(
                  text: _variableController.text,
                  style: AppTextStyles.size13Medium.singleLine,
                ),
              ],
            ))
          ],
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
