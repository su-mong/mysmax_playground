import 'package:fast_equatable/fast_equatable.dart';
import 'package:flutter/material.dart';
import 'package:mysmax_playground/core/scenario_code_parser/variable.dart';
import 'package:mysmax_playground/models/function_argument.dart';

import '../../models/thing_function.dart';
import 'enums.dart';
import 'expression.dart';
import 'utils.dart';

abstract class Block with FastEquatable {
  int uid = UniqueKey().hashCode;
  BlockType blockType = BlockType.UNDEFINED;
  bool isNestable;
  List<Block> blocks = [];
  int level = 0;

  Block(this.blockType, this.isNestable, {blocks}) {
    if (blocks != null) {
      this.blocks = blocks;
    }
  }

  void searchLevel(int level) {
    this.level = level;
    for (Block block in blocks) {
      block.searchLevel(level + 1);
    }
  }

  void addBlock(Block block) {
    blocks.add(block);
  }

  bool addChild(Block parent, Block child) {
    if (uid == parent.uid) {
      List<Block> changedBlocks = List<Block>.from(blocks);
      changedBlocks.add(child);
      blocks = changedBlocks;
      return true;
    } else {
      bool blocksResult = false;
      for (Block block in blocks) {
        bool result = block.addChild(parent, child);
        if (result) {
          blocksResult = true;
        }
      }
      return blocksResult;
    }
  }

  bool addSameLevel(Block currentBlock, Block newBlock) {
    int index = blocks.indexWhere((element) => element.uid == currentBlock.uid);
    if (index != -1) {
      blocks.insert(index + 1, newBlock);
      return true;
    } else {
      for (Block block in blocks) {
        bool result = block.addSameLevel(currentBlock, newBlock);
        if (result) {
          return true;
        }
      }
      return false;
    }
  }

  bool removeBlock(Block block) {
    if (blocks.any((element) => element.uid == block.uid)) {
      blocks.removeWhere((element) => element.uid == block.uid);
      return true;
    } else {
      bool result = false;
      for (Block b in blocks) {
        bool blockResult = b.removeBlock(block);
        if (blockResult) {
          result = true;
        }
      }
      return result;
    }
  }

  List<String> getVariableNames(
      {Block? currentBlock, bool includeCurrentBlock = false}) {
    List<String> variableNames = [];

    for (Block block in blocks) {
      if (currentBlock != null && block.uid == currentBlock.uid) {
        if (includeCurrentBlock) {
          if (block is FunctionServiceBlock) {
            // FunctionServiceReturnType
            if (block.variableName != null) {
              variableNames.add(block.variableName!);
            }
          } else if (block is ValueServiceBlock) {
            if (block.variableName != null) {
              variableNames.add(block.variableName!);
            }
          }
        }
        break;
      }

      if (block is FunctionServiceBlock) {
        if (block.variableName != null) {
          variableNames.add(block.variableName!);
        }
      } else if (block is ValueServiceBlock) {
        if (block.variableName != null) {
          variableNames.add(block.variableName!);
        }
      }

      variableNames.addAll(block.getVariableNames(
          currentBlock: currentBlock,
          includeCurrentBlock: includeCurrentBlock));
    }

    return variableNames;
  }

  List<Variable> getVariablesWithNameAndType(
      {Block? currentBlock, bool includeCurrentBlock = false}) {
    List<Variable> variables = [];

    for (Block block in blocks) {
      if (currentBlock != null && block.uid == currentBlock.uid) {
        if (includeCurrentBlock) {
          if (block is FunctionServiceBlock) {
            // FunctionServiceReturnType
            if (block.variableName != null) {
              variables.add(
                Variable.fromFunctionService(
                    block.variableName!, block.functionServiceReturnType),
              );
            }
          } else if (block is ValueServiceBlock) {
            if (block.variableName != null) {
              variables.add(Variable.fromValueService(block.variableName!));
            }
          }
        }
        break;
      }

      if (block is FunctionServiceBlock) {
        if (block.variableName != null) {
          variables.add(
            Variable.fromFunctionService(
                block.variableName!, block.functionServiceReturnType),
          );
        }
      } else if (block is ValueServiceBlock) {
        if (block.variableName != null) {
          variables.add(Variable.fromValueService(block.variableName!));
        }
      }

      variables.addAll(block.getVariablesWithNameAndType(
          currentBlock: currentBlock,
          includeCurrentBlock: includeCurrentBlock));
    }

    return variables;
  }

  String toScenarioCode();
  bool isValid();
  bool updateBlock(Block currentBlock, Block changedBlock);
  Block copyWith(Block block);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [uid];
}

extension BlockExtension on Block {
  Color getColor() =>
      const Color(0xFF5D7CFF); // colorDepth[(level - 1) % colorDepth.length];
  int getLeftPadding() => level < 1 ? 0 : 2 + 4 * (level - 1);
  Border? get blockBorder => level < 2
      ? null
      : Border(
          left: BorderSide(
            width: 2 + 4 * (level - 2),
            color: const Color(0xFF5D7CFF),
          ),
        );
}

class RootBlock extends Block {
  RootBlock({blocks}) : super(BlockType.ROOT, true, blocks: blocks);

  @override
  String toScenarioCode() {
    String code = '';

    for (Block block in blocks) {
      code += '${block.toScenarioCode()}\n';
    }

    return indent(code, level).trim();
  }

  @override
  bool isValid() {
    // recursively check is valid
    for (Block block in blocks) {
      if (!block.isValid()) {
        return false;
      }
    }

    return true;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = currentBlock.copyWith(changedBlock);
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  RootBlock copyWith(Block block) {
    RootBlock newBlock = block as RootBlock;
    return RootBlock(
      blocks: newBlock.blocks,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

class DummyBlock extends Block {
  DummyBlock() : super(BlockType.UNDEFINED, false);

  @override
  String toScenarioCode() {
    String code = '';

    return indent(code, level);
  }

  @override
  bool isValid() {
    return false;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    return false;
  }

  @override
  DummyBlock copyWith(Block block) {
    DummyBlock newBlock = block as DummyBlock;
    return newBlock;
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

class LoopBlock extends Block {
  PeriodExpression? period;
  ConditionExpression? condition;
  LoopMode loopMode = LoopMode.UNDEFINED;
  List<DateTime?> timeBound = [];
  List<WeekDay> weekdays = [];

  LoopBlock(
      this.period, this.condition, this.loopMode, this.timeBound, this.weekdays,
      {blocks})
      : super(BlockType.LOOP, true, blocks: blocks);
  factory LoopBlock.empty() => LoopBlock(
        PeriodExpression(PeriodType.DAY,
            LiteralExpression(1, literalType: LiteralType.INTEGER)),
        null,
        LoopMode.MANUAL,
        [],
        [],
      );

  static LoopBlock parse(String line) {
    PeriodExpression period;
    ConditionExpression? condition;
    LoopMode loopMode = LoopMode.UNDEFINED;
    List<DateTime?> timeBound = [];
    List<WeekDay> weekdays = [];

    RegExp pattern = RegExp(r'loop\s*\((.*)\)');
    Match? match = pattern.firstMatch(line);

    String loopContent = '';
    String? conditionContent;
    String? periodContent;

    if (match == null) {
      throw Exception('Invalid block line - No loop content');
    }

    loopContent = match.group(1)!;
    periodContent = loopContent.split(',')[0].trim();
    conditionContent = loopContent.split(',').length > 1
        ? loopContent.split(',')[1].trim()
        : null;
    period = PeriodExpression.parse(periodContent);
    if (conditionContent != null) {
      condition = ConditionExpression.parse(conditionContent);
    } else {
      condition = null;
      loopMode = getLoopMode(weekdays, period);
      return LoopBlock(period, condition, loopMode, timeBound, weekdays);
    }

    if (!condition.isHaveTimeCondition()) {
      throw Exception('Invalid time condition in loop block');
    }

    timeBound = getTimeBound(condition);
    weekdays = getWeekdays(condition);
    loopMode = getLoopMode(weekdays, period);

    return LoopBlock(period, condition, loopMode, timeBound, weekdays);
  }

  @override
  String toScenarioCode() {
    String code = '';

    if (period == null && condition == null) {
      throw Exception('Invalid LoopBlock');
    }

    if (period != null && condition != null) {
      code =
          'loop(${period!.toScenarioCode()}, ${condition!.toScenarioCode()}) {\n';
    } else if (period != null) {
      code = 'loop(${period!.toScenarioCode()}) {\n';
    } else if (condition != null) {
      code = 'loop(${condition!.toScenarioCode()}) {\n';
    }

    for (Block block in blocks) {
      code += '${block.toScenarioCode()}\n';
    }

    code += '}\n';

    return indent(code, level - 1);
  }

  @override
  bool isValid() {
    if (period == null && condition == null) {
      return false;
    }

    if (loopMode == LoopMode.UNDEFINED) {
      return false;
    }

    if (loopMode == LoopMode.WEEKDAYSELECT && weekdays.isEmpty) {
      return false;
    }

    if (condition != null && !condition!.isHaveTimeCondition()) {
      return false;
    }

    if (period != null && period!.periodType == PeriodType.UNDEFINED) {
      return false;
    }

    // recursively check is valid
    for (Block block in blocks) {
      if (!block.isValid()) {
        return false;
      }
    }

    return true;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      period = (changedBlock as LoopBlock).period;
      condition = changedBlock.condition;

      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  LoopBlock copyWith(Block block) {
    LoopBlock newBlock = block as LoopBlock;
    return LoopBlock(
      newBlock.period,
      newBlock.condition,
      newBlock.loopMode,
      newBlock.timeBound,
      newBlock.weekdays,
      blocks: newBlock.blocks.isEmpty ? blocks : newBlock.blocks,
    );
  }

  static List<DateTime?> getTimeBound(ConditionExpression condition) {
    List<ConditionExpression> timeBounds = [];

    void getTimeBoundHelper(ConditionExpression condition) {
      if (!condition.isHaveTimeCondition()) {
        throw Exception('Invalid time condition');
      }

      for (Expression expression in [
        condition.leftExpression,
        condition.rightExpression
      ]) {
        if (expression is ConditionExpression) {
          getTimeBoundHelper(expression);
        } else {
          continue;
        }

        // ignore: unnecessary_type_check
        if (expression is! ConditionExpression) continue;
        ConditionExpression condExpr = expression;

        bool isValueService =
            condExpr.leftExpression is ValueServiceExpression &&
                ((condExpr.leftExpression as ValueServiceExpression)
                    .tags
                    .contains('clock'));
        bool isLiteral = condExpr.rightExpression is LiteralExpression;

        if ((isValueService && isLiteral) || (isValueService && isLiteral)) {
          timeBounds.add(condExpr);
        }
      }
    }

    DateTime? getDateTimeHelper(List<ConditionExpression> conditions) {
      int date = 0;
      int time = 0;

      for (ConditionExpression cond in conditions) {
        TimeServiceType timeServiceType = cond.getTimeServiceType();
        int timeLiteral = cond.getTimeLiteral();

        switch (timeServiceType) {
          case TimeServiceType.DATETIME:
            time = timeLiteral % 10000;
            date = timeLiteral ~/ 10000;
            break;
          case TimeServiceType.DATE:
            date = timeLiteral;
            break;
          case TimeServiceType.TIME:
            time = timeLiteral;
            break;
          default:
            throw Exception('Invalid time condition');
        }
      }

      if (date == 0) {
        return null;
      } else {
        return DateTime(date ~/ 10000, (date % 10000) ~/ 100, date % 100,
            time ~/ 100, time % 100, 0, 0, 0);
      }
    }

    getTimeBoundHelper(condition);

    List<ConditionExpression> startConditions = [];
    List<ConditionExpression> endConditions = [];

    for (ConditionExpression cond in timeBounds) {
      if (cond.operator == Operator.GREATER_THAN_OR_EQUAL) {
        startConditions.add(cond);
      } else if (cond.operator == Operator.LESS_THAN_OR_EQUAL) {
        endConditions.add(cond);
      }
    }

    DateTime? startDateTime = getDateTimeHelper(startConditions);
    DateTime? endDateTime = getDateTimeHelper(endConditions);

    return [startDateTime, endDateTime];
  }

  static List<WeekDay> getWeekdays(ConditionExpression condition) {
    List<WeekDay> weekdays = [];

    void extractWeekdays(Expression expression) {
      if (expression is ConditionExpression &&
          expression.leftExpression is ConditionExpression &&
          expression.rightExpression is ConditionExpression) {
        extractWeekdays(expression.leftExpression);
        extractWeekdays(expression.rightExpression);
      } else {
        expression as ConditionExpression;
      }

      if ((expression.leftExpression is ValueServiceExpression &&
              (expression.leftExpression as ValueServiceExpression)
                      .serviceName ==
                  "weekday" &&
              expression.rightExpression is LiteralExpression &&
              expression.operator == Operator.EQUAL) ||
          (expression.rightExpression is ValueServiceExpression &&
              (expression.rightExpression as ValueServiceExpression)
                      .serviceName ==
                  "weekday" &&
              expression.leftExpression is LiteralExpression &&
              expression.operator == Operator.EQUAL)) {
        LiteralExpression weekDayExpression =
            (expression.leftExpression is LiteralExpression
                ? expression.leftExpression
                : expression.rightExpression);
        WeekDay weekDay = WeekdayExtension.fromString(weekDayExpression.value);
        if (!weekdays.contains(weekDay)) weekdays.add(weekDay);
      }
    }

    extractWeekdays(condition);
    return weekdays;
  }

  static LoopMode getLoopMode(List<WeekDay> weekdays, PeriodExpression period) {
    if (period.periodType == PeriodType.DAY && period.period.value == 7) {
      return LoopMode.WEEKLY;
    } else if (period.periodType == PeriodType.DAY &&
        period.period.value == 1) {
      return LoopMode.DAILY;
    } else if (period.periodType == PeriodType.DAY &&
        (period.period.value > 0 && period.period.value < 7)) {
      return LoopMode.WEEKDAYSELECT;
    } else {
      return LoopMode.MANUAL;
    }
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

class IfBlock extends Block {
  ConditionExpression condition;

  IfBlock(this.condition, {blocks}) : super(BlockType.IF, true, blocks: blocks);

  static IfBlock parse(String line) {
    RegExp pattern = RegExp(r'if\s*\((.*)\)');
    Match? match = pattern.firstMatch(line);

    if (match == null) {
      throw Exception('Invalid block line');
    }

    String conditionContent = match.group(1)!;
    ConditionExpression condition = ConditionExpression.parse(conditionContent);

    return IfBlock(condition);
  }

  @override
  String toScenarioCode() {
    String code = 'if(${condition.toScenarioCode()}) {\n';

    for (Block block in blocks) {
      code += '${block.toScenarioCode()}\n';
    }

    code += '}';

    return indent(code, level - 1);
  }

  @override
  bool isValid() {
    // left and right expressions should be ConditionExpression, LiteralExpression, ValueService
    if (condition.leftExpression is! ConditionExpression &&
        condition.leftExpression is! LiteralExpression &&
        condition.leftExpression is! ValueServiceExpression) {
      return false;
    }

    if (condition.rightExpression is! ConditionExpression &&
        condition.rightExpression is! LiteralExpression &&
        condition.rightExpression is! ValueServiceExpression) {
      return false;
    }

    if (condition.leftExpression is ConditionExpression &&
        condition.rightExpression is ConditionExpression &&
        condition.operator == Operator.UNDEFINED) {
      return false;
    }

    // recursively check is valid
    for (Block block in blocks) {
      if (!block.isValid()) {
        return false;
      }
    }

    return true;
  }

  List<Operator> getOperators() {
    List<Operator> operators = [];
    var expression = condition;
    if (expression.leftExpression is ConditionExpression) {
      var leftExpression = expression.leftExpression as ConditionExpression;
      var childOperator = leftExpression.operator;
      operators.add(childOperator);
    } else {
      var leftExpression = expression.leftExpression as dynamic;
      operators.add(expression.operator);
    }
    return operators;
  }

  /// 현재 표현식에 AND나 OR이 있는지 찾아서 리턴. 없으면 null 리턴.
  /// (중요 : UI상 표현식에는 AND만 들어가거나 OR만 들어갈 수 있기 때문에, 리스트가 아닌 맨 첫 번째 Operator만 리턴한다.)
  Operator? getAndOrOperator() {
    List<Operator> operators = getOperators();
    return operators
        .where(
            (operator) => operator == Operator.AND || operator == Operator.OR)
        .firstOrNull;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      condition = (changedBlock as IfBlock).condition;
      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  IfBlock copyWith(Block block) {
    IfBlock newBlock = block as IfBlock;
    return IfBlock(
      newBlock.condition,
      blocks: newBlock.blocks.isEmpty ? blocks : newBlock.blocks,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

class ElseBlock extends Block {
  ElseBlock({blocks}) : super(BlockType.ELSE, true, blocks: blocks);

  static ElseBlock parse(String line) {
    return ElseBlock();
  }

  @override
  String toScenarioCode() {
    String code = 'else {\n';

    for (Block block in blocks) {
      code += '${block.toScenarioCode()}\n';
    }

    code += '}';

    return indent(code, level - 1);
  }

  bool isValid() {
    // recursively check is valid
    for (Block block in blocks) {
      if (!block.isValid()) {
        return false;
      }
    }

    return true;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  ElseBlock copyWith(Block block) {
    ElseBlock newBlock = block as ElseBlock;
    return ElseBlock(
      blocks: newBlock.blocks.isEmpty ? blocks : newBlock.blocks,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

class WaitUntilBlock extends Block {
  PeriodExpression? period;
  ConditionExpression? condition;

  WaitUntilBlock(this.period, this.condition, {blocks})
      : super(BlockType.WAIT_UNTIL, false, blocks: blocks);

  static WaitUntilBlock parse(String line) {
    PeriodExpression? period;
    ConditionExpression? condition;

    RegExp pattern = RegExp(r'\((.*)\)');
    RegExpMatch? matches = pattern.firstMatch(line);

    if (matches != null && matches.groupCount == 1) {
      String content = matches.group(1)!;

      try {
        period = PeriodExpression.parse(content);
        return WaitUntilBlock(period, condition);
      } catch (_) {
        condition = ConditionExpression.parse(content);
        return WaitUntilBlock(period, condition);
      }
    } else {
      throw FormatException('Invalid format for WaitUntilBlock: $line');
    }
  }

  @override
  String toScenarioCode() {
    String code = '';

    if (period == null && condition == null) {
      throw Exception('Invalid WaitUntilBlock');
    }

    if (period != null) {
      code = 'wait until(${period!.toScenarioCode()})';
    } else {
      code = 'wait until(${condition!.toScenarioCode()})';
    }

    return indent(code, level - 1);
  }

  @override
  bool isValid() {
    if (period == null && condition == null) {
      return false;
    }

    if (period != null && period!.periodType == PeriodType.UNDEFINED) {
      return false;
    }

    if (condition != null && !condition!.isHaveTimeCondition()) {
      return false;
    }

    return true;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      period = (changedBlock as WaitUntilBlock).period;
      condition = changedBlock.condition;
      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  WaitUntilBlock copyWith(Block block) {
    WaitUntilBlock newBlock = block as WaitUntilBlock;
    return WaitUntilBlock(
      newBlock.period,
      newBlock.condition,
      blocks: newBlock.blocks.isEmpty ? blocks : newBlock.blocks,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

class ValueServiceBlock extends Block {
  ValueServiceExpression valueServiceExpression;
  String? variableName;

  ValueServiceBlock(this.valueServiceExpression, this.variableName, {blocks})
      : super(BlockType.VALUE_SERVICE, false, blocks: blocks);

  static ValueServiceBlock parse(String line) {
    // Initialize default values
    ValueServiceExpression valueServiceExpression;
    String? variableName;

    // Check for a variable assignment
    if (line.contains(' = ')) {
      List<String> parts = line.split(' = ');
      variableName = parts[0].trim();
      line = parts[1].trim();
    }

    valueServiceExpression = ValueServiceExpression.parse(line);

    return ValueServiceBlock(valueServiceExpression, variableName);
  }

  @override
  String toScenarioCode() {
    String code = '';

    if (variableName != null) {
      code += '$variableName = ';
    }

    code += valueServiceExpression.toScenarioCode();

    return indent(code, level - 1);
  }

  @override
  bool isValid() {
    if (valueServiceExpression.serviceName.isEmpty) {
      return false;
    }

    if (valueServiceExpression.tags.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      valueServiceExpression =
          (changedBlock as ValueServiceBlock).valueServiceExpression;
      variableName = changedBlock.variableName;
      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  ValueServiceBlock copyWith(Block block) {
    ValueServiceBlock newBlock = block as ValueServiceBlock;
    return ValueServiceBlock(
      newBlock.valueServiceExpression,
      newBlock.variableName,
      blocks: newBlock.blocks.isEmpty ? blocks : newBlock.blocks,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

class FunctionServiceBlock extends Block {
  String serviceName;
  List<String> tags;
  FunctionServiceReturnType functionServiceReturnType;
  List<LiteralExpression> arguments;
  String? variableName;
  RangeType rangeType;

  FunctionServiceBlock(
      this.serviceName,
      this.tags,
      this.functionServiceReturnType,
      this.arguments,
      this.variableName,
      this.rangeType,
      {blocks})
      : super(BlockType.FUNCTION_SERVICE, false, blocks: blocks);

  static FunctionServiceBlock parse(String line) {
    // Initialize default values
    String? variableName;
    String serviceName = '';
    List<String> tags = [];
    List<LiteralExpression> arguments = [];
    RangeType rangeType = RangeType.AUTO; // Default to AUTO unless specified
    FunctionServiceReturnType functionServiceReturnType =
        FunctionServiceReturnType.UNDEFINED;

    // Check for a variable assignment
    if (line.contains(' = ')) {
      List<String> parts = line.split(' = ');
      variableName = parts[0].trim();
      line = parts[1].trim();
    }

    // Check for range type and remove it from line if present
    if (line.startsWith('all(')) {
      rangeType = RangeType.ALL;
      line = line.replaceAll('all', '').trim();
    } else if (line.startsWith('(')) {
      rangeType = RangeType.AUTO;
    } else {
      throw FormatException('Invalid format for FunctionServiceBlock: $line');
    }

    RegExp pattern = RegExp(r'\((#.*?)\)\.(\w+)\((.*?)\)');
    RegExpMatch? matches = pattern.firstMatch(line);

    if (matches != null && matches.groupCount == 3) {
      tags = matches.group(1)!.split(' ').map((t) => t.substring(1)).toList();
      serviceName = matches.group(2)!;
      arguments = matches
          .group(3)!
          .split(',')
          .map((arg) => arg.trim())
          .map((value) => LiteralExpression.parse(value))
          .toList();

      return FunctionServiceBlock(serviceName, tags, functionServiceReturnType,
          arguments, variableName, rangeType);
    } else {
      throw FormatException('Invalid format for FunctionServiceBlock: $line');
    }
  }

  @override
  String toScenarioCode() {
    String code = '';

    if (variableName != null) {
      code += '$variableName = ';
    }

    if (rangeType == RangeType.ALL) {
      code += 'all';
    }

    code +=
        '(${tags.map((item) => '#$item').join(' ')}).$serviceName(${arguments.map((arg) => arg.toScenarioCode()).join(", ")})';

    return indent(code, level - 1);
  }

  @override
  bool isValid() {
    if (serviceName.isEmpty) {
      return false;
    }

    if (tags.isEmpty) {
      return false;
    }

    if (arguments.any((arg) => !arg.isValid())) {
      return false;
    }

    return true;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      serviceName = (changedBlock as FunctionServiceBlock).serviceName;
      tags = changedBlock.tags;
      functionServiceReturnType = changedBlock.functionServiceReturnType;
      arguments = changedBlock.arguments;
      variableName = changedBlock.variableName;
      rangeType = changedBlock.rangeType;
      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  FunctionServiceBlock copyWith(Block block) {
    FunctionServiceBlock newBlock = block as FunctionServiceBlock;
    return FunctionServiceBlock(
      newBlock.serviceName,
      newBlock.tags,
      newBlock.functionServiceReturnType,
      newBlock.arguments,
      newBlock.variableName,
      newBlock.rangeType,
      blocks: newBlock.blocks.isEmpty ? blocks : newBlock.blocks,
    );
  }

  factory FunctionServiceBlock.fromService(ThingFunction function) {
    return FunctionServiceBlock(
      function.name,
      function.tags?.map((e) => e.name).toList() ?? [],
      function.return_type.toFunctionServiceReturnType,
      function.arguments?.map((e) => e.toLiteralExpression).toList() ?? [],
      '',
      RangeType.AUTO,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

/// 작성자: 우수몽
/// FunctionServiceBlock 여러 개를 순서대로 리스트로 저장하는 블록. 바뀐 UI에 대응하기 위해 추가했다.
class FunctionServiceListBlock extends Block {
  List<FunctionServiceBlock> children;
  FunctionServiceListBlock(
    this.children,
  ) : super(BlockType.SERVICES, false);

  @override
  String toScenarioCode() {
    String code = '';

    for (int i = 0; i < children.length; i++) {
      code += children[i].toScenarioCode();

      if (i != children.length - 1) {
        code += '\n';
      }
    }

    return indent(code, level - 1);
  }

  @override
  bool isValid() {
    if (children.isEmpty) {
      return false;
    }
    for (FunctionServiceBlock child in children) {
      if (!child.isValid()) {
        return false;
      }
    }
    return true;
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      children = (changedBlock as FunctionServiceListBlock).children;
      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Block copyWith(Block block) {
    final newBlock = block as FunctionServiceListBlock;
    return FunctionServiceListBlock(newBlock.children);
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}

/// 작성자: 우수몽
/// IfBlock + WaitUntilBlock 둘 중 하나를 보여주기 위한 용도.
/// ScenarioEditor에서 사용하기 위한 것이다.
/// NOTE : 두 하위 블럭들(IfBlock, WaitUntilBlock)은 ConditionBlock의 blocks를 똑같이 가지고 있어야 한다.
///        (즉, ConditionBlock의 blocks 값이 바뀐다면 ifBlock의 blocks와 waitUntilBlock의 blocks도 바뀌어야 한다.)
/// NOTE : 사실 WaitUntilBlock의 blocks는 따로 해석용으로 쓰이진 않고 있다. 다만 상태유지를 위해선 blocks도 같이 관리하는 게 맞아 보인다.
enum ConditionBlockState { none, ifElse, waitUntil }

class ConditionBlock extends Block {
  ConditionBlockState state;
  IfBlock ifBlock;
  WaitUntilBlock waitUntilBlock;

  /// private constructor를 쓴 이유 : blocks 상태 관리를 위해서. factory 패턴으로 연 생성자에서는 blocks 관련 처리 로직이 따로 들어가 있다.
  ConditionBlock({
    required this.state,
    required this.ifBlock,
    required this.waitUntilBlock,
    blocks,
  }) : super(BlockType.CONDITION, true, blocks: blocks);

  factory ConditionBlock.ifBlock(IfBlock ifBlock) => ConditionBlock(
        state: ConditionBlockState.ifElse,
        ifBlock: ifBlock,
        waitUntilBlock: WaitUntilBlock(
          PeriodExpression(PeriodType.SEC,
              LiteralExpression(1, literalType: LiteralType.INTEGER)),
          ConditionExpression(
            null,
            null,
            false,
            Operator.EQUAL,
          ),
        ),
      );

  factory ConditionBlock.waitUntilBlock(WaitUntilBlock waitUntilBlock) =>
      ConditionBlock(
        state: ConditionBlockState.waitUntil,
        ifBlock: IfBlock(
          ConditionExpression(
            null,
            null,
            false,
            Operator.EQUAL,
          ),
        ),
        waitUntilBlock: waitUntilBlock,
      );

  factory ConditionBlock.empty() => ConditionBlock(
        state: ConditionBlockState.none,
        ifBlock: IfBlock(
          ConditionExpression(
            null,
            null,
            false,
            Operator.EQUAL,
          ),
        ),
        waitUntilBlock: WaitUntilBlock(
          PeriodExpression(PeriodType.SEC,
              LiteralExpression(1, literalType: LiteralType.INTEGER)),
          ConditionExpression(
            null,
            null,
            false,
            Operator.EQUAL,
          ),
        ),
      );

  /// 아래의 [copyWith] 메서드의 param을 위한 factory.
  factory ConditionBlock.forCopy({
    required ConditionBlockState state,
    required IfBlock ifBlock,
    required WaitUntilBlock waitUntilBlock,
  }) =>
      ConditionBlock(
        state: state,
        ifBlock: ifBlock,
        waitUntilBlock: waitUntilBlock,
      );

  @override
  String toScenarioCode() {
    switch (state) {
      case ConditionBlockState.none:
        return '';
      case ConditionBlockState.ifElse:
        String code = 'if(${ifBlock.condition.toScenarioCode()}) {\n';

        for (Block block in blocks) {
          code += '${block.toScenarioCode()}\n';
        }

        code += '}';

        return indent(code, level - 1);
      case ConditionBlockState.waitUntil:
        String code = '';

        if (waitUntilBlock.period == null && waitUntilBlock.condition == null) {
          throw Exception('Invalid WaitUntilBlock');
        }

        if (waitUntilBlock.period != null) {
          code = 'wait until(${waitUntilBlock.period!.toScenarioCode()})';
        } else {
          code = 'wait until(${waitUntilBlock.condition!.toScenarioCode()})';
        }

        if (blocks.isNotEmpty) {
          code += '\n';
        }
        for (Block block in blocks) {
          code += '${block.toScenarioCode()}\n';
        }

        return indent(code, level - 1);
    }
  }

  @override
  bool isValid() {
    switch (state) {
      case ConditionBlockState.none:
        return true;
      case ConditionBlockState.ifElse:
        return ifBlock.isValid();
      case ConditionBlockState.waitUntil:
        return waitUntilBlock.isValid();
    }
  }

  @override
  bool updateBlock(Block currentBlock, Block changedBlock) {
    if (uid == currentBlock.uid) {
      state = (changedBlock as ConditionBlock).state;
      ifBlock = changedBlock.ifBlock;
      waitUntilBlock = changedBlock.waitUntilBlock;
      return true;
    }
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i].uid == currentBlock.uid) {
        blocks[i] = changedBlock;
        return true;
      } else {
        bool result = blocks[i].updateBlock(currentBlock, changedBlock);
        if (result) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  ConditionBlock copyWith(Block block) {
    final newBlock = block as ConditionBlock;
    return ConditionBlock(
      state: newBlock.state,
      ifBlock: newBlock.ifBlock,
      waitUntilBlock: newBlock.waitUntilBlock,
      blocks: newBlock.blocks.isEmpty ? blocks : newBlock.blocks,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters {
    super.hashParameters;
    return [uid];
  }
}
