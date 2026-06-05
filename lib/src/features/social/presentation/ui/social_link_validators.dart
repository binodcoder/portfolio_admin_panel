import 'package:binodfolioadmin/src/utils/string_validators.dart';
import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';

mixin SocialLinkValidators {
  final StringValidator nonEmpty = NonEmptyStringValidator();
  final MinLengthStringValidator minLength3 = MinLengthStringValidator(3);

  bool canSubmitPlatform(String platform) {
    return nonEmpty.isValid(platform) && minLength3.isValid(platform);
  }

  bool canSubmitUrl(String url) {
    final urlRegex = RegExp(r'^(http|https):\/\/.+');
    return nonEmpty.isValid(url) && urlRegex.hasMatch(url);
  }

  String? platformErrorText(String platform) {
    if (platform.isEmpty) {
      return 'Platform can\'t be empty'.hardcoded;
    }
    if (platform.length < 3) {
      return 'Platform is too short'.hardcoded;
    }
    return null;
  }

  String? urlErrorText(String url) {
    if (url.isEmpty) {
      return 'URL can\'t be empty'.hardcoded;
    }
    if (!RegExp(r'^(http|https):\/\/.+').hasMatch(url)) {
      return 'Invalid URL format'.hardcoded;
    }
    return null;
  }
}
