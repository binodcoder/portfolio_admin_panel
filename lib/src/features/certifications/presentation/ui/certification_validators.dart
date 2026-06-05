import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';
import 'package:binodfolioadmin/src/utils/string_validators.dart';

mixin CertificationValidators {
  final StringValidator nonEmpty = NonEmptyStringValidator();
  final StringValidator urlValidator = RegexValidator(regexSource: r'^https?:\/\/.+$');

  bool _isValidDate(String value) => DateTime.tryParse(value) != null;

  bool canSubmitName(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitIssuer(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitIssueDate(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || _isValidDate(trimmed);
  }

  bool canSubmitExpiryDate(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || _isValidDate(trimmed);
  }

  bool canSubmitCredentialUrl(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || urlValidator.isValid(trimmed);
  }

  String? nameErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter Name'.hardcoded;
    }
    return null;
  }

  String? issuerErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter issuer'.hardcoded;
    }
    return null;
  }

  String? issueDateErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_isValidDate(trimmed)) {
      return 'Select a valid date'.hardcoded;
    }
    return null;
  }

  String? expiryDateErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_isValidDate(trimmed)) {
      return 'Select a valid date'.hardcoded;
    }
    return null;
  }

  String? credentialUrlErrorText(String value) {
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
