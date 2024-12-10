import 'package:highlight/highlight.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';

enum ProgrammingLanguage { cpp, java, python }

extension ProgrammingLanguageExt on ProgrammingLanguage {
  Mode get mode {
    return switch (this) {
      ProgrammingLanguage.cpp => cpp,
      ProgrammingLanguage.java => java,
      ProgrammingLanguage.python => python,
    };
  }

  String get displayText {
    switch (this) {
      case ProgrammingLanguage.cpp:
        return 'C++';
      case ProgrammingLanguage.java:
        return 'Java';
      case ProgrammingLanguage.python:
        return 'Python';
    }
  }
}
