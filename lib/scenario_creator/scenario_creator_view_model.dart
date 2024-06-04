import 'package:flutter/material.dart';
import 'package:mysmax_playground/core/scenario_code_parser/block.dart';
import 'package:mysmax_playground/core/scenario_code_parser/expression.dart';
import 'package:mysmax_playground/core/scenario_code_parser/scenario_code_parser.dart';
import 'package:mysmax_playground/models/scenario.dart';
import 'package:mysmax_playground/scenario_mixin.dart';

// Creator와 Creator가 나눠져야 함
// 지금은 ScenarioCreator가 Creator 역할을 하고 있음
class ScenarioCreatorViewModel extends ChangeNotifier with ScenarioMixin {
  IfBlock? _ifBlock;
  WaitUntilBlock? _waitUntilBlock;
  FunctionServiceListBlock? _functionServiceListBlock;
  LoopBlock? _loopBlock;
  ElseBlock? _elseBlock;
  ElseBlock? get elseBlock => _elseBlock;
  set elseBlock(ElseBlock? block) {
    _elseBlock = block;
    notifyListeners();
  }

  FunctionServiceListBlock? _elseFunctionServiceListBlock;

  bool _validateBlocks = false;
  bool get validateBlocks => _validateBlocks;
  set validateBlocks(bool value) {
    _validateBlocks = value;
    notifyListeners();
  }

  bool get _isValidateBlocks =>
      _functionServiceListBlock != null &&
      _functionServiceListBlock!.isValid() &&
      (_ifBlock == null || _ifBlock!.isValid()) &&
      (_waitUntilBlock == null || _waitUntilBlock!.isValid()) &&
      (_loopBlock == null || _loopBlock!.isValid()) &&
      (_elseBlock == null || _elseBlock!.isValid());

  void onUpdateLoopBlock(LoopBlock block) {
    _loopBlock = block;
    validateBlocks = _isValidateBlocks;
  }

  void onUpdateFunctionServiceListBlock(FunctionServiceListBlock block) {
    _functionServiceListBlock = block;
    validateBlocks = _isValidateBlocks;
  }

  void onUpdateElseFunctionServiceListBlock(FunctionServiceListBlock block) {
    _elseFunctionServiceListBlock = block;
    validateBlocks = _isValidateBlocks;
  }

  void onUpdateIfBlock(IfBlock block) {
    _ifBlock = block;
    _waitUntilBlock = null;
    validateBlocks = _isValidateBlocks;
  }

  // onUpdateWaitUntilBlock
  void onUpdateWaitUntilBlock(WaitUntilBlock block) {
    _waitUntilBlock = block;
    _ifBlock = null;
    elseBlock = null;
    validateBlocks = _isValidateBlocks;
  }

  // onUpdateElseBlock - nullable for deletion
  void onUpdateElseBlock(ElseBlock? block) {
    elseBlock = block;
    _waitUntilBlock = null;
    validateBlocks = _isValidateBlocks;
  }

  void fillRootBlock() {
    if (_isValidateBlocks == false) {
      return;
    }

    clear();

    if (_functionServiceListBlock == null) {
      // Exception 발생
      throw Exception('No Function Block');
    }

    // 1. loop -> if -> func
    // 2. loop -> waitUntil -> func
    // 3. loop -> func
    // 4. if -> func
    // 5. waitUntil -> func
    // 6. func

    if (_loopBlock != null) {
      addScenarioItem(_loopBlock!); // loopBlock -> rootBlock

      // case 1
      if (_ifBlock != null) {
        addChildScenarioItem(parent: _loopBlock!, child: _ifBlock!);
        addChildScenarioItem(
            parent: _ifBlock!, child: _functionServiceListBlock!);
        // _elseBlock가 있을 경우 elseBlock -> loopBlock
        if (_elseBlock != null) {
          addChildScenarioItem(parent: _loopBlock!, child: _elseBlock!);
          addChildScenarioItem(
              parent: _elseBlock!, child: _elseFunctionServiceListBlock!);
        }
      }
      // case 2
      else if (_waitUntilBlock != null) {
        addChildScenarioItem(parent: _loopBlock!, child: _waitUntilBlock!);
        addChildScenarioItem(
            parent: _loopBlock!,
            child:
                _functionServiceListBlock!); // wait until doesn't increase the level
      }
      // case 3
      else {
        addChildScenarioItem(
            parent: _loopBlock!,
            child:
                _functionServiceListBlock!); // wait until doesn't increase the level
      }
    }
    // no loop
    else {
      // case 4
      if (_ifBlock != null) {
        addScenarioItem(_ifBlock!);
        addChildScenarioItem(
            parent: _ifBlock!, child: _functionServiceListBlock!);
        // _elseBlock가 있을 경우 elseBlock -> rootBlock
        if (_elseBlock != null) {
          addScenarioItem(_elseBlock!);
          addChildScenarioItem(
              parent: _elseBlock!, child: _elseFunctionServiceListBlock!);
        }
      }
      // case 5
      else if (_waitUntilBlock != null) {
        addScenarioItem(_waitUntilBlock!);
        addScenarioItem(_functionServiceListBlock!);
      }
      // case 6
      else {
        addScenarioItem(_functionServiceListBlock!);
      }
    }
  }
}
