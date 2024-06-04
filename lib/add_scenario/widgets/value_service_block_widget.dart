import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/icon_helper.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/widgets/tag_list_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/scenario_code_parser/expression.dart';
import '../../../models/thing.dart';

class ValueServiceBlockWidget extends StatefulWidget {
  final ValueServiceExpression item;
  final Function(ValueServiceBlock block) onBlockChanged;

  const ValueServiceBlockWidget(
    this.item, {
    required this.onBlockChanged,
    super.key,
  });

  @override
  State<ValueServiceBlockWidget> createState() =>
      _ValueServiceBlockWidgetState();
}

class _ValueServiceBlockWidgetState extends State<ValueServiceBlockWidget> {
  bool _isAll = true;
  List<String> _selectedTag = [];

  bool isEditTagMode = false;

  TextEditingController _tagController = TextEditingController();
  FocusNode _tagFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var mqttViewModel = context.watch<MqttViewModel>();
    var tagList = mqttViewModel.getTagListByValueName(widget.item.serviceName);
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFE2E5ED)),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(16, 0, 11, 0),
          /*tilePadding: const EdgeInsets.symmetric(
            horizontal: 19,
            vertical: 15,
          ).copyWith(right: 12),*/
          title: Row(
            children: [
              _buildIcon(widget.item.serviceName),
              const SizedBox(width: 10),
              Text(
                widget.item.serviceName,
                style: AppTextStyles.size12Bold.singleLine,
              ),
            ],
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
                    totalTags: tagList,
                    initialSelectedTags: widget.item.tags.map((e) {
                      return Tag(name: e);
                    }).toList(),
                    onAddTagChanged: (tag) {
                      var mqttViewModel = context.read<MqttViewModel>();
                      var thingList = mqttViewModel
                          .thingListByValueName(widget.item.serviceName);
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
                      Future.delayed(const Duration(seconds: 1)).then((value) {
                        mqttViewModel.getThingList();
                        mqttViewModel.getServiceList();
                      });
                      setData();
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
                        _selectedTag = selectedTags.map((e) => e.name).toList();
                      });
                      setData();
                    },
                  ),
                  // Row(
                  //   children: [
                  //     // GestureDetector(
                  //     //   child: SvgPicture.asset(
                  //     //     'assets/icons/icon_add.svg',
                  //     //     width: 25,
                  //     //     height: 25,
                  //     //   ),
                  //     // ),
                  //     ...(service?.tags ?? []).map((e) {
                  //       var isSelected = _selectedTag.contains(e.name);
                  //       return GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             if (_selectedTag.contains(e.name)) {
                  //               _selectedTag.remove(e.name);
                  //             } else {
                  //               _selectedTag.add(e.name);
                  //             }
                  //           });
                  //           _onBlockChanged();
                  //         },
                  //         child: Container(
                  //           margin: const EdgeInsets.only(right: 4),
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 9, vertical: 5),
                  //           decoration: ShapeDecoration(
                  //             color: Color(0xFFF0F2F9),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(14),
                  //               side: BorderSide(
                  //                 color: isSelected
                  //                     ? AppColors.blue
                  //                     : Colors.transparent,
                  //               ),
                  //             ),
                  //           ),
                  //           child: Text(
                  //             e.name,
                  //             style:
                  //                 AppTextStyles.size11Medium.singleLine.copyWith(
                  //               color: isSelected
                  //                   ? AppColors.blue
                  //                   : const Color(0xff3F424B),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     })
                  //   ],
                  // )
                ],
              ),
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
                  const SizedBox(height: 12),
                  Selector<MqttViewModel, List<Thing>>(
                      selector: (context, mqttViewModel) => mqttViewModel
                          .thingListByValueName(widget.item.serviceName),
                      builder: (context, things, child) {
                        return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: things.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                _buildDeviceIcon(things[index].category),
                                const SizedBox(width: 4),
                                Text(things[index].name,
                                    style:
                                        AppTextStyles.size13Medium.singleLine),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 8);
                          },
                        );
                      }),
                  // TODO: 조건(Bound) 추가
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("조건",
                          style: AppTextStyles.size11Medium.singleLine.copyWith(
                            color: const Color(0xff8F94A4),
                          )),
                      Spacer(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAll = true;
                          });
                          _onBlockChanged();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 5),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(41),
                              side: BorderSide(
                                color: _isAll
                                    ? const Color(0xff5D7CFF)
                                    : const Color(0xffE9ECF5),
                              ),
                            ),
                          ),
                          // 자동 선택: (#거실 #1층).불켜기();
                          // 모두 선택 (Function): all(#1층).불켜기();
                          // 모두 선택 (Value): if ( any(#1층).온도 == 1 );
                          child: Text(
                            '모두 선택',
                            style:
                                AppTextStyles.size12Medium.singleLine.copyWith(
                              color: _isAll
                                  ? const Color(0xff5D7CFF)
                                  : const Color(0xff8F94A4),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAll = false;
                          });
                          _onBlockChanged();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 5),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: !_isAll
                                    ? const Color(0xff5D7CFF)
                                    : const Color(0xffE9ECF5),
                              ),
                            ),
                          ),
                          child: Text(
                            '자동 선택',
                            style:
                                AppTextStyles.size11Medium.singleLine.copyWith(
                              color: !_isAll
                                  ? const Color(0xff5D7CFF)
                                  : const Color(0xff8F94A4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future setData() async {
    var changedBlock = widget.item.copyWith(
        tags: _selectedTag, rangeType: _isAll ? RangeType.ANY : RangeType.AUTO);
    widget.onBlockChanged.call(ValueServiceBlock(changedBlock, ''));
  }

  Widget _buildIcon(String valueName) {
    var service =
        context.read<MqttViewModel>().getValueInfoByValueName(valueName);
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

    return CachedNetworkImage(
      imageUrl: IconHelper.getServiceIcon(service?.category ?? ''),
      height: 19,
      fit: BoxFit.fitHeight,
      placeholder: (context, url) => defaultWidget,
      errorWidget: (context, url, error) => defaultWidget,
    );
  }

  Widget _buildDeviceIcon(String? thingCategory) {
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

    return CachedNetworkImage(
      imageUrl: IconHelper.getDeviceIcon(thingCategory ?? ''),
      height: 19,
      fit: BoxFit.fitHeight,
      placeholder: (context, url) => defaultWidget,
      errorWidget: (context, url, error) => defaultWidget,
    );
  }

  void _onBlockChanged() {
    var block = ValueServiceBlock(
      ValueServiceExpression(
        widget.item.serviceName,
        _selectedTag,
        _isAll ? RangeType.ANY : RangeType.AUTO,
      ),
      '',
    );
    widget.onBlockChanged(block);
  }
}
