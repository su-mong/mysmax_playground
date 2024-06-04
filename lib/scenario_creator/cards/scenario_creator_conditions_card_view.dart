import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mysmax_playground/add_scenario/widgets/literal_block_widget.dart';
import 'package:mysmax_playground/add_scenario/widgets/value_service_block_widget.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';
import 'package:mysmax_playground/core/scenario_code_parser/variable.dart';
import 'package:mysmax_playground/core/viewmodels/mqtt_view_model.dart';
import 'package:mysmax_playground/helper/date_time_helper.dart';
import 'package:mysmax_playground/helper/icon_helper.dart';
import 'package:mysmax_playground/models/condition_item.dart';
import 'package:mysmax_playground/models/enums/weather_state.dart';
import 'package:mysmax_playground/models/thing_value.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_date_button.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_number_text_field.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_select_time_widget.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_variable_list_widget.dart';
import 'package:mysmax_playground/widgets/custom_drop_down.dart';
import 'package:mysmax_playground/widgets/radio_text_button.dart';
import 'package:provider/provider.dart';

const double _listHeight = 280;
const String _weatherServiceName = 'weather';
const String _dateTimeServiceName = 'timestamp';

class ScenarioCreatorConditionsCardView extends StatefulWidget {
  final Function(IfBlock) onUpdateIfBlock;
  final Function(WaitUntilBlock) onUpdateWaitUntilBlock;
  final Function(ElseBlock?) onUpdateElseBlock;

  const ScenarioCreatorConditionsCardView({
    super.key,
    required this.onUpdateIfBlock,
    required this.onUpdateWaitUntilBlock,
    required this.onUpdateElseBlock,
  });

  @override
  State<StatefulWidget> createState() =>
      _ScenarioCreatorConditionsCardViewState();
}

class _ScenarioCreatorConditionsCardViewState
    extends State<ScenarioCreatorConditionsCardView> {
  static const List<Operator> _operatorList = [
    Operator.EQUAL,
    Operator.NOT_EQUAL,
    Operator.GREATER_THAN,
    Operator.LESS_THAN,
    Operator.GREATER_THAN_OR_EQUAL,
    Operator.LESS_THAN_OR_EQUAL
  ];

  bool _isExpanded = true;
  ConditionBlockState _state = ConditionBlockState.none;

  /// 중요) [IfBlock]에 쓰일 현재 시나리오 상태를 표현할 UI용 객체
  ///      나중에 시나리오 블록으로 변환하기 위한 용도이다.
  Operator? _logicalOperatorForIf;
  List<String> _thingValueTypesForIf = [];
  List<ConditionItem> _conditionsForIf = [
    ConditionItem(conditionType: Operator.EQUAL),
  ];

  /// 중요) [WaitUntilBlock]에 쓰일 현재 시나리오 상태를 표현할 UI용 객체
  ///      나중에 시나리오 블록으로 변환하기 위한 용도이다.
  bool _useConditionForUntil = true;

  /// TODO: 확인 필요. 이거 굳이 List여야 함?
  List<ConditionItem> _conditionsForUntil = [
    ConditionItem(
      conditionType: Operator.EQUAL,
    ),
  ];
  PeriodExpression _periodForUntil = PeriodExpression(
    PeriodType.HOUR,
    LiteralExpression(1, literalType: LiteralType.INTEGER),
  );

  /// 아래는 UI 및 검색 관련 기능들에 쓰일 객체
  /// For [IfBlock]
  bool _isExpandedSensorDeviceStatus = false;
  bool _isExpandedOperatorStatus = false;
  bool _isExpandedConstantStatus = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchTerm = '';

  final TextEditingController _constantSearchController =
      TextEditingController();
  final FocusNode _constantSearchFocusNode = FocusNode();
  String _constantSearchTerm = '';
  final TextEditingController _constantNumberController =
      TextEditingController();
  final TextEditingController _constantStringController =
      TextEditingController();
  final TextEditingController _constantHourController = TextEditingController();
  final TextEditingController _constantMinuteController =
      TextEditingController();

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  /// TODO| 'ELSE'구문 추가용
  bool _isSelectedElse = false;

  /// For [WaitUntilBlock]
  bool _isExpandedSensorDeviceStatusUntil = false;
  bool _isExpandedOperatorStatusUntil = false;
  bool _isExpandedConstantStatusUntil = false;

  final TextEditingController _searchControllerUntil = TextEditingController();
  final FocusNode _searchFocusNodeUntil = FocusNode();
  String _searchTermUntil = '';

  final TextEditingController _constantSearchControllerUntil =
      TextEditingController();
  final FocusNode _constantSearchFocusNodeUntil = FocusNode();
  String _constantSearchTermUntil = '';
  final TextEditingController _untilConstantNumberController =
      TextEditingController();
  final TextEditingController _untilConstantStringController =
      TextEditingController();
  final TextEditingController _untilConstantHourController =
      TextEditingController();
  final TextEditingController _untilConstantMinuteController =
      TextEditingController();

  final TextEditingController _periodNumberController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final mqttViewModel = context.watch<MqttViewModel>();

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
              '어떤 조건으로 실행할까요?',
              style: AppTextStyles.size16Bold.singleLine,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: _isExpanded == false
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24) +
                      const EdgeInsets.only(left: 2),
                  child: Builder(
                    builder: (_) {
                      switch (_state) {
                        case ConditionBlockState.none:
                          return const SizedBox.shrink();
                        case ConditionBlockState.ifElse:
                          return RichText(
                            text: TextSpan(
                              text: '만일',
                              style: AppTextStyles.size14Bold.copyWith(
                                color: const Color(0xFF5D7CFF),
                              ),
                              children: [
                                TextSpan(
                                  text: '\n\n${_conditionsForIf.map((condition) => '${(condition.firstValue is ValueServiceExpression) ? condition.firstValue.serviceName : condition.firstValue} '
                                      '${condition.conditionType?.value} '
                                      '${(condition.lastValue is ValueServiceExpression) ? condition.lastValue.serviceName : (condition.lastValue is LiteralExpression) ? condition.lastValue.value : condition.lastValue}').join('\n')}\n\n',
                                  style: AppTextStyles.size14Medium.copyWith(
                                    letterSpacing: -0.42,
                                  ),
                                ),
                                TextSpan(
                                  text: (_logicalOperatorForIf == Operator.AND)
                                      ? '을 모두 만족하면 기능을 실행합니다.'
                                      : (_logicalOperatorForIf == Operator.OR)
                                          ? '중 적어도 하나가 만족하면 기능을 실행합니다.'
                                          : '을 만족하면 기능을 실행합니다.',
                                  style: AppTextStyles.size14Bold.copyWith(
                                    color: const Color(0xFF5D7CFF),
                                  ),
                                ),
                              ],
                            ),
                          );
                        case ConditionBlockState.waitUntil:
                          return RichText(
                            text: TextSpan(
                              text: '다음 조건',
                              style: AppTextStyles.size14Bold
                                  .copyWith(color: const Color(0xFF5D7CFF)),
                              children: [
                                TextSpan(
                                  text: _useConditionForUntil
                                      ? '\n\n'
                                          '${(_conditionsForUntil[0].firstValue is ValueServiceExpression) ? _conditionsForUntil[0].firstValue.serviceName : _conditionsForUntil[0].firstValue} '
                                          '${_conditionsForUntil[0].conditionType?.value} '
                                          '${(_conditionsForUntil[0].lastValue is ValueServiceExpression) ? _conditionsForUntil[0].lastValue.serviceName : (_conditionsForUntil[0].lastValue is LiteralExpression) ? _conditionsForUntil[0].lastValue.value : _conditionsForUntil[0].lastValue}'
                                          '\n\n'
                                      : '\n\n'
                                          '${_periodForUntil.period.valueString}${_periodForUntil.periodType.toName}'
                                          '\n\n',
                                  style: AppTextStyles.size14Medium.copyWith(
                                    letterSpacing: -0.42,
                                  ),
                                ),
                                TextSpan(
                                  text: _useConditionForUntil
                                      ? '을 만족할 때까지 기다렸다가\n조건을 만족하면 기능을 실행합니다.'
                                      : '만큼 기다렸다가\n조건을 만족하면 기능을 실행합니다.',
                                ),
                              ],
                            ),
                          );
                      }
                    },
                  ),
                )
              : const SizedBox.shrink(),
          trailing: SvgPicture.asset(
            _isExpanded
                ? 'assets/icons/expansion_up.svg'
                : 'assets/icons/expansion_down.svg',
          ),
          childrenPadding: const EdgeInsets.fromLTRB(22, 0, 22, 23),
          children: [
            if (_state == ConditionBlockState.none)
              _FirstPage(
                gotoIfElse: () {
                  setState(() {
                    _state = ConditionBlockState.ifElse;
                  });
                },
                gotoUntil: () {
                  setState(() {
                    _state = ConditionBlockState.waitUntil;
                  });
                },
              )
            else if (_state == ConditionBlockState.ifElse)
              _IfElsePage(
                _conditionsForIf,
                thingValueTypes: _thingValueTypesForIf,
                addThingValueType: (type) {
                  _thingValueTypesForIf.add(type);
                },
                setNewFirstValue: (int index, dynamic newFirstValue,
                    RangeType? firstRangeType) {
                  setState(() {
                    _conditionsForIf[index].firstValue = newFirstValue;
                    _conditionsForIf[index].firstValueRangeType =
                        firstRangeType;
                  });
                  setData();
                },
                setNewOperator: (int index, Operator operator) {
                  setState(() {
                    _conditionsForIf[index].conditionType = operator;
                  });
                  setData();
                },
                setNewLastValue: (int index, dynamic newLastValue,
                    RangeType? lastRangeType) {
                  setState(() {
                    _conditionsForIf[index].lastValue = newLastValue;
                    _conditionsForIf[index].lastValueRangeType = lastRangeType;
                  });
                  setData();
                },
                isExpandedSensorDeviceStatus: _isExpandedSensorDeviceStatus,
                onSensorDeviceStatusExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpandedSensorDeviceStatus = isExpanded;
                  });
                  setData();
                },
                logicalOperator: _logicalOperatorForIf,
                onChangedLogicalOperator: (operator) {
                  setState(() {
                    _logicalOperatorForIf = operator;
                  });
                  setData();
                },
                addCondition: () {
                  setState(() {
                    _logicalOperatorForIf ??= Operator.AND;
                    _conditionsForIf.add(
                      ConditionItem(conditionType: Operator.EQUAL),
                    );
                  });
                  setData();
                },
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                onSearch: (newStatus) {
                  setState(() {
                    _searchTerm = newStatus;
                  });
                  setData();
                },
                statusThingValueList: _searchTerm.isEmpty
                    ? mqttViewModel.serviceValueList
                    : mqttViewModel.serviceValueList
                        .where((e) => e.name.contains(_searchTerm))
                        .toList(),
                isExpandedOperatorStatus: _isExpandedOperatorStatus,
                onOperatorStatusExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpandedOperatorStatus = isExpanded;
                  });
                  setData();
                },
                otherOperatorList: _operatorList,
                isExpandedConstantStatus: _isExpandedConstantStatus,
                onConstantStatusExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpandedConstantStatus = isExpanded;
                  });
                  setData();
                },
                constantSearchController: _constantSearchController,
                constantSearchFocusNode: _constantSearchFocusNode,
                onConstantSearch: (searchTerm) {
                  setState(() {
                    _constantSearchTerm = searchTerm;
                  });
                  setData();
                },
                constantThingValueList: _constantSearchTerm.isEmpty
                    ? mqttViewModel.serviceValueList
                    : mqttViewModel.serviceValueList
                        .where((e) => e.name.contains(_constantSearchTerm))
                        .toList(),
                constantNumberController: _constantNumberController,
                constantStringController: _constantStringController,
                constantHourController: _constantHourController,
                constantMinuteController: _constantMinuteController,
                isSelectedElse: _isSelectedElse,
                changeSelectedElse: (isSelected) {
                  setState(() {
                    _isSelectedElse = isSelected;
                  });
                  setData();
                  setElseOrNot();
                },
                hourController: _hourController,
                minuteController: _minuteController,
                variableListByType: (variable) => [],
              )
            else if (_state == ConditionBlockState.waitUntil)
              _UntilPage(
                _conditionsForUntil,
                _periodForUntil,
                isUsingConditions: _useConditionForUntil,
                onChangeIsUsingConditions: (isUsingCondition) {
                  setState(() {
                    _useConditionForUntil = isUsingCondition;
                  });
                  setData();
                },
                setNewFirstValue: (int index, dynamic newFirstValue,
                    RangeType? firstRangeType) {
                  setState(() {
                    _conditionsForUntil[index].firstValue = newFirstValue;
                    _conditionsForUntil[index].firstValueRangeType =
                        firstRangeType;
                  });
                  setData();
                },
                setNewOperator: (int index, Operator operator) {
                  setState(() {
                    _conditionsForUntil[index].conditionType = operator;
                  });
                  setData();
                },
                setNewLastValue: (int index, dynamic newLastValue,
                    RangeType? lastRangeType) {
                  setState(() {
                    _conditionsForUntil[index].lastValue = newLastValue;
                    _conditionsForUntil[index].lastValueRangeType =
                        lastRangeType;
                  });
                  setData();
                },
                isExpandedSensorDeviceStatus:
                    _isExpandedSensorDeviceStatusUntil,
                onSensorDeviceStatusExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpandedSensorDeviceStatusUntil = isExpanded;
                  });
                  setData();
                },
                searchController: _searchControllerUntil,
                searchFocusNode: _searchFocusNodeUntil,
                onSearch: (term) {
                  setState(() {
                    _searchTermUntil = term;
                  });
                },
                statusThingValueList: _searchTermUntil.isEmpty
                    ? mqttViewModel.serviceValueList
                    : mqttViewModel.serviceValueList
                        .where((e) => e.name.contains(_searchTermUntil))
                        .toList(),
                isExpandedOperatorStatus: _isExpandedOperatorStatusUntil,
                onOperatorStatusExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpandedOperatorStatusUntil = isExpanded;
                  });
                  setData();
                },
                otherOperatorList: _operatorList,
                isExpandedConstantStatus: _isExpandedConstantStatusUntil,
                onConstantStatusExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpandedConstantStatusUntil = isExpanded;
                  });
                  setData();
                },
                constantSearchController: _constantSearchControllerUntil,
                constantSearchFocusNode: _constantSearchFocusNodeUntil,
                onConstantSearch: (term) {
                  setState(() {
                    _constantSearchTermUntil = term;
                  });
                },
                constantThingValueList: _constantSearchTermUntil.isEmpty
                    ? mqttViewModel.serviceValueList
                    : mqttViewModel.serviceValueList
                        .where((e) => e.name.contains(_constantSearchTermUntil))
                        .toList(),
                constantNumberController: _untilConstantNumberController,
                constantStringController: _untilConstantStringController,
                constantHourController: _untilConstantHourController,
                constantMinuteController: _untilConstantMinuteController,
                variableListByType: (variable) => [],
                periodNumberController: _periodNumberController,
                onChangePeriodNumber: (periodValue) {
                  setState(() {
                    _periodForUntil = PeriodExpression(
                      _periodForUntil.periodType,
                      LiteralExpression(periodValue,
                          literalType: LiteralType.INTEGER),
                    );
                  });
                  setData();
                },
                selectedPeriodType: _periodForUntil.periodType,
                changePeriodType: (periodType) {
                  if (periodType != null) {
                    setState(() {
                      _periodForUntil = PeriodExpression(
                        periodType,
                        _periodForUntil.period,
                      );
                    });
                    setData();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  //
  Future setData() async {
    /// IF 조건의 List<ConditionItem> -> ConditionExpression 변환
    late ConditionExpression finalIfExpression;
    if (_conditionsForIf.length == 1) {
      finalIfExpression = ConditionExpression(
        _conditionsForIf[0].firstValue,
        _conditionsForIf[0].lastValue,
        false,
        _conditionsForIf[0].conditionType!,
      );
    } else {
      for (var i = 0; i < _conditionsForIf.length; i++) {
        if (i == 0) {
          finalIfExpression = ConditionExpression(
            _conditionsForIf[i].firstValue,
            _conditionsForIf[i].lastValue,
            false,
            _conditionsForIf[i].conditionType!,
          );
          continue;
        }
        finalIfExpression = ConditionExpression(
          finalIfExpression,
          ConditionExpression(
            _conditionsForIf[i].firstValue,
            _conditionsForIf[i].lastValue,
            false,
            _conditionsForIf[i].conditionType!,
          ),
          false,
          _logicalOperatorForIf!,
        );
      }
    }

    /// WAIT_UNTIL 조건의 List<ConditionItem> -> ConditionExpression 변환
    late ConditionExpression finalUntilExpression;
    if (_conditionsForUntil.length == 1) {
      finalUntilExpression = ConditionExpression(
        _conditionsForUntil[0].firstValue,
        _conditionsForUntil[0].lastValue,
        false,
        _conditionsForUntil[0].conditionType!,
      );
    } else {
      for (var i = 0; i < _conditionsForUntil.length; i++) {
        if (i == 0) {
          finalUntilExpression = ConditionExpression(
            _conditionsForUntil[i].firstValue,
            _conditionsForUntil[i].lastValue,
            false,
            _conditionsForUntil[i].conditionType!,
          );
          continue;
        }
        finalUntilExpression = ConditionExpression(
          finalUntilExpression,
          ConditionExpression(
            _conditionsForUntil[i].firstValue,
            _conditionsForUntil[i].lastValue,
            false,
            _conditionsForUntil[i].conditionType!,
          ),
          false,

          /// TODO: 지금은 until 조건이 여러 개인 경우가 없어서 임의로 AND로 설정해둠.
          /// TODO: 추후 until 조건이 여러 개가 된다면 이 부분 변경 필요.
          Operator.AND,
        );
      }
    }

    final ifBlock = IfBlock(finalIfExpression);

    final waitUntilBlock = WaitUntilBlock(
      _useConditionForUntil ? null : _periodForUntil,
      _useConditionForUntil ? finalUntilExpression : null,
    );

    if (_state == ConditionBlockState.ifElse) {
      widget.onUpdateIfBlock(ifBlock);
    } else if (_state == ConditionBlockState.waitUntil) {
      widget.onUpdateWaitUntilBlock(waitUntilBlock);
    }
  }

  void setElseOrNot() {
    if (_isSelectedElse) {
      final elseBlock = ElseBlock();
      widget.onUpdateElseBlock(elseBlock);
    } else {
      widget.onUpdateElseBlock(null);
    }
  }
}

class _FirstPage extends StatelessWidget {
  final VoidCallback gotoIfElse;
  final VoidCallback gotoUntil;

  const _FirstPage({
    required this.gotoIfElse,
    required this.gotoUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _card(
          title: '분기 실행 (if-else)',
          description: '어떤 조건을 기준으로 다르게 실행해요.',
          example: '예) 사람이 없으면 로봇 청소기를 켜고, 있으면 꺼줘',
          onClick: () {
            gotoIfElse();
          },
        ),
        const SizedBox(height: 22),
        _card(
          title: '조건 실행 (until)',
          description: '어떤 조건이 만족할 때까지 기다렸다가 실행해요.',
          example: '예) 기온이 30도가 되면 에어컨을 켜줘',
          onClick: () {
            gotoUntil();
          },
        ),
      ],
    );
  }

  Widget _card({
    required String title,
    required String description,
    required String example,
    required VoidCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 275,
        height: 95,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B2759).withAlpha(6),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.size13Bold.copyWith(letterSpacing: -0.39),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: AppTextStyles.size12Medium,
            ),
            const SizedBox(height: 4),
            Text(
              example,
              style: AppTextStyles.size11Medium
                  .copyWith(color: const Color(0xFF8F94A4)),
            ),
          ],
        ),
      ),
    );
  }
}

class _IfElsePage extends StatelessWidget {
  final List<ConditionItem> conditions;
  final List<String> thingValueTypes;
  final void Function(String) addThingValueType;
  final Function(int index, dynamic newFirstValue, RangeType? firstRangeType)
      setNewFirstValue;
  final Function(int index, Operator operator) setNewOperator;
  final Function(int index, dynamic newLastValue, RangeType? lastRangeType)
      setNewLastValue;

  final Operator? logicalOperator;
  final void Function(Operator) onChangedLogicalOperator;
  final VoidCallback addCondition;

  final bool isExpandedSensorDeviceStatus;
  final void Function(bool) onSensorDeviceStatusExpansionChanged;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(String) onSearch;
  final List<ThingValue> statusThingValueList;

  final bool isExpandedOperatorStatus;
  final void Function(bool) onOperatorStatusExpansionChanged;
  final List<Operator> otherOperatorList;

  final bool isExpandedConstantStatus;
  final void Function(bool) onConstantStatusExpansionChanged;
  final TextEditingController constantSearchController;
  final FocusNode constantSearchFocusNode;
  final void Function(String) onConstantSearch;
  final List<ThingValue> constantThingValueList;
  final TextEditingController constantNumberController;
  final TextEditingController constantStringController;
  final TextEditingController constantHourController;
  final TextEditingController constantMinuteController;

  final bool isSelectedElse;
  final void Function(bool) changeSelectedElse;

  final TextEditingController hourController;
  final TextEditingController minuteController;

  final List<Variable> Function(String) variableListByType;

  const _IfElsePage(
    this.conditions, {
    required this.thingValueTypes,
    required this.addThingValueType,
    required this.setNewFirstValue,
    required this.setNewOperator,
    required this.setNewLastValue,
    required this.isExpandedSensorDeviceStatus,
    required this.onSensorDeviceStatusExpansionChanged,
    required this.logicalOperator,
    required this.onChangedLogicalOperator,
    required this.addCondition,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearch,
    required this.statusThingValueList,
    required this.isExpandedOperatorStatus,
    required this.onOperatorStatusExpansionChanged,
    required this.otherOperatorList,
    required this.isExpandedConstantStatus,
    required this.onConstantStatusExpansionChanged,
    required this.constantSearchController,
    required this.constantSearchFocusNode,
    required this.onConstantSearch,
    required this.isSelectedElse,
    required this.changeSelectedElse,
    required this.constantThingValueList,
    required this.constantNumberController,
    required this.constantStringController,
    required this.constantHourController,
    required this.constantMinuteController,
    required this.hourController,
    required this.minuteController,
    required this.variableListByType,
  });

  bool _isWeatherServiceSelected(int index) =>
      conditions[index].firstValue != null &&
      conditions[index].firstValue is ValueServiceExpression &&
      (conditions[index].firstValue as ValueServiceExpression).serviceName ==
          _weatherServiceName;

  bool _isDateTimeServiceSelected(int index) =>
      conditions[index].firstValue != null &&
      conditions[index].firstValue is ValueServiceExpression &&
      (conditions[index].firstValue as ValueServiceExpression).serviceName ==
          _dateTimeServiceName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            const SizedBox(width: 12),
            Text(
              '만일 (if)',
              style: AppTextStyles.size14Bold
                  .copyWith(color: const Color(0xFF5D7CFF)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: addCondition,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  '+ 조건추가',
                  style: AppTextStyles.size14Medium.copyWith(height: 22 / 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 18),
        ...List.generate(
          conditions.length,
          (index) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index >= 1) const SizedBox(height: 36),
              if (conditions.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '조건 ${index + 1}',
                    style: AppTextStyles.size14Bold.copyWith(
                      color: const Color(0xFF5D7CFF),
                    ),
                  ),
                ),
              _VariableStatusWidget(
                conditions[index].firstValue,
                isExpanded: isExpandedSensorDeviceStatus,
                onExpansionChanged: onSensorDeviceStatusExpansionChanged,
                searchController: searchController,
                searchFocusNode: searchFocusNode,
                onSearch: onSearch,
                thingValueList: statusThingValueList,
                setFirstValue: (ThingValue thingValue) {
                  addThingValueType(thingValue.type);
                  setNewFirstValue(
                    index,
                    thingValue.toValueServiceExpression(RangeType.AUTO),
                    null,
                  );
                },
                onBlockChanged: (ValueServiceBlock changedBlock) {
                  setNewFirstValue(
                    index,
                    conditions[index].firstValue.copyWith(
                          tags:
                              changedBlock.valueServiceExpression.tags.map((e) {
                            return e;
                            // return Tag(name: e);
                          }).toList(),
                        ),
                    changedBlock.valueServiceExpression.rangeType,
                  );
                },
              ),
              _OperatorStatusWidget(
                isExpanded: isExpandedOperatorStatus,
                onExpansionChanged: onOperatorStatusExpansionChanged,
                currentOperator: conditions[index].conditionType!,
                onSelectOperator: (newOperator) {
                  setNewOperator(index, newOperator);
                },
                otherOperatorList: _isWeatherServiceSelected(index)
                    ? [Operator.EQUAL, Operator.NOT_EQUAL]
                    : (index < thingValueTypes.length) &&
                            (thingValueTypes[index] != 'double' &&
                                thingValueTypes[index] != 'int')
                        ? [Operator.EQUAL, Operator.NOT_EQUAL]
                        : otherOperatorList,
              ),
              if (_isWeatherServiceSelected(index))
                _ConstantWeatherWidget(
                  selectedWeather: (conditions[index].lastValue != null &&
                          conditions[index].lastValue is LiteralExpression)
                      ? (conditions[index].lastValue as LiteralExpression)
                          .value
                          .toString()
                          .toWeatherStateFromValue
                      : null,
                  onSelect: (weather) {
                    setNewLastValue(
                      index,
                      LiteralExpression(
                        weather.value,
                        literalType: LiteralType.STRING,
                      ),
                      null,
                    );
                  },
                )
              else if (_isDateTimeServiceSelected(index))
                _ConstantDateTimeWidget(
                  dateTime: (conditions[index].lastValue != null &&
                          conditions[index].lastValue is LiteralExpression)
                      ? DateTime.fromMillisecondsSinceEpoch(
                          (conditions[index].lastValue as LiteralExpression)
                                  .value *
                              1000)
                      : null,
                  onChange: (dateTime) {
                    if (dateTime != null) {
                      setNewLastValue(
                        index,
                        LiteralExpression(
                          dateTime.millisecondsSinceEpoch ~/ 1000,
                          literalType: LiteralType.INTEGER,
                        ),
                        null,
                      );
                    } else {
                      setNewLastValue(
                        index,
                        LiteralExpression(
                          null,
                          literalType: LiteralType.UNDEFINED,
                        ),
                        null,
                      );
                    }
                  },
                  hourController: hourController,
                  minuteController: minuteController,
                )
              else if (index < thingValueTypes.length)
                _ConstantStatusWidget(
                  conditions[index].lastValue,
                  isExpanded: isExpandedConstantStatus,
                  onExpansionChanged: onConstantStatusExpansionChanged,
                  thingValueType: thingValueTypes[index],
                  searchController: constantSearchController,
                  searchFocusNode: constantSearchFocusNode,
                  onSearch: onConstantSearch,
                  thingValueList: constantThingValueList
                      .where(
                        (element) => element.type == thingValueTypes[index],
                      )
                      .toList(),
                  numberController: constantNumberController,
                  stringController: constantStringController,
                  hourController: constantHourController,
                  minuteController: constantMinuteController,
                  variableListByType: variableListByType,
                  setLastValue: (ThingValue thingValue) {
                    setNewLastValue(
                      index,
                      thingValue.toValueServiceExpression(RangeType.AUTO),
                      null,
                    );
                  },
                  setLastValueByExpression: (LiteralExpression expression) {
                    setNewLastValue(
                      index,
                      expression,
                      null,
                    );
                  },
                  onBlockChanged: (ValueServiceBlock changedBlock) {
                    setNewLastValue(
                      index,
                      conditions[index].firstValue.copyWith(
                              tags: changedBlock.valueServiceExpression.tags
                                  .map((e) {
                            return e;
                            // return Tag(name: e);
                          }).toList()),
                      changedBlock.valueServiceExpression.rangeType,
                    );
                  },
                  onLiteralExpressionChanged: (LiteralExpression expression) {
                    setNewLastValue(
                      index,
                      expression,
                      null,
                    );
                  },
                ),
            ],
          ),
        ),
        if (conditions.length > 1) ...[
          const SizedBox(height: 44),
          RadioTextButton<Operator>(
            value: Operator.AND,
            groupValue: logicalOperator!,
            onChanged: onChangedLogicalOperator,
            title: '모두 만족하면',
          ),
          const SizedBox(height: 16),
          RadioTextButton<Operator>(
            value: Operator.OR,
            groupValue: logicalOperator!,
            onChanged: onChangedLogicalOperator,
            title: '적어도 하나가 만족하면',
          ),
        ],
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            '인 경우 기능을 실행합니다.',
            style: AppTextStyles.size14Bold
                .copyWith(color: const Color(0xFF5D7CFF)),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            changeSelectedElse(!isSelectedElse);
          },
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isSelectedElse
                      ? const Color(0xFF5D7CFF)
                      : const Color(0xFFFFFFFF),
                  border: Border.all(width: 1, color: const Color(0xFFDAE2EC)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelectedElse
                    ? SvgPicture.asset('assets/icons/tmp_check_white.svg',
                        width: 15, height: 15)
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),
              Text(
                '그렇지 않다면 (else) 실행할 기능 추가',
                style: AppTextStyles.size14Regular
                    .copyWith(color: const Color(0xFF5D7CFF)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UntilPage extends StatelessWidget {
  /// condition으로 wait until 조건을 짜는 경우
  final List<ConditionItem> conditions;
  final Function(int index, dynamic newFirstValue, RangeType? firstRangeType)
      setNewFirstValue;
  final Function(int index, Operator operator) setNewOperator;
  final Function(int index, dynamic newLastValue, RangeType? lastRangeType)
      setNewLastValue;

  /// period로 wait until 조건을 짜는 경우
  final bool isUsingConditions;
  final void Function(bool isUsingConditions) onChangeIsUsingConditions;
  final PeriodExpression? periodExpression;

  /// condition으로 조건을 짤 때 사용
  final bool isExpandedSensorDeviceStatus;
  final void Function(bool) onSensorDeviceStatusExpansionChanged;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(String) onSearch;
  final List<ThingValue> statusThingValueList;

  final bool isExpandedOperatorStatus;
  final void Function(bool) onOperatorStatusExpansionChanged;
  final List<Operator> otherOperatorList;

  final bool isExpandedConstantStatus;
  final void Function(bool) onConstantStatusExpansionChanged;
  final TextEditingController constantSearchController;
  final FocusNode constantSearchFocusNode;
  final void Function(String) onConstantSearch;
  final List<ThingValue> constantThingValueList;
  final TextEditingController constantNumberController;
  final TextEditingController constantStringController;
  final TextEditingController constantHourController;
  final TextEditingController constantMinuteController;

  final List<Variable> Function(String) variableListByType;

  /// period로 조건을 짤 때 사용
  final TextEditingController periodNumberController;
  final void Function(int value) onChangePeriodNumber;
  final PeriodType selectedPeriodType;
  final void Function(PeriodType? periodType) changePeriodType;

  const _UntilPage(
    this.conditions,
    this.periodExpression, {
    required this.isUsingConditions,
    required this.onChangeIsUsingConditions,
    required this.setNewFirstValue,
    required this.setNewOperator,
    required this.setNewLastValue,
    required this.isExpandedSensorDeviceStatus,
    required this.onSensorDeviceStatusExpansionChanged,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearch,
    required this.statusThingValueList,
    required this.isExpandedOperatorStatus,
    required this.onOperatorStatusExpansionChanged,
    required this.otherOperatorList,
    required this.isExpandedConstantStatus,
    required this.onConstantStatusExpansionChanged,
    required this.constantSearchController,
    required this.constantSearchFocusNode,
    required this.onConstantSearch,
    required this.constantThingValueList,
    required this.constantNumberController,
    required this.constantStringController,
    required this.constantHourController,
    required this.constantMinuteController,
    required this.variableListByType,
    required this.periodNumberController,
    required this.onChangePeriodNumber,
    required this.selectedPeriodType,
    required this.changePeriodType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _textButton(
              '조건',
              isSelected: isUsingConditions,
              onClick: () => onChangeIsUsingConditions(true),
            ),
            const SizedBox(width: 10),
            _textButton(
              '기간',
              isSelected: !isUsingConditions,
              onClick: () => onChangeIsUsingConditions(false),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            '다음 조건',
            style: AppTextStyles.size14Medium.copyWith(
              letterSpacing: -0.42,
              color: const Color(0xFF5D7CFF),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (isUsingConditions) ...[
          _VariableStatusWidget(
            conditions[0].firstValue,
            isExpanded: isExpandedSensorDeviceStatus,
            onExpansionChanged: onSensorDeviceStatusExpansionChanged,
            searchController: searchController,
            searchFocusNode: searchFocusNode,
            onSearch: onSearch,
            thingValueList: statusThingValueList,
            setFirstValue: (ThingValue thingValue) {
              setNewFirstValue(
                0,
                thingValue.toValueServiceExpression(RangeType.AUTO),
                null,
              );
            },
            onBlockChanged: (ValueServiceBlock changedBlock) {
              setNewFirstValue(
                0,
                conditions[0].firstValue.copyWith(
                      tags: changedBlock.valueServiceExpression.tags.map((e) {
                        return e;
                      }).toList(),
                    ),
                changedBlock.valueServiceExpression.rangeType,
              );
            },
          ),
          _OperatorStatusWidget(
            isExpanded: isExpandedOperatorStatus,
            onExpansionChanged: onOperatorStatusExpansionChanged,
            currentOperator: conditions[0].conditionType!,
            onSelectOperator: (newOperator) {
              setNewOperator(0, newOperator);
            },
            otherOperatorList: otherOperatorList,
          ),
          _ConstantStatusWidget(
            conditions[0].lastValue,
            isExpanded: isExpandedConstantStatus,
            thingValueType: 'xxxxx',
            onExpansionChanged: onConstantStatusExpansionChanged,
            searchController: constantSearchController,
            searchFocusNode: constantSearchFocusNode,
            onSearch: onConstantSearch,
            thingValueList: constantThingValueList,
            numberController: constantNumberController,
            stringController: constantStringController,
            hourController: constantHourController,
            minuteController: constantMinuteController,
            variableListByType: variableListByType,
            setLastValue: (ThingValue thingValue) {
              setNewLastValue(
                0,
                thingValue.toValueServiceExpression(RangeType.AUTO),
                null,
              );
            },
            setLastValueByExpression: (LiteralExpression expression) {
              setNewLastValue(
                0,
                expression,
                null,
              );
            },
            onBlockChanged: (ValueServiceBlock changedBlock) {
              setNewLastValue(
                0,
                conditions[0].firstValue.copyWith(
                        tags: changedBlock.valueServiceExpression.tags.map((e) {
                      return e;
                      // return Tag(name: e);
                    }).toList()),
                changedBlock.valueServiceExpression.rangeType,
              );
            },
            onLiteralExpressionChanged: (LiteralExpression expression) {
              setNewLastValue(
                0,
                expression,
                null,
              );
            },
          ),
        ] else ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              EditorNumberTextField(
                enabled: true,
                controller: periodNumberController,
                min: 1,
                max: 99,
                onChanged: onChangePeriodNumber,
              ),
              const SizedBox(width: 8),
              CustomDropDown<PeriodType>(
                enabled: true,
                selectedValue: selectedPeriodType,
                onChanged: changePeriodType,
                items: PeriodType.enableList,
              ),
            ],
          ),
        ],
        const SizedBox(height: 34),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            '을 만족할 때까지 기다렸다가\n조건을 만족하면 기능을 실행합니다.',
            style: AppTextStyles.size14Medium.copyWith(
              letterSpacing: -0.42,
              color: const Color(0xFF5D7CFF),
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _textButton(
    String text, {
    required bool isSelected,
    required VoidCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 51,
        height: 31,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D7CFF) : const Color(0xFFFFFFFF),
          border: Border.all(width: 1, color: const Color(0xFFE9ECF5)),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.size12Medium.singleLine.copyWith(
            color:
                isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF8F94A4),
          ),
        ),
      ),
    );
  }
}

class _VariableStatusWidget extends StatelessWidget {
  final bool isExpanded;
  final void Function(bool isExpanded) onExpansionChanged;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(String value) onSearch;
  final List<ThingValue> thingValueList;

  final dynamic firstValue;
  final Function(ThingValue thingValue) setFirstValue;
  final Function(ValueServiceBlock block) onBlockChanged;

  const _VariableStatusWidget(
    this.firstValue, {
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearch,
    required this.thingValueList,
    required this.setFirstValue,
    required this.onBlockChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (firstValue != null && firstValue is ValueServiceExpression) {
      return ValueServiceBlockWidget(
        firstValue,
        onBlockChanged: onBlockChanged,
      );
    }

    bool isWeatherServiceExist = false;
    bool isDateTimeServiceExist = false;
    final thingValueListExceptWeatherAndTimestamp = thingValueList.where(
      (element) {
        if (element.name == _weatherServiceName) {
          isWeatherServiceExist = true;
        } else if (element.name == _dateTimeServiceName) {
          isDateTimeServiceExist = true;
        }

        return element.name != _weatherServiceName &&
            element.name != _dateTimeServiceName;
      },
    ).toList();

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
          initiallyExpanded: false,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(16, 0, 11, 0),
          onExpansionChanged: onExpansionChanged,
          title: Text(
            (firstValue != null) ? firstValue.toString() : '센서, 디바이스 상태',
            style: AppTextStyles.size12Bold.copyWith(
              color: firstValue != null
                  ? const Color(0xFF3F424B)
                  : const Color(0xFFADB3C6),
            ),
          ),
          trailing: SvgPicture.asset(
            isExpanded
                ? 'assets/icons/expansion_up.svg'
                : 'assets/icons/expansion_down.svg',
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            /// 검색창
            TextFormField(
              controller: searchController,
              focusNode: searchFocusNode,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: onSearch,
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
                hintText: '센서 값, 디바이스 상태 검색',
                hintStyle: AppTextStyles.size12Regular.copyWith(
                  color: const Color(0xFFADB3C6),
                  height: 22 / 12,
                  letterSpacing: -0.36,
                ),
                fillColor: const Color(0xFFFFFFFF),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFE9ECF5)),
                ),
                suffixIconConstraints:
                    const BoxConstraints(minHeight: 38, maxHeight: 38),
                suffixIcon: GestureDetector(
                  onTap: () => onSearch(searchController.text),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 12),
                    child: SvgPicture.asset(
                      'assets/icons/scenario_editor_search.svg',
                      height: 13,
                    ),
                  ),
                ),
              ),
            ),

            /// 센서/디바이스 상태 리스트
            SizedBox(
              height: _listHeight,
              child: ListView.separated(
                itemCount: thingValueListExceptWeatherAndTimestamp.length,
                itemBuilder: (_, index) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setFirstValue(
                        thingValueListExceptWeatherAndTimestamp[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 16, 0, 16),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: IconHelper.getServiceIcon(
                              thingValueListExceptWeatherAndTimestamp[index]
                                      .category ??
                                  ''),
                          height: 19,
                          fit: BoxFit.fitHeight,
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                            imageUrl: IconHelper.getServiceIcon('undefined'),
                            height: 19,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          thingValueListExceptWeatherAndTimestamp[index].name,
                          style: AppTextStyles.size12Medium
                              .copyWith(letterSpacing: -0.36),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFF0F2F9)),
              ),
            ),

            if (isWeatherServiceExist || isDateTimeServiceExist)
              const Divider(
                height: 1,
                color: Color(0xFFF3F5FA),
              ),

            /// 현재 날씨
            if (isWeatherServiceExist)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setFirstValue(
                    thingValueList.firstWhere(
                        (element) => element.name == _weatherServiceName),
                  );
                },
                child: Container(
                  height: 53,
                  padding: const EdgeInsets.only(left: 14),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFF3F5FA)),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '현재 날씨',
                    style: AppTextStyles.size12Bold,
                  ),
                ),
              ),

            /// 현재 시간
            if (isDateTimeServiceExist)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setFirstValue(
                    thingValueList.firstWhere(
                        (element) => element.name == _dateTimeServiceName),
                  );
                },
                child: Container(
                  height: 53,
                  padding: const EdgeInsets.only(left: 14),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '현재 시간',
                    style: AppTextStyles.size12Bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OperatorStatusWidget extends StatelessWidget {
  final bool isExpanded;
  final void Function(bool isExpanded) onExpansionChanged;
  final Operator currentOperator;
  final void Function(Operator newStatus) onSelectOperator;
  final List<Operator> otherOperatorList;

  const _OperatorStatusWidget({
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.currentOperator,
    required this.onSelectOperator,
    required this.otherOperatorList,
  });

  @override
  Widget build(BuildContext context) {
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
          initiallyExpanded: false,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(16, 0, 11, 0),
          onExpansionChanged: onExpansionChanged,
          title: Text(
            currentOperator.title ?? currentOperator.toString(),
            style: AppTextStyles.size12Bold,
          ),
          trailing: SvgPicture.asset(
            isExpanded
                ? 'assets/icons/expansion_up.svg'
                : 'assets/icons/expansion_down.svg',
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 14),
          children: otherOperatorList
              .map(
                (operator) => GestureDetector(
                  onTap: () {
                    onSelectOperator(operator);
                  },
                  child: Container(
                    height: 53,
                    decoration: BoxDecoration(
                      color: currentOperator == operator
                          ? const Color(0xFFEBEFF9)
                          : null,
                      border: const Border(
                        bottom: BorderSide(width: 1, color: Color(0xFFF0F2F9)),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      operator.title ?? operator.toString(),
                      style: AppTextStyles.size12Bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ConstantStatusWidget extends StatelessWidget {
  final bool isExpanded;
  final void Function(bool isExpanded) onExpansionChanged;
  final String thingValueType;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function(String value) onSearch;
  final List<ThingValue> thingValueList;
  final TextEditingController numberController;
  final TextEditingController stringController;

  final dynamic lastValue;
  final Function(ThingValue thingValue) setLastValue;
  final Function(LiteralExpression expression) setLastValueByExpression;
  final Function(ValueServiceBlock block) onBlockChanged;
  final Function(LiteralExpression expression) onLiteralExpressionChanged;

  final TextEditingController hourController;
  final TextEditingController minuteController;

  final List<Variable> Function(String type) variableListByType;

  const _ConstantStatusWidget(
    this.lastValue, {
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.thingValueType,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearch,
    required this.thingValueList,
    required this.numberController,
    required this.stringController,
    required this.setLastValue,
    required this.setLastValueByExpression,
    required this.onBlockChanged,
    required this.onLiteralExpressionChanged,
    required this.hourController,
    required this.minuteController,
    required this.variableListByType,
  });

  @override
  Widget build(BuildContext context) {
    if (lastValue is ValueServiceExpression) {
      return ValueServiceBlockWidget(
        lastValue,
        onBlockChanged: onBlockChanged,
      );
    }

    /*if (lastValue is LiteralExpression) {
      return LiteralBlockWidget(
        lastValue,
        onBlockChanged: onLiteralExpressionChanged,
      );
    }*/

    bool isWeatherServiceExist = false;
    bool isDateTimeServiceExist = false;
    final thingValueListExceptWeatherAndTimestamp = thingValueList.where(
      (element) {
        if (element.name == _weatherServiceName) {
          isWeatherServiceExist = true;
        } else if (element.name == _dateTimeServiceName) {
          isDateTimeServiceExist = true;
        }

        return element.name != _weatherServiceName &&
            element.name != _dateTimeServiceName;
      },
    ).toList();

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
          initiallyExpanded: false,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(16, 0, 11, 0),
          onExpansionChanged: onExpansionChanged,
          title: Text(
            lastValue != null
                ? (lastValue is LiteralExpression
                    ? (lastValue as LiteralExpression).valueString
                    : lastValue.toString())
                : '센서, 디바이스 상태, 숫자, 문자열...',
            style: AppTextStyles.size12Bold.copyWith(
              color: lastValue != null
                  ? const Color(0xFF3F424B)
                  : const Color(0xFFADB3C6),
            ),
          ),
          trailing: SvgPicture.asset(
            isExpanded
                ? 'assets/icons/expansion_up.svg'
                : 'assets/icons/expansion_down.svg',
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            /// 검색창
            TextFormField(
              controller: searchController,
              focusNode: searchFocusNode,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: onSearch,
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
                hintText: '센서 값, 디바이스 상태 검색',
                hintStyle: AppTextStyles.size12Regular.copyWith(
                  color: const Color(0xFFADB3C6),
                  height: 22 / 12,
                  letterSpacing: -0.36,
                ),
                fillColor: const Color(0xFFFFFFFF),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFE9ECF5)),
                ),
                suffixIconConstraints:
                    const BoxConstraints(minHeight: 38, maxHeight: 38),
                suffixIcon: GestureDetector(
                  onTap: () => onSearch(searchController.text),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 12),
                    child: SvgPicture.asset(
                      'assets/icons/scenario_editor_search.svg',
                      height: 13,
                    ),
                  ),
                ),
              ),
            ),

            /// 센서/디바이스 상태 리스트
            SizedBox(
              height: _listHeight,
              child: ListView.separated(
                itemCount: thingValueListExceptWeatherAndTimestamp.length,
                itemBuilder: (_, index) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setLastValue(
                        thingValueListExceptWeatherAndTimestamp[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 16, 0, 16),
                    child: Text(
                      thingValueListExceptWeatherAndTimestamp[index].name,
                      style: AppTextStyles.size12Medium
                          .copyWith(letterSpacing: -0.36),
                    ),
                  ),
                ),
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFF0F2F9)),
              ),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF3F5FA),
            ),

            /// 날씨
            if (isWeatherServiceExist && thingValueType == 'string')
              _ConstantWeatherWidget(
                selectedWeather: (lastValue is LiteralExpression &&
                        (lastValue as LiteralExpression).literalType ==
                            LiteralType.STRING)
                    ? (lastValue as LiteralExpression)
                        .valueString
                        .toWeatherStateFromValue
                    : null,
                onSelect: (weather) {
                  setLastValueByExpression(
                    LiteralExpression(weather.value,
                        literalType: LiteralType.STRING),
                  );
                },
              ),

            /// 시간
            if (isDateTimeServiceExist && thingValueType == 'int')
              _ConstantDateTimeWidget(
                dateTime: (lastValue is LiteralExpression &&
                        (lastValue as LiteralExpression).literalType ==
                            LiteralType.INTEGER)
                    ? DateTime.fromMillisecondsSinceEpoch(
                        (lastValue as LiteralExpression).value * 1000)
                    : null,
                onChange: (dateTime) {
                  if (dateTime != null) {
                    setLastValueByExpression(
                      LiteralExpression(
                        dateTime.millisecondsSinceEpoch ~/ 1000,
                        literalType: LiteralType.INTEGER,
                      ),
                    );
                  } else {
                    setLastValueByExpression(
                      LiteralExpression(null,
                          literalType: LiteralType.UNDEFINED),
                    );
                  }
                },
                hourController: hourController,
                minuteController: minuteController,
              ),

            /// 숫자
            if (thingValueType == 'int' || thingValueType == 'double')
              _otherStatus(
                title: '숫자',
                controller: numberController,
                inputType: TextInputType.number,
                onChanged: (String value) {
                  if (double.tryParse(value) != null) {
                    setLastValueByExpression(
                      LiteralExpression(double.parse(value),
                          literalType: LiteralType.DOUBLE),
                    );
                  } else if (int.tryParse(value) != null) {
                    setLastValueByExpression(
                      LiteralExpression(int.parse(value),
                          literalType: LiteralType.INTEGER),
                    );
                  }
                },
              ),

            /// 문자열
            if (thingValueType == 'string')
              _otherStatus(
                  title: '문자열',
                  controller: stringController,
                  inputType: TextInputType.name,
                  onChanged: (String value) {
                    setLastValueByExpression(
                      LiteralExpression(value.toString(),
                          literalType: LiteralType.STRING),
                    );
                  }),

            /// 참/거짓
            if (thingValueType == 'bool')
              _boolStatus(
                  currentValue: (lastValue is LiteralExpression &&
                          (lastValue as LiteralExpression).literalType ==
                              LiteralType.BOOL)
                      ? (lastValue as LiteralExpression).value
                      : null,
                  onChanged: (bool value) {
                    setLastValueByExpression(
                      LiteralExpression(value, literalType: LiteralType.BOOL),
                    );
                  }),

            /// 변수값
            EditorVariableListWidget(
              isVariableForLeftSide: false,
              variableList: variableListByType(thingValueType)
                  .map((variable) => variable.name)
                  .toList(),
              initialSelectedVariable: (lastValue is LiteralExpression &&
                      (lastValue as LiteralExpression).literalType ==
                          LiteralType.VARIABLE)
                  ? (lastValue as LiteralExpression).valueString
                  : null,
              onSelect: (variable) {
                setLastValueByExpression(
                  LiteralExpression(variable,
                      literalType: LiteralType.VARIABLE),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherStatus({
    required String title,
    required TextEditingController controller,
    required TextInputType inputType,
    required void Function(String value) onChanged,
  }) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFF3F5FA)),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(14, 0, 11, 0), //16
          onExpansionChanged: onExpansionChanged,
          title: Text(
            title,
            style: AppTextStyles.size12Bold,
          ),
          trailing: SvgPicture.asset(
            isExpanded
                ? 'assets/icons/expansion_up.svg'
                : 'assets/icons/expansion_down.svg',
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          children: [
            TextFormField(
              controller: controller,
              // focusNode: ,
              keyboardType: inputType,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) => onChanged(value),
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
                hintText: '값 입력',
                hintStyle: AppTextStyles.size12Regular.copyWith(
                  color: const Color(0xFFADB3C6),
                  height: 22 / 12,
                  letterSpacing: -0.36,
                ),
                fillColor: const Color(0xFFFFFFFF),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFE9ECF5)),
                ),
                suffixIconConstraints:
                    const BoxConstraints(minHeight: 38, maxHeight: 38),
                suffixIcon: GestureDetector(
                  onTap: () {
                    onChanged(controller.text);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 12),
                    child: SvgPicture.asset(
                      'assets/icons/scenario_editor_search.svg',
                      height: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boolStatus({
    required bool? currentValue,
    required Function(bool) onChanged,
  }) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFF3F5FA)),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(14, 0, 11, 0), //16
          onExpansionChanged: onExpansionChanged,
          title: const Text(
            '참/거짓',
            style: AppTextStyles.size12Bold,
          ),
          trailing: SvgPicture.asset(
            isExpanded
                ? 'assets/icons/expansion_up.svg'
                : 'assets/icons/expansion_down.svg',
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    onChanged(true);
                  },
                  child: Container(
                    width: 60,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentValue == true
                          ? const Color(0xFF5D7CFF)
                          : const Color(0xFFFFFFFF),
                      border:
                          Border.all(width: 1, color: const Color(0xFFE9ECF5)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '참',
                      style: AppTextStyles.size14Medium.copyWith(
                        color: currentValue == true
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF8F94A4),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    onChanged(false);
                  },
                  child: Container(
                    width: 60,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentValue == false
                          ? const Color(0xFF5D7CFF)
                          : const Color(0xFFFFFFFF),
                      border:
                          Border.all(width: 1, color: const Color(0xFFE9ECF5)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '거짓',
                      style: AppTextStyles.size14Medium.copyWith(
                        color: currentValue == false
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF8F94A4),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ConstantWeatherWidget extends StatelessWidget {
  final WeatherState? selectedWeather;
  final void Function(WeatherState) onSelect;

  const _ConstantWeatherWidget({
    required this.selectedWeather,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
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
          initiallyExpanded: false,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(16, 0, 11, 0),
          title: Text(
            selectedWeather != null ? selectedWeather!.title : '날씨...',
            style: AppTextStyles.size12Bold.copyWith(
              color: selectedWeather != null
                  ? const Color(0xFF3F424B)
                  : const Color(0xFFADB3C6),
            ),
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: WeatherState.values
                  .map(
                    (weather) => GestureDetector(
                      onTap: () => onSelect(weather),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: weather == selectedWeather
                              ? const Color(0xFF5D7CFF)
                              : const Color(0xFFFFFFFF),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFFE9ECF5),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          weather.title,
                          style: AppTextStyles.size14Medium.copyWith(
                            color: weather == selectedWeather
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF8F94A4),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstantDateTimeWidget extends StatelessWidget {
  static final DateTime _lastDate = DateTime(2099, 12, 31);

  final DateTime? dateTime;
  final void Function(DateTime?) onChange;

  final TextEditingController hourController;
  final TextEditingController minuteController;

  const _ConstantDateTimeWidget({
    required this.dateTime,
    required this.onChange,
    required this.hourController,
    required this.minuteController,
  });

  @override
  Widget build(BuildContext context) {
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
          initiallyExpanded: false,
          shape: const Border(),
          tilePadding: const EdgeInsets.fromLTRB(16, 0, 11, 0),
          title: Text(
            dateTime != null
                ? DateFormat('yyyy.MM.dd HH:mm:ss').format(dateTime!)
                : '날짜 및 시간...',
            style: AppTextStyles.size12Bold.copyWith(
              color: dateTime != null
                  ? const Color(0xFF3F424B)
                  : const Color(0xFFADB3C6),
            ),
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 12),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditorDateButton(
              enabled: true,
              dateTime,
              onClick: () async {
                final DateTime? selectedDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: _lastDate,
                );

                onChange(selectedDateTime);
              },
            ),
            const SizedBox(height: 6),
            EditorSelectTimeWidget(
              enabled: dateTime != null,
              selectedTimePrefix: dateTime?.getAmPm ?? AmPm.am,
              onChangedTimePrefix: (amPm) {
                if (amPm != null) {
                  onChange(dateTime?.copyWithAmPm(amPm));
                }
              },
              hourController: hourController,
              onChangedHour: (hour) => onChange(dateTime?.copyWith(hour: hour)),
              minuteController: minuteController,
              onChangedMinute: (minute) =>
                  onChange(dateTime?.copyWith(minute: minute)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
