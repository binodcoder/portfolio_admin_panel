import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';
import 'package:binodfolioadmin/src/utils/string_validators.dart';

mixin EducationValidators {
  final StringValidator nonEmpty = NonEmptyStringValidator();

  bool _isValidDate(String value) => DateTime.tryParse(value) != null;

  bool canSubmitInstitution(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitDegree(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitField(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitStart(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || _isValidDate(trimmed);
  }

  bool canSubmitEnd(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty || _isValidDate(trimmed);
  }

  bool canSubmitLocation(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitGpa(String value) {
    return nonEmpty.isValid(value.trim());
  }

  bool canSubmitDescription(String value) {
    return nonEmpty.isValid(value.trim());
  }

  String? institutionErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter institution'.hardcoded;
    }
    return null;
  }

  String? fieldErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter field'.hardcoded;
    }
    return null;
  }

  String? degreeErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter degree'.hardcoded;
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

  String? endErrorText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_isValidDate(trimmed)) {
      return 'Select a valid date'.hardcoded;
    }
    return null;
  }

  String? locationErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter location'.hardcoded;
    }
    return null;
  }

  String? gpaErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter Gpa'.hardcoded;
    }
    return null;
  }

  String? descriptionErrorText(String value) {
    if (value.trim().isEmpty) {
      return 'Enter description'.hardcoded;
    }
    return null;
  }
}
