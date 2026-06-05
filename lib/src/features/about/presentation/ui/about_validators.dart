import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';

mixin AboutValidators {
  static const int _minAboutWords = 10;

  bool canSubmitAbout(String value) {
    return _wordCount(value) >= _minAboutWords;
  }

  String? aboutErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter About'.hardcoded;
    }
    if (_wordCount(value) < _minAboutWords) {
      return 'About must be at least $_minAboutWords words'.hardcoded;
    }
    return null;
  }

  int _wordCount(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 0;
    }
    return trimmed.split(RegExp(r'\s+')).length;
  }
}
