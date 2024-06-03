import 'enums.dart';

class Variable {
  final String name;
  final String type;

  const Variable({
    required this.name,
    required this.type,
  });

  factory Variable.fromFunctionService(String name, FunctionServiceReturnType type) {
    switch(type) {
      case FunctionServiceReturnType.UNDEFINED:
        return Variable(name: name, type: 'undefined');
      case FunctionServiceReturnType.VOID:
        return Variable(name: name, type: 'undefined');
      case FunctionServiceReturnType.INTEGER:
        return Variable(name: name, type: 'int');
      case FunctionServiceReturnType.DOUBLE:
        return Variable(name: name, type: 'double');
      case FunctionServiceReturnType.BOOL:
        return Variable(name: name, type: 'bool');
      case FunctionServiceReturnType.STRING:
        return Variable(name: name, type: 'string');
      case FunctionServiceReturnType.BINARY:
        /// TODO: 이거 string으로 보는게 맞나? 입력창 따로 안필요함?
        return Variable(name: name, type: 'string');
    }
  }

  /// TODO: [ValueService]에 대해서도 필요한 게 맞는지 체크 필요
  factory Variable.fromValueService(String name) {
    return Variable(name: name, type: 'undefined');
  }
}