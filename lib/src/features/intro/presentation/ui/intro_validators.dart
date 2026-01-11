import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

mixin IntroValidators {
  static const int _minIntroWords = 10;

  bool canSubmitIntro(String value) {
    return _wordCount(value) >= _minIntroWords;
  }

  String? introErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter Introduction'.hardcoded;
    }
    if (_wordCount(value) < _minIntroWords) {
      return 'Introduction must be at least $_minIntroWords words'.hardcoded;
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
