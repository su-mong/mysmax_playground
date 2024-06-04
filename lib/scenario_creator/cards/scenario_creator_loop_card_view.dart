import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/enums.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';
import 'package:mysmax_playground/helper/date_time_helper.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_date_button.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_number_text_field.dart';
import 'package:mysmax_playground/scenario_editor/widgets/editor_select_time_widget.dart';
import 'package:mysmax_playground/widgets/custom_drop_down.dart';

class ScenarioCreatorLoopCardView extends StatefulWidget {
  final Function(LoopBlock) onUpdateBlock;

  const ScenarioCreatorLoopCardView({super.key, required this.onUpdateBlock});

  @override
  State<StatefulWidget> createState() => _ScenarioCreatorLoopCardViewState();
}

class _ScenarioCreatorLoopCardViewState
    extends State<ScenarioCreatorLoopCardView> {
  static final DateTime _lastDate = DateTime(2099, 12, 31);

  bool _isExpanded = true;

  LoopMode _loopMode = LoopMode.MANUAL;
  PeriodExpression _period = PeriodExpression(
    PeriodType.HOUR,
    LiteralExpression(1, literalType: LiteralType.INTEGER),
  );

  List<DateTime?> _timeBoundCustom = [null, null];
  bool _enableStartDateTimeCustom = false;
  bool _enableEndDateTimeCustom = false;
  final TextEditingController _customDurationNumberController =
      TextEditingController();
  final TextEditingController _customStartHourController =
      TextEditingController();
  final TextEditingController _customStartMinuteController =
      TextEditingController();
  final TextEditingController _customEndHourController =
      TextEditingController();
  final TextEditingController _customEndMinuteController =
      TextEditingController();

  List<DateTime?> _timeBoundEveryDay = [null, null];
  bool _enableStartDateTimeEveryDay = false;
  bool _enableEndDateTimeEveryDay = false;
  final TextEditingController _everydayStartHourController =
      TextEditingController();
  final TextEditingController _everydayStartMinuteController =
      TextEditingController();
  final TextEditingController _everydayEndHourController =
      TextEditingController();
  final TextEditingController _everydayEndMinuteController =
      TextEditingController();

  List<DateTime?> _timeBoundEveryWeek = [null, null];
  DateTime? _timeEveryWeek;

  /// '매주' 반복의 시간 설정 용도. date 부분은 임의로 설정해두고, 실제로 사용하진 않음.
  List<WeekDay> _weekdays = [];
  bool _enableStartDateEveryWeek = false;
  bool _enableEndDateEveryWeek = false;
  final TextEditingController _everyWeekHourController =
      TextEditingController();
  final TextEditingController _everyWeekMinuteController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _timeBoundEveryDay = [null, null];
    _enableStartDateTimeEveryDay = _timeBoundEveryDay[0] != null;
    _everydayStartHourController.text = _timeBoundEveryDay[0] != null
        ? DateFormat('hh').format(_timeBoundEveryDay[0]!)
        : '';
    _everydayStartMinuteController.text = _timeBoundEveryDay[0] != null
        ? DateFormat('mm').format(_timeBoundEveryDay[0]!)
        : '';
    _enableEndDateTimeEveryDay = _timeBoundEveryDay[1] != null;
    _everydayEndHourController.text = _timeBoundEveryDay[1] != null
        ? DateFormat('hh').format(_timeBoundEveryDay[1]!)
        : '';
    _everydayEndMinuteController.text = _timeBoundEveryDay[1] != null
        ? DateFormat('mm').format(_timeBoundEveryDay[1]!)
        : '';

    _period = PeriodExpression(
      PeriodType.HOUR,
      LiteralExpression(1, literalType: LiteralType.INTEGER),
    );
    _timeBoundCustom = [null, null];
    _enableStartDateTimeCustom = _timeBoundCustom[0] != null;
    _customDurationNumberController.text = _period.period.value.toString();
    _customStartHourController.text = _timeBoundCustom[0] != null
        ? DateFormat('hh').format(_timeBoundCustom[0]!)
        : '';
    _customStartMinuteController.text = _timeBoundCustom[0] != null
        ? DateFormat('mm').format(_timeBoundCustom[0]!)
        : '';
    _enableEndDateTimeCustom = _timeBoundCustom[1] != null;
    _customEndHourController.text = _timeBoundCustom[1] != null
        ? DateFormat('hh').format(_timeBoundCustom[1]!)
        : '';
    _customEndMinuteController.text = _timeBoundCustom[0] != null
        ? DateFormat('mm').format(_timeBoundCustom[1]!)
        : '';

    _weekdays = [];
    _timeBoundEveryWeek = [null, null];
    _enableStartDateEveryWeek = _timeBoundEveryWeek[0] != null;
    _enableEndDateEveryWeek = _timeBoundEveryWeek[1] != null;

    _everyWeekHourController.text = _timeBoundEveryWeek[0] != null
        ? DateFormat('hh').format(_timeBoundEveryWeek[0]!)
        : '';
    _everyWeekMinuteController.text = _timeBoundEveryWeek[0] != null
        ? DateFormat('mm').format(_timeBoundEveryWeek[0]!)
        : '';
  }

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
              '언제 실행할까요?',
              style: AppTextStyles.size16Bold.singleLine,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: _isExpanded == false
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: _dateTimeWidget(
                    startDateTime: _loopMode == LoopMode.MANUAL
                        ? _timeBoundCustom[0]
                        : _loopMode == LoopMode.DAILY
                            ? _timeBoundEveryDay[0]
                            : _timeBoundEveryWeek[0],
                    endDateTime: _loopMode == LoopMode.MANUAL
                        ? _timeBoundCustom[1]
                        : _loopMode == LoopMode.DAILY
                            ? _timeBoundEveryDay[1]
                            : _timeBoundEveryWeek[1],
                  ),
                )
              : const SizedBox.shrink(),
          trailing: SvgPicture.asset(_isExpanded
              ? 'assets/icons/expansion_up.svg'
              : 'assets/icons/expansion_down.svg'),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _textButton(
                  '사용자설정',
                  width: 75,
                  isSelected: _loopMode == LoopMode.MANUAL,
                  onClick: () {
                    setState(() {
                      _loopMode = LoopMode.MANUAL;
                    });
                    setData();
                  },
                ),
                const SizedBox(width: 10),
                _textButton(
                  '매일',
                  width: 51,
                  isSelected: _loopMode == LoopMode.DAILY,
                  onClick: () {
                    setState(() {
                      _loopMode = LoopMode.DAILY;
                    });
                    setData();
                  },
                ),
                const SizedBox(width: 10),
                _textButton(
                  '매주',
                  width: 51,
                  isSelected: _loopMode == LoopMode.WEEKDAYSELECT,
                  onClick: () {
                    setState(() {
                      _loopMode = LoopMode.WEEKDAYSELECT;
                    });
                    setData();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: _durationPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateTimeWidget({
    required DateTime? startDateTime,
    required DateTime? endDateTime,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (startDateTime != null)
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Text(
                  DateFormat("yyyy년 M월 d일\nHH시 mm분").format(startDateTime),
                  style: AppTextStyles.size10Medium.copyWith(
                    height: 15 / 10,
                    color: const Color(0xFF5D7CFF),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (startDateTime != null)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  '부터',
                  style: AppTextStyles.size10Medium.copyWith(
                    height: 15 / 10,
                  ),
                ),
              ),
            if (endDateTime != null)
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Text(
                  DateFormat("yyyy년 M월 d일\nHH시 mm분").format(endDateTime),
                  style: AppTextStyles.size10Medium.copyWith(
                    height: 15 / 10,
                    color: const Color(0xFF5D7CFF),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (endDateTime != null)
              Text(
                '까지',
                style: AppTextStyles.size10Medium.copyWith(
                  height: 15 / 10,
                ),
              ),
          ],
        ),
        if (startDateTime != null || endDateTime != null)
          const SizedBox(height: 5),
        if (_loopMode != LoopMode.MANUAL)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              __weekCircle('월',
                  isSelected: _loopMode == LoopMode.DAILY
                      ? true
                      : _weekdays.contains(WeekDay.MONDAY)),
              const SizedBox(width: 2.37),
              __weekCircle('화',
                  isSelected: _loopMode == LoopMode.DAILY
                      ? true
                      : _weekdays.contains(WeekDay.TUESDAY)),
              const SizedBox(width: 2.37),
              __weekCircle('수',
                  isSelected: _loopMode == LoopMode.DAILY
                      ? true
                      : _weekdays.contains(WeekDay.WEDNESDAY)),
              const SizedBox(width: 2.37),
              __weekCircle('목',
                  isSelected: _loopMode == LoopMode.DAILY
                      ? true
                      : _weekdays.contains(WeekDay.THURSDAY)),
              const SizedBox(width: 2.37),
              __weekCircle('금',
                  isSelected: _loopMode == LoopMode.DAILY
                      ? true
                      : _weekdays.contains(WeekDay.FRIDAY)),
              const SizedBox(width: 2.37),
              __weekCircle('토',
                  isSelected: _loopMode == LoopMode.DAILY
                      ? true
                      : _weekdays.contains(WeekDay.SATURDAY)),
              const SizedBox(width: 2.37),
              __weekCircle('일',
                  isSelected: _loopMode == LoopMode.DAILY
                      ? true
                      : _weekdays.contains(WeekDay.SUNDAY)),
              const SizedBox(width: 31.79),
              Text(
                (_loopMode == LoopMode.DAILY)
                    ? '매일'
                    : _timeBoundEveryWeek[0] != null
                        ? DateFormat('aa hh:mm', 'ko')
                            .format(_timeBoundEveryWeek[0]!)
                        : '',
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
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_period.period.valueString}${_period.periodType}',
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
          )
      ],
    );
  }

  Widget _durationPage() {
    switch (_loopMode) {
      case LoopMode.MANUAL:
        return _customSubPage();
      case LoopMode.DAILY:
        return _everydaySubPage();
      default:
        return _everyWeekSubPage();
    }
  }

  Widget _customSubPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '반복',
          style: AppTextStyles.size14Medium.singleLine,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            EditorNumberTextField(
              enabled: true,
              controller: _customDurationNumberController,
              min: 1,
              max: 99,
              onChanged: (period) {
                setState(() {
                  _period = PeriodExpression(
                    _period.periodType,
                    LiteralExpression(period, literalType: LiteralType.INTEGER),
                  );
                });
                setData();
              },
            ),
            const SizedBox(width: 8),
            CustomDropDown<PeriodType>(
              selectedValue: _period.periodType,
              onChanged: (periodType) {
                if (periodType != null) {
                  setState(() {
                    _period = PeriodExpression(
                      periodType,
                      _period.period,
                    );
                  });
                  setData();
                }
              },
              items: PeriodType.enableList,
            ),
            const SizedBox(width: 8),
            Text(
              '마다',
              style: AppTextStyles.size12Regular.copyWith(letterSpacing: -0.36),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          '기간',
          style: AppTextStyles.size14Medium.singleLine,
        ),
        const SizedBox(height: 14),
        _textButton('시작시간', width: 65, isSelected: _enableStartDateTimeCustom,
            onClick: () {
          setState(() {
            _enableStartDateTimeCustom = !_enableStartDateTimeCustom;
          });
          setData();
        }),
        const SizedBox(height: 12),
        EditorDateButton(
          _timeBoundCustom[0],
          enabled: _enableStartDateTimeCustom,
          onClick: () async {
            final DateTime? selectedDateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: _lastDate,
            );
            setState(() {
              _timeBoundCustom[0] = selectedDateTime;
            });
            setData();
          },
        ),
        const SizedBox(height: 6),
        EditorSelectTimeWidget(
          enabled: _enableStartDateTimeCustom && _timeBoundCustom[0] != null,
          selectedTimePrefix: _timeBoundCustom[0]?.getAmPm ?? AmPm.am,
          onChangedTimePrefix: (amPm) {
            if (amPm != null) {
              setState(() {
                _timeBoundCustom[0] = _timeBoundCustom[0]!.copyWithAmPm(amPm);
              });
              setData();
            }
          },
          hourController: _customStartHourController,
          onChangedHour: (hour) {
            setState(() {
              _timeBoundCustom[0] = _timeBoundCustom[0]!.copyWith(hour: hour);
            });
            setData();
          },
          minuteController: _customStartMinuteController,
          onChangedMinute: (minute) {
            setState(() {
              _timeBoundCustom[0] =
                  _timeBoundCustom[0]!.copyWith(minute: minute);
            });
            setData();
          },
        ),
        const SizedBox(height: 24),
        _textButton('종료시간', width: 65, isSelected: _enableEndDateTimeCustom,
            onClick: () {
          setState(() {
            _enableEndDateTimeCustom = !_enableEndDateTimeCustom;
          });
          setData();
        }),
        const SizedBox(height: 12),
        EditorDateButton(
          _timeBoundCustom[1],
          enabled: _enableEndDateTimeCustom,
          onClick: () async {
            final DateTime? selectedDateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: _lastDate,
            );

            setState(() {
              _timeBoundCustom[1] = selectedDateTime;
            });
            setData();
          },
        ),
        const SizedBox(height: 6),
        EditorSelectTimeWidget(
          enabled: _enableEndDateTimeCustom && _timeBoundCustom[1] != null,
          selectedTimePrefix: _timeBoundCustom[1]?.getAmPm ?? AmPm.am,
          onChangedTimePrefix: (amPm) {
            if (amPm != null) {
              setState(() {
                _timeBoundCustom[1] = _timeBoundCustom[1]!.copyWithAmPm(amPm);
              });
              setData();
            }
          },
          hourController: _customEndHourController,
          onChangedHour: (hour) {
            setState(() {
              _timeBoundCustom[1] = _timeBoundCustom[1]!.copyWith(hour: hour);
            });
            setData();
          },
          minuteController: _customEndMinuteController,
          onChangedMinute: (minute) {
            setState(() {
              _timeBoundCustom[1] =
                  _timeBoundCustom[1]!.copyWith(minute: minute);
            });
            setData();
          },
        ),
      ],
    );
  }

  Widget _everydaySubPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기간',
          style: AppTextStyles.size14Medium.singleLine,
        ),
        const SizedBox(height: 14),
        _textButton('시작시간', width: 65, isSelected: _enableStartDateTimeEveryDay,
            onClick: () {
          setState(() {
            _enableStartDateTimeEveryDay = !_enableStartDateTimeEveryDay;
          });
          setData();
        }),
        const SizedBox(height: 12),
        EditorDateButton(
          _timeBoundEveryDay[0],
          enabled: _enableStartDateTimeEveryDay,
          onClick: () async {
            final DateTime? selectedDateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: _lastDate,
            );

            setState(() {
              _timeBoundEveryDay[0] = selectedDateTime;
            });
            setData();
          },
        ),
        const SizedBox(height: 6),
        EditorSelectTimeWidget(
          enabled:
              _enableStartDateTimeEveryDay && _timeBoundEveryDay[0] != null,
          selectedTimePrefix: _timeBoundEveryDay[0]?.getAmPm ?? AmPm.am,
          onChangedTimePrefix: (amPm) {
            if (amPm != null) {
              setState(() {
                _timeBoundEveryDay[0] =
                    _timeBoundEveryDay[0]!.copyWithAmPm(amPm);
              });
              setData();
            }
          },
          hourController: _everydayStartHourController,
          onChangedHour: (hour) {
            setState(() {
              _timeBoundEveryDay[0] =
                  _timeBoundEveryDay[0]!.copyWith(hour: hour);
            });
            setData();
          },
          minuteController: _everydayStartMinuteController,
          onChangedMinute: (minute) {
            setState(() {
              _timeBoundEveryDay[0] =
                  _timeBoundEveryDay[0]!.copyWith(minute: minute);
            });
            setData();
          },
        ),
        const SizedBox(height: 24),
        _textButton('종료시간', width: 65, isSelected: _enableEndDateTimeEveryDay,
            onClick: () {
          setState(() {
            _enableEndDateTimeEveryDay = !_enableEndDateTimeEveryDay;
          });
          setData();
        }),
        const SizedBox(height: 12),
        EditorDateButton(
          _timeBoundEveryDay[1],
          enabled: _enableEndDateTimeEveryDay,
          onClick: () async {
            final DateTime? selectedDateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: _lastDate,
            );

            setState(() {
              _timeBoundEveryDay[1] = selectedDateTime;
            });
            setData();
          },
        ),
        const SizedBox(height: 6),
        EditorSelectTimeWidget(
          enabled: _enableEndDateTimeEveryDay && _timeBoundEveryDay[1] != null,
          selectedTimePrefix: _timeBoundEveryDay[1]?.getAmPm ?? AmPm.am,
          onChangedTimePrefix: (amPm) {
            if (amPm != null) {
              setState(() {
                _timeBoundEveryDay[1] =
                    _timeBoundEveryDay[1]!.copyWithAmPm(amPm);
              });
              setData();
            }
          },
          hourController: _everydayEndHourController,
          onChangedHour: (hour) {
            setState(() {
              _timeBoundEveryDay[1] =
                  _timeBoundEveryDay[1]!.copyWith(hour: hour);
            });
            setData();
          },
          minuteController: _everydayEndMinuteController,
          onChangedMinute: (minute) {
            setState(() {
              _timeBoundEveryDay[1] =
                  _timeBoundEveryDay[1]!.copyWith(minute: minute);
            });
            setData();
          },
        ),
      ],
    );
  }

  Widget _everyWeekSubPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '시간',
          style: AppTextStyles.size14Medium.singleLine,
        ),
        const SizedBox(height: 12),
        _SelectDayWidget(
          selectWeekDay: (weekDay) {
            setState(() {
              if (_weekdays.contains(weekDay)) {
                _weekdays.remove(weekDay);
              } else {
                _weekdays.add(weekDay);
              }
            });
            setData();
          },
          selectedWeekdays: _weekdays,
        ),
        const SizedBox(height: 16),
        EditorSelectTimeWidget(
          enabled: true,
          selectedTimePrefix: _timeEveryWeek?.getAmPm ?? AmPm.am,
          onChangedTimePrefix: (amPm) {
            if (amPm != null) {
              setState(() {
                _timeEveryWeek =
                    _timeEveryWeek?.copyWithAmPm(amPm) ?? DateTime.now();
              });
              setData();
            }
          },
          hourController: _everyWeekHourController,
          onChangedHour: (hour) {
            setState(() {
              _timeEveryWeek =
                  _timeEveryWeek?.copyWith(hour: hour) ?? DateTime.now();
            });
            setData();
          },
          minuteController: _everyWeekMinuteController,
          onChangedMinute: (minute) {
            setState(() {
              _timeEveryWeek =
                  _timeEveryWeek?.copyWith(minute: minute) ?? DateTime.now();
            });
            setData();
          },
        ),
        const SizedBox(height: 30),
        Text(
          '기간',
          style: AppTextStyles.size14Medium.singleLine,
        ),
        const SizedBox(height: 16),
        _textButton('시작시간', width: 65, isSelected: _enableStartDateEveryWeek,
            onClick: () {
          setState(() {
            _enableStartDateEveryWeek = !_enableStartDateEveryWeek;
          });
          setData();
        }),
        const SizedBox(height: 12),
        EditorDateButton(
          _timeBoundEveryWeek[0],
          enabled: _enableStartDateEveryWeek,
          onClick: () async {
            final DateTime? selectedDateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: _lastDate,
            );

            setState(() {
              _timeBoundEveryWeek[0] = selectedDateTime;
            });
            setData();
          },
        ),
        const SizedBox(height: 20),
        _textButton('종료시간', width: 65, isSelected: _enableEndDateEveryWeek,
            onClick: () {
          setState(() {
            _enableEndDateEveryWeek = !_enableEndDateEveryWeek;
          });
          setData();
        }),
        const SizedBox(height: 12),
        EditorDateButton(
          _timeBoundEveryWeek[1],
          enabled: _enableEndDateEveryWeek,
          onClick: () async {
            final DateTime? selectedDateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: _lastDate,
            );

            setState(() {
              _timeBoundEveryWeek[1] = selectedDateTime;
            });
            setData();
          },
        ),
      ],
    );
  }

  Widget _textButton(
    String text, {
    required double width,
    required bool isSelected,
    VoidCallback? onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width,
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

  Widget __weekCircle(
    String week, {
    required bool isSelected,
  }) {
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
            color:
                isSelected ? const Color(0xFF5D7CFF) : const Color(0xFF3F424B),
          ),
        ),
      ),
    );
  }

  /// TODO: ConditionExpression 부분 나중에 실제 Clock 관련 태그로 바꿔야 하는지 확인 필요
  void setData() {
    late PeriodExpression periodExpression;
    ConditionExpression? conditionExpression;
    final timeBound = <DateTime?>[];
    var weekdays = <WeekDay>[];

    if (_loopMode == LoopMode.MANUAL) {
      periodExpression = _period;

      if (_enableStartDateTimeCustom) {
        if (_timeBoundCustom[0] != null) {
          conditionExpression = ConditionExpression(
            ValueServiceExpression('datetime', ['Clock'], RangeType.AUTO),
            LiteralExpression(
                _timeBoundCustom[0]!.millisecondsSinceEpoch ~/ 1000,
                literalType: LiteralType.INTEGER),
            false,
            Operator.GREATER_THAN,
          );
        }
        timeBound.add(_timeBoundCustom[0]);
      } else {
        timeBound.add(null);
      }

      if (_enableEndDateTimeCustom) {
        if (_timeBoundCustom[1] != null) {
          final rightExpression = ConditionExpression(
            ValueServiceExpression('datetime', ['Clock'], RangeType.AUTO),
            LiteralExpression(
                _timeBoundCustom[1]!.millisecondsSinceEpoch ~/ 1000,
                literalType: LiteralType.INTEGER),
            false,
            Operator.LESS_THAN,
          );

          if (conditionExpression == null) {
            conditionExpression = rightExpression;
          } else {
            conditionExpression = ConditionExpression(
              conditionExpression,
              rightExpression,
              false,
              Operator.AND,
            );
          }
        }

        timeBound.add(_timeBoundCustom[1]);
      } else {
        timeBound.add(null);
      }
    } else if (_loopMode == LoopMode.DAILY) {
      periodExpression = PeriodExpression(
        PeriodType.DAY,
        LiteralExpression(1, literalType: LiteralType.INTEGER),
      );

      if (_enableStartDateTimeEveryDay) {
        if (_timeBoundEveryDay[0] != null) {
          conditionExpression = ConditionExpression(
            ValueServiceExpression('datetime', ['Clock'], RangeType.AUTO),
            LiteralExpression(
                _timeBoundEveryDay[0]!.millisecondsSinceEpoch ~/ 1000,
                literalType: LiteralType.INTEGER),
            false,
            Operator.GREATER_THAN,
          );
        }
        timeBound.add(_timeBoundEveryDay[0]);
      } else {
        timeBound.add(null);
      }

      if (_enableEndDateTimeEveryDay) {
        if (_timeBoundEveryDay[1] != null) {
          final rightExpression = ConditionExpression(
            ValueServiceExpression('datetime', ['Clock'], RangeType.AUTO),
            LiteralExpression(
                _timeBoundEveryDay[1]!.millisecondsSinceEpoch ~/ 1000,
                literalType: LiteralType.INTEGER),
            false,
            Operator.LESS_THAN,
          );

          if (conditionExpression == null) {
            conditionExpression = rightExpression;
          } else {
            conditionExpression = ConditionExpression(
              conditionExpression,
              rightExpression,
              false,
              Operator.AND,
            );
          }
        }

        timeBound.add(_timeBoundEveryDay[1]);
      } else {
        timeBound.add(null);
      }
    } else {
      /// 요일을 고르게 되면 주기는 '1 DAY'가 되어야 한다.
      periodExpression = PeriodExpression(
        PeriodType.DAY,
        LiteralExpression(1, literalType: LiteralType.INTEGER),
      );
      weekdays = _weekdays;

      if (_enableStartDateEveryWeek) {
        if (_timeBoundEveryWeek[0] != null) {
          conditionExpression = ConditionExpression(
            ValueServiceExpression('datetime', ['Clock'], RangeType.AUTO),
            LiteralExpression(
                _timeBoundEveryWeek[0]!.millisecondsSinceEpoch ~/ 1000,
                literalType: LiteralType.INTEGER),
            false,
            Operator.GREATER_THAN,
          );
        }
        timeBound.add(_timeBoundEveryWeek[0]);
      } else {
        timeBound.add(null);
      }

      if (_enableEndDateEveryWeek) {
        if (_timeBoundEveryWeek[1] != null) {
          final rightExpression = ConditionExpression(
            ValueServiceExpression('datetime', ['Clock'], RangeType.AUTO),
            LiteralExpression(
                _timeBoundEveryWeek[1]!.millisecondsSinceEpoch ~/ 1000,
                literalType: LiteralType.INTEGER),
            false,
            Operator.LESS_THAN,
          );

          if (conditionExpression == null) {
            conditionExpression = rightExpression;
          } else {
            conditionExpression = ConditionExpression(
              conditionExpression,
              rightExpression,
              false,
              Operator.AND,
            );
          }
        }
        timeBound.add(_timeBoundEveryWeek[1]);
      } else {
        timeBound.add(null);
      }

      ConditionExpression? weekDayExpression;
      for (var weekday in weekdays) {
        if (weekDayExpression == null) {
          weekDayExpression = ConditionExpression(
            ValueServiceExpression('weekday', ['Clock'], RangeType.AUTO),
            LiteralExpression(weekday.value, literalType: LiteralType.STRING),
            false,
            Operator.EQUAL,
          );
        } else {
          weekDayExpression = ConditionExpression(
            weekDayExpression,
            ConditionExpression(
              ValueServiceExpression('weekday', ['Clock'], RangeType.AUTO),
              LiteralExpression(weekday.value, literalType: LiteralType.STRING),
              false,
              Operator.EQUAL,
            ),
            false,
            Operator.OR,
          );
        }
      }
      if (weekDayExpression != null) {
        if (conditionExpression == null) {
          conditionExpression = weekDayExpression;
        } else {
          conditionExpression = ConditionExpression(
            conditionExpression,
            weekDayExpression,
            false,
            Operator.AND,
          );
        }
      }

      if (_timeEveryWeek != null) {
        final timeExpression1 = ConditionExpression(
          ValueServiceExpression('time', ['Clock'], RangeType.AUTO),
          LiteralExpression(
              _timeEveryWeek!.hour * 10000 + _timeEveryWeek!.minute * 100,
              literalType: LiteralType.INTEGER),
          false,
          Operator.GREATER_THAN,
        );
        final timeExpression2 = ConditionExpression(
          ValueServiceExpression('time', ['Clock'], RangeType.AUTO),
          LiteralExpression(
              _timeEveryWeek!.hour * 10000 + _timeEveryWeek!.minute * 100 + 100,
              literalType: LiteralType.INTEGER),
          false,
          Operator.LESS_THAN,
        );
        final timeExpression = ConditionExpression(
          timeExpression1,
          timeExpression2,
          false,
          Operator.AND,
        );

        if (conditionExpression == null) {
          conditionExpression = timeExpression;
        } else {
          conditionExpression = ConditionExpression(
            conditionExpression,
            timeExpression,
            false,
            Operator.AND,
          );
        }
      }
    }

    widget.onUpdateBlock(LoopBlock(
      periodExpression,
      conditionExpression,
      _loopMode,
      timeBound,
      weekdays,
    ));
  }
}

class _SelectDayWidget extends StatelessWidget {
  final List<WeekDay> selectedWeekdays;
  final void Function(WeekDay weekDay) selectWeekDay;

  const _SelectDayWidget({
    required this.selectedWeekdays,
    required this.selectWeekDay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          WeekDay.enableList.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              right: index == WeekDay.enableList.length - 1 ? 0 : 4,
            ),
            child: _weekCircle(
              WeekDay.enableList[index].toWeekDayShortString,
              isSelected: selectedWeekdays.contains(WeekDay.enableList[index]),
              onClick: () => selectWeekDay(WeekDay.enableList[index]),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          '에',
          style: AppTextStyles.size12Regular,
        ),
      ],
    );
  }

  Widget _weekCircle(
    String week, {
    required bool isSelected,
    required VoidCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            width: 1,
            color:
                isSelected ? const Color(0xFF5D7CFF) : const Color(0xFFE9ECF5),
          ),
        ),
        child: Center(
          child: Text(
            week,
            style: AppTextStyles.custom(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: isSelected
                  ? const Color(0xFF5D7CFF)
                  : const Color(0xFF3F424B),
            ),
          ),
        ),
      ),
    );
  }
}
