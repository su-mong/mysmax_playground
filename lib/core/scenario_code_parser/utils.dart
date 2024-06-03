import 'dart:math';

class Stack<T> {
  final List<T> _list = [];

  void push(T element) {
    _list.add(element);
  }

  T pop() {
    if (_list.isEmpty) {
      throw Exception('Stack is empty');
    }
    return _list.removeLast();
  }

  T get top {
    if (_list.isEmpty) {
      throw Exception('Stack is empty');
    }
    return _list.last;
  }

  bool get isEmpty => _list.isEmpty;

  @override
  String toString() => _list.toString();
}

String deindent(String text) {
  var lines = text.split('\n');

  var minIndent = lines.fold<int>(9999, (min_, line) {
    if (line.trim().isNotEmpty) {
      var leadingSpaces = line.length - line.trimLeft().length;
      return min(min_, leadingSpaces);
    }
    return min_;
  });

  var deindentedLines = lines
      .map((line) => line.length > minIndent ? line.substring(minIndent) : line)
      .toList();

  return deindentedLines.join('\n');
}

String indent(String text, int level) {
  String defaultIndent = '  ';
  List<String> lines = text.split('\n');
  List<String> indentedLines =
      lines.map((line) => defaultIndent * level + line).toList();

  return indentedLines.join('\n');
}
