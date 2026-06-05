import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';
import 'package:binodfolioadmin/src/utils/string_validators.dart';

mixin SkillValidators {
  final StringValidator nonEmpty = NonEmptyStringValidator();

  bool canSubmitName(String name) {
    return nonEmpty.isValid(name.trim());
  }

  String? nameErrorText(String name) {
    if (name.trim().isEmpty) {
      return 'Enter skill name'.hardcoded;
    }
    return null;
  }
}
