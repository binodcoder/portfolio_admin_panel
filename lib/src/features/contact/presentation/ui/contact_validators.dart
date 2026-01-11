import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/utils/string_validators.dart';

mixin ContactValidators {
  final StringValidator emailValidator = EmailSubmitRegexValidator();
  final StringValidator phoneValidator = RegexValidator(
    regexSource: r'^[0-9+()\s-]{7,}$',
  );
  final StringValidator urlValidator = RegexValidator(
    regexSource: r'^https?:\/\/.+$',
  );

  bool canSubmitEmail(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || emailValidator.isValid(trimmed);
  }

  bool canSubmitPhone(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || phoneValidator.isValid(trimmed);
  }

  bool canSubmitWebsite(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || urlValidator.isValid(trimmed);
  }

  String? emailErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!emailValidator.isValid(trimmed)) {
      return 'Enter a valid email'.hardcoded;
    }
    return null;
  }

  String? phoneErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!phoneValidator.isValid(trimmed)) {
      return 'Enter a valid phone number'.hardcoded;
    }
    return null;
  }

  String? websiteErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!urlValidator.isValid(trimmed)) {
      return 'Enter a valid URL'.hardcoded;
    }
    return null;
  }
}
