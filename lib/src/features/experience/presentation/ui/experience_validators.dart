import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';
import 'package:portfolio_admin_panel/src/utils/string_validators.dart';

mixin ExperienceValidators {
  final StringValidator nonEmpty = NonEmptyStringValidator();

  bool _isValidDate(String value) => DateTime.tryParse(value) != null;

  bool canSubmitCompany(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitTitle(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitStart(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || _isValidDate(trimmed);
  }

  bool canSubmitEnd(String value, {required bool isCurrent}) {
    if (isCurrent) {
      return true;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty || _isValidDate(trimmed);
  }

  String? companyErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter company'.hardcoded;
    }
    return null;
  }

  String? titleErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter title/role'.hardcoded;
    }
    return null;
  }

  String? startErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_isValidDate(trimmed)) {
      return 'Select a valid date'.hardcoded;
    }
    return null;
  }

  String? endErrorText(String value, {required bool isCurrent}) {
    if (isCurrent) {
      return null;
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_isValidDate(trimmed)) {
      return 'Select a valid date'.hardcoded;
    }
    return null;
  }
}
