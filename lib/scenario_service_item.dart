import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/argument_widget.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/helper/icon_helper.dart';
import 'package:mysmax_playground/models/function_argument.dart';
import 'package:mysmax_playground/models/thing.dart';
import 'package:mysmax_playground/models/thing_function.dart';
import 'package:mysmax_playground/scenario_mixin.dart';
import 'package:mysmax_playground/widgets/radio_toggle.dart';
import 'package:mysmax_playground/widgets/tag_list_widget.dart';
import 'package:provider/provider.dart';

import '../../../models/tag.dart';

class ScenarioServiceItem extends StatefulWidget {
  final FunctionServiceBlock item;
  final Function(FunctionServiceBlock)? onChanged;
  const ScenarioServiceItem(this.item, {Key? key, this.onChanged})
      : super(key: key);

  @override
  _ScenarioServiceItemState createState() => _ScenarioServiceItemState();
}

class _ScenarioServiceItemState extends State<ScenarioServiceItem> {
  late ThingFunction? function;

  bool isExpanded = false;

  bool isEditTagMode = false;
  bool isAllDeviceSelected = true;

  List<String> selectedTags = [];

  TextEditingController _tagController = TextEditingController();
  FocusNode _tagFocusNode = FocusNode();

  TextEditingController _variableController = TextEditingController();
  FocusNode _variableFocusNode = FocusNode();

  @override
  void initState() {
    function = ThingFunction(
      name: 'ThingFunction',
      description: 'ThingFunction description',
      category: 'color',
      exec_time: 0,
      energy: 2,
      is_private: 0,
      is_opened: 0,
      return_type: 'color',
      use_arg: 0,
    );
    _variableController.text = widget.item.variableName ?? '';
    super.initState();

    /*
    print('tags: ${widget.item.tags}');
    print('arguments: ${widget.item.arguments.map((e) => e.valueString).toList()}');
    print('functionServiceReturnType: ${widget.item.functionServiceReturnType}');
    print('rangeType: ${widget.item.rangeType}');
    print('serviceName: ${widget.item.serviceName}');
    print('variableName: ${widget.item.variableName}');
    print('blockType: ${widget.item.blockType}');
    print('blocks: ${widget.item.blocks}');
    print('');
    */
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = value;
        });
      },
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 15,
      ).copyWith(right: 12),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(null),
          const SizedBox(width: 9),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                function?.name ?? widget.item.serviceName,
                style: AppTextStyles.size17Bold.singleLine,
              ),
              if (widget.item.arguments.isNotEmpty && !isExpanded) ...[
                const SizedBox(height: 8),
                Builder(
                  builder: (context) {
                    var count = widget.item.arguments.length;
                    var orderedArguments =
                        List<FunctionArgument>.from(function?.arguments ?? []);
                    orderedArguments.sort((a, b) => a.order.compareTo(b.order));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(orderedArguments.length, (index) {
                        var argument = widget.item.arguments[index];
                        var loadedArgument = orderedArguments[index].copyWith(
                          value: argument.value,
                        );
                        return Text.rich(TextSpan(
                          style: AppTextStyles.size13Medium.copyWith(
                            color: Color(0xFF3F424B),
                          ),
                          children: [
                            TextSpan(
                              text: loadedArgument.name,
                            ),
                            TextSpan(
                              text: ' ${loadedArgument.value}',
                              style: TextStyle(
                                color: Color(0xFF5D7CFF),
                              ),
                            ),
                          ],
                        ));
                      }),
                      // children: widget.item.arguments.map((e) {
                      //   return Text.rich(TextSpan(
                      //     style: AppTextStyles.size13Medium.copyWith(
                      //       color: Color(0xFF3F424B),
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         text: e.literalType.name,
                      //       ),
                      //       TextSpan(
                      //         text: ' ${e.value}',
                      //         style: TextStyle(
                      //           color: Color(0xFF5D7CFF),
                      //         ),
                      //       ),
                      //     ],
                      //   ));
                      // }).toList()
                    );
                  },
                ),
              ]
            ],
          ))
        ],
      ),
      iconColor: AppColors.defaultTextColor,
      collapsedIconColor: AppColors.defaultTextColor,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const SizedBox(width: 3),
          SizedBox(
            height: 22,
            width: 22,
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Color(0xff46517D).withOpacity(0.2),
              splashRadius: 12,
              onSelected: (String result) {
                print('result is $result');
              },
              // itemBuilder 에서 PopMenuItem 리스트 리턴해줘야 함.
              itemBuilder: (BuildContext buildContext) {
                return [
                  PopupMenuItem(
                    value: '서비스',
                    child: Text('서비스'),
                  ),
                  PopupMenuItem(
                    value: '조건',
                    child: Text('조건'),
                  ),
                  PopupMenuItem(
                    value: '반복',
                    child: Text('반복'),
                  ),
                  PopupMenuItem(
                    value: '조건부',
                    child: Text('조건부'),
                  ),
                ];
              },
              iconSize: 22,
              icon: SvgPicture.asset('assets/icons/add.svg'),
            ),
          ),
        ],
      ),
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
              Container(
                child: TagListWidget(
                  totalTags: function?.tags ?? [],
                  initialSelectedTags: widget.item.tags.map((e) {
                    return Tag(name: e);
                  }).toList(),
                  onAddTagChanged: (tag) {
                    print('onAddTagChanged');
                    /*
                    var thingList = mqttViewModel
                        .thingListByFunctionName(widget.item.serviceName);
                    for (var element in thingList) {
                      mqttViewModel.addTag(
                        thing: element.name,
                        service: widget.item.serviceName,
                        tag: tag.toString(),
                      );
                    }
                    List<Tag> tags = [
                      ...widget.item.tags.map((e) {
                        return Tag(name: e);
                      }).toList(),
                      tag,
                    ];
                    function = function?.copyWith(tags: tags);
                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      mqttViewModel.getThingList();
                      mqttViewModel.getServiceList();
                    });
                    setData();
                    */
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
                      setData();
                    });
                  },
                ),
                // child: Row(
                //   children: [
                //     Expanded(
                //       child: SizedBox(
                //         height: 30,
                //         child: ListView.separated(
                //           shrinkWrap: true,
                //           scrollDirection: Axis.horizontal,
                //           itemCount: widget.item.tags.length + 1,
                //           itemBuilder: (context, index) {
                //             if (index == (widget.item.tags.length ?? 0) &&
                //                 !isEditTagMode) {
                //               return GestureDetector(
                //                   child:
                //                       SvgPicture.asset('assets/icons/add.svg'),
                //                   onTap: () {
                //                     setState(() {
                //                       isEditTagMode = true;
                //                       setData();
                //                     });
                //                   });
                //             } else if (index == (widget.item.tags.length) &&
                //                 isEditTagMode) {
                //               return Container(
                //                 constraints: BoxConstraints(
                //                   maxWidth: 100,
                //                 ),
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 9, vertical: 5),
                //                 alignment: Alignment.center,
                //                 decoration: ShapeDecoration(
                //                   color: Color(0xffF0F2F9),
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(14),
                //                   ),
                //                 ),
                //                 child: TextField(
                //                   decoration: InputDecoration(
                //                     border: InputBorder.none,
                //                     hintText: '태그 추가',
                //                     hintStyle: AppTextStyles
                //                         .size11Medium.singleLine
                //                         .copyWith(
                //                       color: const Color(0xff3F424B),
                //                     ),
                //                   ),
                //                   onSubmitted: (value) {
                //                     var mqttViewModel =
                //                         context.read<MqttViewModel>();
                //                     var thingList = mqttViewModel
                //                         .thingListByFunction(function);
                //                     for (var element in thingList) {
                //                       mqttViewModel
                //                           .requestData(MqttType.addTag, data: {
                //                         "thing": element.name,
                //                         "service": function?.name ?? '',
                //                         "tag": value,
                //                       });
                //                     }
                //                     List<Tag> tags = [
                //                       ...(function?.tags ?? []),
                //                       Tag(name: value)
                //                     ];
                //                     function = function?.copyWith(tags: tags);
                //                     setState(() {
                //                       isEditTagMode = false;
                //                       setData();
                //                     });
                //                   },
                //                 ),
                //               );
                //             }
                //             var e = widget.item.tags[index];
                //             bool isSelected = selectedTags.contains(e);
                //             return GestureDetector(
                //               onTap: () {
                //                 setState(() {
                //                   selectedTags.contains(e)
                //                       ? selectedTags.remove(e)
                //                       : selectedTags.add(e);
                //                   setData();
                //                 });
                //               },
                //               child: Container(
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 9, vertical: 5),
                //                 alignment: Alignment.center,
                //                 decoration: ShapeDecoration(
                //                   color: Color(0xffF0F2F9),
                //                   shape: RoundedRectangleBorder(
                //                     side: BorderSide(
                //                         width: 1,
                //                         color: isSelected
                //                             ? AppColors.blue
                //                             : Color(0xFFE9ECF5)),
                //                     borderRadius: BorderRadius.circular(14),
                //                   ),
                //                 ),
                //                 child: Text(
                //                   e,
                //                   style: AppTextStyles.size12Medium.singleLine
                //                       .heightWith(1.0)
                //                       .copyWith(
                //                         color: isSelected
                //                             ? AppColors.blue
                //                             : const Color(0xff3F424B),
                //                       ),
                //                 ),
                //               ),
                //             );
                //           },
                //           separatorBuilder: (context, index) {
                //             return const SizedBox(width: 4);
                //           },
                //         ),
                //       ),
                //     )
                //   ],
                // ),
              ),
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
                      setState(() {
                        isAllDeviceSelected = true;
                        setData();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioToggleButton(
                            toggled: isAllDeviceSelected,
                            size: 15,
                            innerSize: 10,
                          ),
                          const SizedBox(width: 4),
                          Text("모두 선택",
                              style: AppTextStyles.size12Medium.singleLine),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isAllDeviceSelected = false;
                          setData();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioToggleButton(
                              toggled: !isAllDeviceSelected,
                              size: 15,
                              innerSize: 10,
                            ),
                            const SizedBox(width: 4),
                            Text("자동 선택",
                                style: AppTextStyles.size12Medium.singleLine),
                          ],
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 20),

              Column(
                children: [
                  ...[] /// TODO: Thing LIST
                      .where((element) {
                    if (selectedTags.isEmpty) {
                      return true;
                    }
                    return element.functions.any((e) {
                      return selectedTags.any((tag) =>
                      (e.tags?.map((e) => e.name).contains(tag) ??
                          false) &&
                          e.name == widget.item.serviceName);
                    });
                  })
                      .map((e) => _buildDevice(e))
                      .toList()
                ],
              ),

              if (widget.item.arguments.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffF3F5FA),
                ),
                const SizedBox(height: 15),
                Text("세부 옵션",
                    style: AppTextStyles.size11Medium.singleLine.copyWith(
                      color: const Color(0xff8F94A4),
                    )),
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  var orderedArguments =
                      List<FunctionArgument>.from(function?.arguments ?? []);
                  orderedArguments.sort((a, b) => a.order.compareTo(b.order));
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderedArguments.length,
                    itemBuilder: (context, index) {
                      var argument = widget.item.arguments[index];
                      var loadedArgument = orderedArguments[index].copyWith(
                        value: argument.value,
                      );
                      return ArgumentWidget(loadedArgument,
                          onChanged: (value) async {
                        setState(() {
                          function = function?.copyWith(
                            arguments: function?.arguments?.map((e) {
                              if (e.name == loadedArgument.name) {
                                return e.copyWith(value: value);
                              } else {
                                return e;
                              }
                            }).toList(),
                          );
                        });
                        await setData();
                      });
                      // return LiteralWidget(
                      //   argument,
                      //   onChanged: (value) {
                      //     // var itemIndex = viewModel.scenarioItems.indexOf(item);
                      //     // viewModel.updateScenarioItem(
                      //     //   itemIndex,
                      //     //   item.copyWith(
                      //     //     service: item.service!.copyWith(
                      //     //       arguments: item.service!.arguments!.map((e) {
                      //     //         if (e.name == argument.name) {
                      //     //           return e.copyWith(value: value);
                      //     //         } else {
                      //     //           return e;
                      //     //         }
                      //     //       }).toList(),
                      //     //     ),
                      //     //   ),
                      //     // );
                      //   },
                      // );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                  );
                }),
              ],
            ],
          ),
        ),
        _buildVariableList(context),
      ],
    );
  }

  Widget _buildDevice(Thing device) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          _buildIcon(device.category),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              device.name,
              style: AppTextStyles.size13Medium.singleLine,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String? category) {
    var defaultWidget = Container(
      width: 19,
      height: 19,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.68, 0.74),
          end: Alignment(0.68, -0.74),
          colors: [Color(0xFF8198F5), Color(0xFF83CDF6)],
        ),
        shape: OvalBorder(),
      ),
    );

    if (category == null) return defaultWidget;

    return CachedNetworkImage(
      imageUrl: IconHelper.getServiceIcon(category),
      height: 19,
      fit: BoxFit.fitHeight,
      errorWidget: (context, url, error) => defaultWidget,
      placeholder: (context, url) => defaultWidget,
    );
  }

  Widget _buildVariableList(BuildContext context) {
    return const SizedBox.shrink();

    /*var containAddScenario = Provider.of<AddScenarioViewModel?>(context);
    if (containAddScenario == null) {
      return const SizedBox.shrink();
    }
    var viewModel = context.watch<AddScenarioViewModel>();
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
              await setData();
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
                      setData();
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
    );*/
  }

  Future setData() async {
    var changedBlock = function!.toBlock(
        isAll: isAllDeviceSelected,
        selectedTags: selectedTags,
        variableName: _variableController.text);
    print(changedBlock.arguments.map((e) => e.value).toList());
    widget.onChanged?.call(changedBlock);
  }
}
