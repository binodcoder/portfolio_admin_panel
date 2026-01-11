import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/common_widgets/responsive_scrollable_card.dart';
import 'package:portfolio_admin_panel/src/common_widgets/save_button.dart';
import 'package:portfolio_admin_panel/src/constants/app_sizes.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/controller/social_controller.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/ui/social_link_validators.dart';
import 'package:portfolio_admin_panel/src/localization/string_hardcoded.dart';

class SocialForm extends ConsumerStatefulWidget {
  const SocialForm({super.key, this.item});

  final SocialLink? item;

  // * Keys for testing using find.byKey()
  static const platformKey = Key('platform');
  static const urlKey = Key('url');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SocialFormState();
}

class _SocialFormState extends ConsumerState<SocialForm> with SocialLinkValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _platformController = TextEditingController();
  final _urlController = TextEditingController();

  String get platform => _platformController.text;
  String get url => _urlController.text;

  String? get _id => widget.item?.id;

  var _submitted = false;

  @override
  void initState() {
    super.initState();
    _platformController.text = widget.item?.platform ?? '';
    _urlController.text = widget.item?.url ?? '';
  }

  @override
  void dispose() {
    _node.dispose();
    _platformController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(socialControllerProvider.notifier);
      final success = await controller.createSocial(
        SocialLink(platform: platform, url: url),
      );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  void _platformEditingComplete() {
    if (canSubmitPlatform(platform)) {
      _node.nextFocus();
    }
  }

  void _urlEditingComplete() {
    if (!canSubmitUrl(url)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(socialControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Edit Link'.hardcoded : 'New Link'.hardcoded),
        actions: [
          SaveButton(
            onSave: !state.isLoading ? null : () => _submit(),
            isLoading: state.isLoading,
          ),
        ],
      ),
      body: ResponsiveScrollableCard(
        child: FocusScope(
          node: _node,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Platform field
                TextFormField(
                  key: SocialForm.platformKey,
                  controller: _platformController,
                  decoration: InputDecoration(
                    labelText: 'Platform (e.g. GitHub, LinkedIn)'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (platform) =>
                      !_submitted ? null : platformErrorText(platform ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _platformEditingComplete(),
                ),
                gapH12,
                TextFormField(
                  key: SocialForm.urlKey,
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'URL'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (url) => !_submitted ? null : urlErrorText(url ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.url,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _urlEditingComplete(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
