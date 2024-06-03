import 'block.dart';
import 'enums.dart';
import 'expression.dart';
import 'utils.dart';

export 'block.dart';

class ScenarioCodeParser {
  String scenarioCode;
  RootBlock rootBlock = RootBlock();
  Stack<Block> blockStack = Stack<Block>();

  ScenarioCodeParser(this.scenarioCode) {
    scenarioCode = deindent(scenarioCode);
    blockStack.push(rootBlock);
  }

  RootBlock parse() {
    // 20240311(ikess): Added some preprocessings to fit the parser.
    scenarioCode = scenarioCode.replaceAll(RegExp(r'{'), '{\n');
    scenarioCode = scenarioCode.replaceAll(RegExp(r'}'), '}\n');
    scenarioCode = scenarioCode.replaceAll(RegExp('if '), 'if');
    scenarioCode = scenarioCode.replaceAll(RegExp('loop '), 'loop');
    scenarioCode = scenarioCode.replaceAll(RegExp(';loop'), ';\nloop');
    scenarioCode = scenarioCode.replaceAll(RegExp(r';'), ';\n');

    List<String> lines = scenarioCode.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines.isEmpty) continue;
      String line = lines[i].replaceAll(RegExp(r'|;$'), '').trim();

      BlockType currentBlockType = getBlockType(line);
      Block currentBlockCursor = getCurrentBlock();
      Block generatedBlock = DummyBlock();
      switch (currentBlockType) {
        case BlockType.LOOP:
          generatedBlock = LoopBlock.parse(line);
          break;
        case BlockType.IF:
          generatedBlock = ConditionBlock.ifBlock(
            IfBlock.parse(line),
          );
          break;
        case BlockType.ELSE:
          generatedBlock = ElseBlock.parse(line);
          break;
        case BlockType.WAIT_UNTIL:
          generatedBlock = ConditionBlock.waitUntilBlock(
            WaitUntilBlock.parse(line),
          );
          break;
        case BlockType.VALUE_SERVICE:
          generatedBlock = ValueServiceBlock.parse(line);
          break;
        case BlockType.FUNCTION_SERVICE:
          generatedBlock = FunctionServiceBlock.parse(line);
          break;
        case BlockType.EOF_BLOCK:
          blockStack.pop();
          break;
        default:
          break;
      }

      /// 작성자: 우수몽
      /// 연속된 FunctionServiceBlock은 ServicesBlock에 합쳐서 넣는다.
      if(generatedBlock is FunctionServiceBlock) {
        // 케이스 1: 직전에 ServicesBlock이 있었음 -> ServicesBlock 지우고 현재 block을 추가한 새로운 ServicesBlock를 넣음
        if(currentBlockCursor.blocks.isNotEmpty && currentBlockCursor.blocks.last is FunctionServiceListBlock) {
          final newChildren = (currentBlockCursor.blocks.last as FunctionServiceListBlock).children;
          newChildren.add(generatedBlock);
          generatedBlock = (currentBlockCursor.blocks.removeLast() as FunctionServiceListBlock).copyWith(FunctionServiceListBlock(newChildren));
        }
        // 케이스 2: 첫 FunctionServiceBlock | ValueServiceBlock인 경우 -> ServicesBlock 생성하고 children으로 현재 block만 넣음
        else {
          generatedBlock = FunctionServiceListBlock([generatedBlock]);
        }
      }

      if (generatedBlock.blockType == BlockType.UNDEFINED) continue;

      // generatedBlock.level = currentBlockCursor.level + 1;
      currentBlockCursor.addBlock(generatedBlock);
      if (generatedBlock.isNestable) blockStack.push(generatedBlock);
    }

    return rootBlock;
  }

  BlockType getBlockType(String line) {
    line = line.trim();

    if (line.isEmpty) {
      return BlockType.EMPTY_BLOCK;
    }

    String blockName = line.split('(')[0].trim().toUpperCase();
    switch (blockName) {
      case 'LOOP':
        return BlockType.LOOP;
      case 'IF':
        return BlockType.IF;
      case 'WAIT UNTIL':
        return BlockType.WAIT_UNTIL;
      case '}':
        return BlockType.EOF_BLOCK;
      default:
        RegExp pattern = RegExp(r'else\s*\{');
        if (pattern.hasMatch(line)) {
          return BlockType.ELSE;
        }

        ServiceType serviceType = getServiceType(line);
        if (serviceType == ServiceType.FUNCTION) {
          return BlockType.FUNCTION_SERVICE;
        } else if (serviceType == ServiceType.VALUE) {
          return BlockType.VALUE_SERVICE;
        } else if (!line.endsWith('{')) {
          return BlockType.UNDEFINED;
        } else {
          throw Exception('Invalid block line');
        }
    }
  }

  Block getCurrentBlock() {
    return blockStack.top;
  }
}

/*
if((#RobotCleaner).switch == 'off') {
(#RobotCleaner).setRobotCleanerCleaningMode('standard');
(#Speaker).play('청소를 시작합니다');
}
else {
(#RobotCleaner).off();
(#Speaker).play('청소를 종료합니다.');
}


if ((#TempSensor).temperature > 26) {
(#AirConditioner).setAirConditionerMode('cool');
} else if ((#TempSensor).temperature < 20) {
(#AirConditioner).setAirConditionerMode('heat');
}

(#DoorLock).close();
(#Camera).on();
(#Light).off();

if ((#SmokeSensor).smoke == 'detected') {
(#Speaker).play('화재 경보');
(#DoorLock).open();
}
*/
