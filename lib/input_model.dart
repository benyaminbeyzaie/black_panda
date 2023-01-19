class InputModel<T> {
  final InputType type;
  final String label;
  T? value;

  InputModel({
    required this.label,
    required this.type,
    this.value,
  });

  static InputModel fromLine(String line) {
    List<String> parsedLine = line.split(' ');
    if (parsedLine.length != 2) {
      throw Exception(
          'Input line format is invalid (number of words in one line)');
    }
    try {
      final InputType type =
          InputType.values.firstWhere((e) => e.name == parsedLine[0]);
      if (type == InputType.bool) {
        return InputModel<bool>(
          label: parsedLine[1],
          type: type,
          value: false,
        );
      }
      if (type == InputType.string) {
        return InputModel<String>(label: parsedLine[1], type: type);
      }
      throw Exception('Input line format is invalid (can\'t fine any type)');
    } catch (e) {
      throw Exception('Input line format is invalid (can\'t fine any type)');
    }
  }

  @override
  String toString() {
    return 'type: ${type.name}, label: $label';
  }
}

enum InputType { bool, string }
