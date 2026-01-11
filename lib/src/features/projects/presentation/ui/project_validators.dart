import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/utils/string_validators.dart';

mixin ProjectValidators {
  final StringValidator nonEmpty = NonEmptyStringValidator();
  final StringValidator urlValidator = RegexValidator(
    regexSource: r'^https?:\/\/.+$',
  );

  bool canSubmitTitle(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitRepoUrl(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || urlValidator.isValid(trimmed);
  }

  bool canSubmitLiveUrl(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || urlValidator.isValid(trimmed);
  }

  String? titleErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter title'.hardcoded;
    }
    return null;
  }

  String? repoUrlErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!urlValidator.isValid(trimmed)) {
      return 'Enter a valid URL'.hardcoded;
    }
    return null;
  }

  String? liveUrlErrorText(String value) {
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
