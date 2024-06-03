// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:mysmax_playground/core/scenario_code_parser/scenario_code_parser.dart';

void main() {
  const String scenario1 = 'loop (30 SEC){if ( (#meeting_room).temperature <= 23 ){(#meeting_room #air_conditioner).turn_off();}else if ( (#meeting_room).temperature > 25 ){(#meeting_room #air_conditioner).turn_on();}}';
  const String scenario2 = """
  loop (24 HOUR) {
	wait until ( (#clock).HOUR == 12);
	x = (#util).get_lunch_menu();
	(#speaker).tts(x);
	(#util).send_mail("점심 메뉴", x);
}
  """;

  final codeParser = ScenarioCodeParser(scenario2);

  print(codeParser.blockStack.top.uid);
  print(codeParser.blockStack.top.level);
  print(codeParser.blockStack.top.isNestable);
  print(codeParser.blockStack.top.blockType);
  print(codeParser.blockStack.top.blocks);

  print(codeParser.blockStack.top.getVariableNames());
  print(codeParser.blockStack.top.getColor());
  print(codeParser.blockStack.top.toScenarioCode());
}
