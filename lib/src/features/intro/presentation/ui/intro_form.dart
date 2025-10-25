import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/controller/intro_controller.dart';

class IntroForm extends ConsumerStatefulWidget {
  const IntroForm({super.key, this.introId});

  // Optional id from router path parameter; when null or 'new', treat as create
  final String? introId;

  @override
  ConsumerState<IntroForm> createState() => _IntroFormState();
}

class _IntroFormState extends ConsumerState<IntroForm> {
  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => (widget.introId != null && widget.introId != 'new');
  String? get _id => _isEditing ? widget.introId : null;

  bool _initializedFromRemote = false;

  @override
  void initState() {
    super.initState();
    // For edit case, value will be set when provider returns data in build()
    textEditingController.addListener(() => setState(() {}));
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final text = textEditingController.text.trim();
    final notifier = ref.read(introActionControllerProvider.notifier);
    if (_id == null) {
      await notifier.createIntro(Intro(value: text));
    } else {
      await notifier.updateIntro(_id!, Intro(value: text));
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(introActionControllerProvider);
    final isEditing = _isEditing;
    final canSave = !async.isLoading && textEditingController.text.trim().isNotEmpty;

    // If editing, watch the intro by id and prefill once
    if (isEditing) {
      final introAsync = ref.watch(introByIdProvider(_id!));
      introAsync.when(
        data: (intro) {
          if (!_initializedFromRemote && intro != null) {
            textEditingController.text = intro.value;
            _initializedFromRemote = true;
          }
        },
        loading: () {},
        error: (e, __) {},
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Intro' : 'New Intro'),
        actions: [
          TextButton.icon(
            onPressed: canSave ? _save : null,
            icon: async.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Introduction',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This appears on your portfolio landing page.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 16),
                          if (isEditing)
                            Consumer(
                              builder: (context, ref, _) {
                                final introAsync = ref.watch(introByIdProvider(_id!));
                                if (introAsync.isLoading && !_initializedFromRemote) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: LinearProgressIndicator(),
                                  );
                                }
                                if (introAsync.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      'Failed to load intro: ${introAsync.error}',
                                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          TextFormField(
                            controller: textEditingController,
                            minLines: 6,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            enabled: !async.isLoading,
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Please enter an introduction';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText:
                                  "E.g. I'm a Flutter developer building delightful apps.",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
