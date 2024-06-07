import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/argument_widget.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/scenario_code_parser/variable.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/icon_helper.dart';
import 'package:mysmax_playground/models/function_argument.dart';
import 'package:mysmax_playground/models/tag.dart';
import 'package:mysmax_playground/models/thing.dart';
import 'package:mysmax_playground/models/thing_function.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_variable_list_widget.dart';
import 'package:mysmax_playground/widgets/custom_drop_down.dart';
import 'package:mysmax_playground/widgets/radio_text_button.dart';
import 'package:provider/provider.dart';

enum _DirectionAddingNewBlockSet {
  up('위로 실행 추가'),
  down('아래로 실행 추가');

  final String title;
  const _DirectionAddingNewBlockSet(this.title);
}

class ScenarioCreatorServicesCardView extends StatefulWidget {
  /// tags : 디바이스에 해당하는 태그...이긴 한데 장소에 해당될수도 있다.
  /// arguments : 함수 파라미터.
  /// functionServiceReturnType : 함수 반환 타입인데 UNDEFINED로 많이 나온다?
  /// rangeType : tags가 여러개일 때 사용. 전체라던가 하나 이상 등등?
  /// serviceName : 서비스 이름(함수명)
  /// variableName : 대입에 쓸 변수명.

  /// [item]의 모든 blocks에 해당하는 초기 태그. 없을 수도 있다.
  final void Function(FunctionServiceListBlock) onUpdateBlock;

  /// 내가 등록한 모든 태그([Tag]) 리스트(TODO: 아마 장소태그인듯?)
  final List<Tag> tagList;

  /// 선택한 태그에 해당하는 기능([ThingFunction]) 목록을 찾는 함수
  final List<ThingFunction> Function(Tag tag) getThingFunctionListByTag;

  /// 선택한 기능([ThingFunction])에 해당하는 모든 디바이스([Thing])? 태그([Tag])? 목록을 찾는 함수(TODO: 이거 정확한 확인이 필요함. 현재는 디바이스 목록으로 구현해둠)
  final List<Thing> Function(String serviceName) getAllThingsByThingFunction;

  /// 현재 시나리오에 있는 모든 변수명
  final List<Variable> variableList;

  /// 서비스명을 가지고 새로운 변수를 추가하는 함수
  final String Function(String serviceName) generateNewVariable;

  /// 임시 : ServicesBlock -> ThingFunction 변환 용도
  final ThingFunction? Function(String name) serviceFunctionByName;

  const ScenarioCreatorServicesCardView({
    super.key,
    required this.onUpdateBlock,
    required this.tagList,
    required this.getThingFunctionListByTag,
    required this.getAllThingsByThingFunction,
    required this.variableList,
    required this.generateNewVariable,
    required this.serviceFunctionByName,
  });

  @override
  State<StatefulWidget> createState() =>
      _ScenarioCreatorServicesCardViewState();
}

class _ScenarioCreatorServicesCardViewState
    extends State<ScenarioCreatorServicesCardView> {
  bool _isExpanded = true;

  /// 중요) 현재 시나리오 상태를 표현할 UI용 객체
  ///      나중에 시나리오 블록으로 변환하기 위한 용도이다.
  final List<ThingFunction> _currentFunctions = [];

  /// _currentFunctions의 각 ThingFunction에 적용할 RangeType
  final List<RangeType> _rangeTypesForCurrentFunctions = [];

  /// _currentFunctions의 각 ThingFunction에 적용할 Device Tags
  final List<List<String>> _deviceTagsForCurrentFunctions = [];

  /// _currentFunctions의 각 ThingFunction에 적용할 variableName 저장하는 객체들
  final List<String?> _variableNameList = [];

  /// 현재 선택된 태그 UI
  int? _selectedTagIndex;
  String? get _selectedTagName => _selectedTagIndex != null
      ? widget.tagList[_selectedTagIndex!].name
      : null;

  /// 선택된 태그에 맞춰 보여줄 Thing List
  List<ThingFunction> _thingFunctionListForTag = [];

  /// 위 _thingFunctionListForTag 중 현재 선택된 ThingFunction의 인덱스
  int? _selectedThingFunctionIndex;

  /// arguments 관련 부분
  bool _argumentsSettingExpansionTileOpened = false;
  // final List<List<bool>> _argumentIsSetList = [];
  // final List<List<TextEditingController>> _argumentNameList = [];

  /// 값을 저장할 변수명 관련 부분
  List<String> _variableList = [];
  bool _variableSettingExpansionTileOpened = false;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
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
          initiallyExpanded: true,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(25, 0, 17, 0),
          onExpansionChanged: (isExpanded) {
            setState(() {
              _isExpanded = isExpanded;
            });
          },
          title: Padding(
            padding: _isExpanded == false
                ? const EdgeInsets.only(top: 16)
                : EdgeInsets.zero,
            child: Text(
              '어떤 내용으로 기능을 실행할까요?',
              style: AppTextStyles.size16Bold.singleLine,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: _isExpanded == false
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 3),
                          Text(
                            '내가 등록한 태그로 기능을 실행합니다. ',
                            style:
                                AppTextStyles.size11Medium.singleLine.copyWith(
                              color: const Color(0xFF8D929A),
                              height: 15 / 11,
                              letterSpacing: -0.22,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedTagName != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 36),
                          child: _textTagButton(
                            isFixedSize: false,
                            tag: _selectedTagName!,
                            isSelected: true,
                            onClick: () {},
                          ),
                        ),
                        const SizedBox(height: 34),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 7),
                            Text.rich(
                              TextSpan(
                                text: _selectedTagName!,
                                style: AppTextStyles.size16Bold.singleLine
                                    .copyWith(
                                  color: const Color(0xFF5D7CFF),
                                ),
                                children: [
                                  TextSpan(
                                    text: '의 어떤 기능을 실행할까요?',
                                    style: AppTextStyles.size16Bold.singleLine,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 23),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _thingFunctionListForTag.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 16,
                              childAspectRatio: 123 / 35,
                            ),
                            itemBuilder: (context, index) => _functionButton(
                              icon: IconHelper.getServiceIcon(
                                  _thingFunctionListForTag[index].category),
                              name: _thingFunctionListForTag[index].name,
                              isSelected: _isThingFunctionSelected(
                                  _thingFunctionListForTag[index].name),
                              onClick: () {},
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<_DirectionAddingNewBlockSet>(
                color: const Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
                onSelected: (direction) {},
                itemBuilder: (_) => [
                  for (final direction in _DirectionAddingNewBlockSet.values)
                    PopupMenuItem(
                      child: Text(
                        direction.title,
                        style: AppTextStyles.size13Medium,
                      ),
                    ),
                ],
                icon: SvgPicture.asset(
                  'assets/icons/scenario_editor_add_blockset.svg',
                ),
                iconSize: 22,
              ),
              const SizedBox(width: 4),
              SvgPicture.asset(
                _isExpanded
                    ? 'assets/icons/expansion_up.svg'
                    : 'assets/icons/expansion_down.svg',
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(22, 0, 22, 23),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 3),
                Text(
                  '내가 등록한 태그로 기능을 실행합니다. ',
                  style: AppTextStyles.size11Medium.singleLine.copyWith(
                    color: const Color(0xFF8D929A),
                    height: 15 / 11,
                    letterSpacing: -0.22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  widget.tagList.length,
                  (index) => _textTagButton(
                    isFixedSize: false,
                    tag: widget.tagList[index].name,
                    isSelected: _selectedTagIndex == index,
                    onClick: () {
                      if (_selectedTagIndex != index) {
                        setState(() {
                          _selectedTagIndex = index;
                          _thingFunctionListForTag = widget
                              .getThingFunctionListByTag(widget.tagList[index]);
                          _selectedThingFunctionIndex = null;

                          /// 현재까지 선택된 ThingFunction 목록 초기화하고 시나리오에 반영.
                          _currentFunctions.clear();
                          _rangeTypesForCurrentFunctions.clear();
                          _deviceTagsForCurrentFunctions.clear();
                          _variableNameList.clear();
                          setData();
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            if (_selectedTagName != null) ...[
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 7),
                  Text.rich(
                    TextSpan(
                      text: _selectedTagName!,
                      style: AppTextStyles.size16Bold.singleLine.copyWith(
                        color: const Color(0xFF5D7CFF),
                      ),
                      children: [
                        TextSpan(
                          text: '의 어떤 기능을 실행할까요?',
                          style: AppTextStyles.size16Bold.singleLine,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _thingFunctionListForTag.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 16,
                    childAspectRatio: 123 / 35,
                  ),
                  itemBuilder: (context, index) {
                    return _functionButton(
                      icon: IconHelper.getServiceIcon(
                          _thingFunctionListForTag[index].category),
                      name: _thingFunctionListForTag[index].name,
                      isSelected: _isThingFunctionSelected(
                          _thingFunctionListForTag[index].name),
                      onClick: () {
                        setState(() {
                          final blockIndex =
                              _getSelectedThingFunctionIndexByName(
                                  _thingFunctionListForTag[index].name);

                          /// 선택된 서비스인 경우: _currentBlocks에서 해당 서비스 제거
                          if (blockIndex != null) {
                            _currentFunctions.removeAt(blockIndex);
                            _rangeTypesForCurrentFunctions.removeAt(blockIndex);
                            _deviceTagsForCurrentFunctions.removeAt(blockIndex);
                            _variableNameList.removeAt(blockIndex);

                            // 만약 서비스 선택 Dropdown이 삭제하고자 하는 서비스를 가리키고 있다면 : 맨 첫번째 서비스를 가리키도록 변경.
                            // 단, 아예 리스트가 빈 경우 null로 변경
                            if (_selectedThingFunctionIndex == blockIndex) {
                              _selectedThingFunctionIndex =
                                  _currentFunctions.isEmpty ? null : 0;
                            } else if (_selectedThingFunctionIndex != null &&
                                _selectedThingFunctionIndex! >=
                                    _currentFunctions.length) {
                              _selectedThingFunctionIndex =
                                  _currentFunctions.isEmpty ? null : 0;
                            }
                          }

                          /// 선택되지 않은 서비스인 경우 : _currentBlocks에 해당 서비스 추가
                          else {
                            _currentFunctions
                                .add(_thingFunctionListForTag[index]);
                            _rangeTypesForCurrentFunctions.add(RangeType.AUTO);
                            _deviceTagsForCurrentFunctions.add([]);
                            _variableNameList.add(null);

                            // 서비스 선택 Dropdown이 방금 추가한 서비스를 가리키도록 한다.
                            _selectedThingFunctionIndex =
                                _currentFunctions.length - 1;
                          }

                          setData();
                        });

                        /*setState(() {
                      _serviceSelectedList[index] = !_serviceSelectedList[index];

                      if(_serviceSelectedList[index]) {
                        _selectedServiceRangeMap[serviceList[index].$1.name] = RangeType.AUTO;
                      } else {
                        _selectedServiceRangeMap.remove(serviceList[index].$1.name);
                      }

                      if(_selectedServiceNames.isEmpty) {
                        _currentSelectedService = null;
                      } else if(_selectedServiceNames.contains(_currentSelectedService) == false) {
                        _currentSelectedService = _selectedServiceNames[0];
                      }
                    });

                    if(_serviceSelectedList[index] && widget.onChanged != null) {
                      widget.onChanged!(
                          widget.item!.copyWith(
                            FunctionServiceBlock(
                              serviceList[index].$1.name,
                              widget.item!.tags,
                              widget.item!.functionServiceReturnType,
                              widget.item!.arguments,
                              widget.item!.variableName,
                              widget.item!.rangeType,
                              blocks: widget.item!.blocks,
                            ),
                          )
                      );

                    }
                    */
                      },
                    );
                  },
                ),
              ),
              if (_selectedThingFunctionIndex != null) ...[
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 6),
                    Text(
                      '어떤 디바이스로 실행할까요?',
                      style: AppTextStyles.size16Bold.singleLine,
                    )
                  ],
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    CustomDropDown(
                      disabledHint: '기능을 선택해주세요.',
                      fixWidth: false,
                      selectedValue: _selectedThingFunctionName!,
                      onChanged: (selectedServiceName) {
                        setState(() {
                          if (selectedServiceName != null) {
                            _selectedThingFunctionIndex =
                                _getSelectedThingFunctionIndexByName(
                                    selectedServiceName);
                          }
                        });
                      },
                      items: _currentFunctions
                          .map((function) => function.name)
                          .toList(),
                    ),
                    const SizedBox(width: 16),
                    RadioTextButton<RangeType>(
                      value: RangeType.ALL,
                      groupValue: _rangeTypesForCurrentFunctions[
                          _selectedThingFunctionIndex!],
                      onChanged: _setNewRangeTypeForCurrentFunction,
                      title: '모두 선택',
                    ),
                    const SizedBox(width: 16),
                    RadioTextButton<RangeType>(
                      value: RangeType.AUTO,
                      groupValue: _rangeTypesForCurrentFunctions[
                          _selectedThingFunctionIndex!],
                      onChanged: _setNewRangeTypeForCurrentFunction,
                      title: '자동 선택',
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                if (_currentFunctions[_selectedThingFunctionIndex!].tags !=
                    null)
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        _currentFunctions[_selectedThingFunctionIndex!]
                            .tags!
                            .length,
                        (index) => _textTagButton(
                          isFixedSize: false,
                          tag: _currentFunctions[_selectedThingFunctionIndex!]
                              .tags![index]
                              .name,
                          isSelected: _deviceTagsForCurrentFunctions[
                                  _selectedThingFunctionIndex!]
                              .contains(_currentFunctions[
                                      _selectedThingFunctionIndex!]
                                  .tags![index]
                                  .name),
                          onClick: () {
                            _toggleTagSelectionForCurrentFunction(
                                _currentFunctions[_selectedThingFunctionIndex!]
                                    .tags![index]
                                    .name);
                          },
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 21),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedDevicesForTags.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          IconHelper.getDeviceIcon(
                              _selectedDevicesForTags[index].category ??
                                  'undefined'),
                          errorBuilder: IconHelper.iconErrorWidgetBuilder(height: 29),
                          height: 29,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            _selectedDevicesForTags[index].name,
                            style: AppTextStyles.size16Medium.singleLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFF0F2F9)),
                ),

                /// 세부 옵션 설정
                if (_selectedThingFunctionIndex != null &&
                    (_currentFunctions[_selectedThingFunctionIndex!]
                            .arguments
                            ?.isNotEmpty ??
                        false))
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: _argumentsSettingExpansionTile(
                        _selectedThingFunctionIndex!),
                  ),

                /// 값 저장
                if (_selectedThingFunctionIndex != null &&
                    (_currentFunctions[_selectedThingFunctionIndex!]
                                .return_type
                                .toFunctionServiceReturnType !=
                            FunctionServiceReturnType.VOID &&
                        _currentFunctions[_selectedThingFunctionIndex!]
                                .return_type
                                .toFunctionServiceReturnType !=
                            FunctionServiceReturnType.UNDEFINED))
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: _variableSettingExpansionTile(
                        _selectedThingFunctionIndex!),
                  ),
              ]
            ],
          ],
        ),
      ),
    );
  }

  Widget _argumentsSettingExpansionTile(int serviceIndex) {
    return Builder(
      builder: (context) {
        var orderedArguments = List<FunctionArgument>.from(
            _currentFunctions[serviceIndex].arguments ?? []);
        orderedArguments.sort((a, b) => a.order.compareTo(b.order));

        return ExpansionTile(
          initiallyExpanded: true,
          shape: const Border(),
          tilePadding: EdgeInsets.zero,
          onExpansionChanged: (isExpanded) {
            setState(() {
              _argumentsSettingExpansionTileOpened = isExpanded;
            });
          },
          title: Text(
            '세부 옵션을 설정할까요?',
            style: AppTextStyles.size16Bold.singleLine,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: SvgPicture.asset(
            _argumentsSettingExpansionTileOpened
                ? 'assets/icons/expansion_up.svg'
                : 'assets/icons/expansion_down.svg',
          ),
          children: List.generate(orderedArguments.length, (index) {
            return ArgumentWidget(
              orderedArguments[index],
              editMode: true,
              onChanged: (value) async {
                setState(() {
                  final newFunction = _currentFunctions[serviceIndex].copyWith(
                    arguments:
                        _currentFunctions[serviceIndex].arguments?.map((e) {
                      if (e.name == orderedArguments[index].name) {
                        return e.copyWith(value: value);
                      } else {
                        return e;
                      }
                    }).toList(),
                  );

                  final newList = <ThingFunction>[];
                  for (var i = 0; i < _currentFunctions.length; i++) {
                    if (i == serviceIndex) {
                      newList.add(newFunction);
                    } else {
                      newList.add(_currentFunctions[i]);
                    }
                  }

                  _currentFunctions.clear();
                  _currentFunctions.addAll(newList);
                });
                await setData();
              },
            );
            /*var argument = widget.item.arguments[index];
          var loadedArgument = orderedArguments[index].copyWith(
            value: argument.value,
          );
          return ArgumentWidget(
            loadedArgument,
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
            },
          );*/

            /*return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                CheckToggle(
                  toggled: _argumentIsSetList[serviceIndex][index],
                  onCheck: (newValue) {
                    setState(() {
                      _argumentIsSetList[serviceIndex][index] = newValue;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _argumentNameList[serviceIndex][index],
                    // focusNode: searchFocusNode,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    // onFieldSubmitted: onSearch,
                    style: AppTextStyles.size12Regular.copyWith(
                      height: 22 / 12,
                      letterSpacing: -0.36,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 8,
                      ),
                      hintText: '값이나 변수명을 입력하세요',
                      hintStyle: AppTextStyles.size12Regular.copyWith(
                        color: const Color(0xFFADB3C6),
                        height: 22 / 12,
                        letterSpacing: -0.36,
                      ),
                      fillColor: const Color(0xFFFFFFFF),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Color(0xFFE9ECF5)),
                      ),
                      */ /*
                  suffixIconConstraints: const BoxConstraints(minHeight: 38, maxHeight: 38),
                  suffixIcon: GestureDetector(
                    onTap: () => onSearch(searchController.text),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
                      child: SvgPicture.asset(
                        'assets/icons/scenario_editor_search.svg',
                        height: 13,
                      ),
                    ),
                  ),
                  */ /*
                    ),
                  ),
                ),
              ],
            ),
          );*/
          }),
        );
      },
    );
  }

  Widget _variableSettingExpansionTile(int index) {
    return ExpansionTile(
      initiallyExpanded: false,
      shape: const Border(),
      tilePadding: EdgeInsets.zero,
      onExpansionChanged: (isOpened) {
        setState(() {
          _variableSettingExpansionTileOpened = isOpened;
        });
      },
      title: Text(
        '실행 결과를 저장할까요?',
        style: AppTextStyles.size16Bold.singleLine,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SvgPicture.asset(
        _variableSettingExpansionTileOpened
            ? 'assets/icons/expansion_up.svg'
            : 'assets/icons/expansion_down.svg',
      ),
      children: [
        EditorVariableListWidget(
          editMode: true,
          isVariableForLeftSide: true,
          variableList: _variableList,
          initialSelectedVariable: _variableNameList[index],
          addNewVariable: () {
            final newVariable =
                widget.generateNewVariable(_selectedThingFunctionName!);
            setState(() {
              _variableList.add(newVariable);
              _variableNameList[index] = newVariable;
            });
            setData();
          },
        ),
        /*Row(
          children: [
            CheckToggle(
              toggled: _variableIsSetList[index],
              onCheck: (newValue) {
                setState(() {
                  _variableIsSetList[index] = newValue;
                  setData();
                });
              },
            ),
            const SizedBox(width: 8),
            const Text(
              '실행 결과를 저장합니다.',
              style: AppTextStyles.size14Medium,
            ),
          ],
        ),

        const SizedBox(height: 12),
        TextFormField(
          enabled: _variableIsSetList[index],
          controller: _variableNameList[index],
          // focusNode: searchFocusNode,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          // onFieldSubmitted: onSearch,
          onChanged: (_) {
            setData();
          },
          style: AppTextStyles.size12Regular.copyWith(
            height: 22 / 12,
            letterSpacing: -0.36,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 8,
            ),
            hintText: '결과를 저장할 변수명을 입력해주세요.',
            hintStyle: AppTextStyles.size12Regular.copyWith(
              color: const Color(0xFFADB3C6),
              height: 22 / 12,
              letterSpacing: -0.36,
            ),
            fillColor: const Color(0xFFFFFFFF),
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFFE9ECF5)),
            ),
          ),
        ),*/
      ],
    );
  }

  Widget _textTagButton({
    required String tag,
    required bool isSelected,
    required VoidCallback onClick,
    bool isFixedSize = true,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: isFixedSize
            ? null
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        width: isFixedSize ? 61 : null,
        height: isFixedSize ? 35 : null,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D7CFF) : const Color(0xFFFFFFFF),
          border: Border.all(
            width: 1,
            color: const Color(0xFFE9ECF5),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: isFixedSize ? Alignment.center : null,
        child: Text(
          tag,
          style: AppTextStyles.size14Medium.copyWith(
            color:
                isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF8F94A4),
          ),
        ),
      ),
    );
  }

  Widget _functionButton({
    required String icon,
    required String name,
    required bool isSelected,
    required VoidCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 123,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D7CFF) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF46517D).withAlpha(6),
              blurRadius: 8,
            )
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              height: 15,
              errorBuilder: IconHelper.iconErrorWidgetBuilder(height: 15),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.size11Bold.singleLine.copyWith(
                  color: isSelected
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF3F424B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 9),
            if (isSelected)
              SvgPicture.asset(
                'assets/icons/tmp_check_white.svg',
                width: 16,
                height: 16,
              )
            else
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(width: 1, color: const Color(0xFFDAE2EC)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 아래는 전부 UI를 그리는 데 사용되는 함수들이다.
  int? _getSelectedThingFunctionIndexByName(String thingFunctionName) {
    final index = _currentFunctions
        .indexWhere((thingFunction) => thingFunction.name == thingFunctionName);
    return index == -1 ? null : index;
  }

  bool _isThingFunctionSelected(String serviceName) =>
      _getSelectedThingFunctionIndexByName(serviceName) != null;

  String? get _selectedThingFunctionName {
    if (_selectedThingFunctionIndex != null) {
      return _currentFunctions[_selectedThingFunctionIndex!].name;
    }

    return null;
  }

  void _setNewRangeTypeForCurrentFunction(RangeType newRangeType) {
    setState(() {
      if (_selectedThingFunctionIndex != null) {
        _rangeTypesForCurrentFunctions[_selectedThingFunctionIndex!] =
            newRangeType;
        setData();
      }
    });
  }

  void _toggleTagSelectionForCurrentFunction(String tagName) {
    if (_selectedThingFunctionIndex == null) {
      return;
    }

    setState(() {
      if (_deviceTagsForCurrentFunctions[_selectedThingFunctionIndex!]
          .contains(tagName)) {
        _deviceTagsForCurrentFunctions[_selectedThingFunctionIndex!]
            .remove(tagName);
      } else {
        _deviceTagsForCurrentFunctions[_selectedThingFunctionIndex!]
            .add(tagName);
      }

      setData();
    });
  }

  /// TODO: 맞게 동작하는건지 체크 필요.
  List<Thing> get _selectedDevicesForTags {
    if (_selectedThingFunctionIndex == null) {
      return [];
    }

    final mqttViewModel = context.watch<MqttViewModel>();

    return mqttViewModel.thingList.where((thing) {
      if (_deviceTagsForCurrentFunctions[_selectedThingFunctionIndex!]
          .isEmpty) {
        return false;
      }
      return thing.functions.any((function) {
        return _deviceTagsForCurrentFunctions[_selectedThingFunctionIndex!].any(
          (tag) =>
              (function.tags?.map((e) => e.name).contains(tag) ?? false) &&
              tag == _currentFunctions[_selectedThingFunctionIndex!].name,
        );
      });
    }).toList();
  }

  Future setData() async {
    final changedChildren = <FunctionServiceBlock>[];

    for (var i = 0; i < _currentFunctions.length; i++) {
      changedChildren.add(
        _currentFunctions[i].toBlockV2(
          rangeType: _rangeTypesForCurrentFunctions[i],
          selectedDeviceTags: _deviceTagsForCurrentFunctions[i],
          variableName: _variableNameList[i],
        ),
      );
    }

    widget.onUpdateBlock(FunctionServiceListBlock(changedChildren));
  }
}
