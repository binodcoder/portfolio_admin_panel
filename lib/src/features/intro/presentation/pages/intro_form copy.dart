// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:binodfolioadmin/src/common_widgets/form_card.dart';
// import 'package:binodfolioadmin/src/common_widgets/save_button.dart';
// import 'package:binodfolioadmin/src/constants/app_sizes.dart';
// import 'package:binodfolioadmin/src/common_widgets/responsive_center.dart';
// import 'package:binodfolioadmin/src/features/intro/domain/intro.dart';
// import 'package:binodfolioadmin/src/features/intro/presentation/controller/intro_controller.dart';
// import 'package:binodfolioadmin/src/localization/string_hardcoded.dart';

// class IntroForm extends ConsumerStatefulWidget {
//   const IntroForm({super.key, this.intro});

//   final Intro? intro;

//   // * Keys for testing using find.byKey()
//   static const introKey = Key('intro');

//   @override
//   ConsumerState<IntroForm> createState() => _IntroFormState();
// }

// class _IntroFormState extends ConsumerState<IntroForm> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _introController;

//   @override
//   void initState() {
//     super.initState();
//     _introController = TextEditingController(text: widget.intro?.value.trim() ?? '');
//   }

//   @override
//   void dispose() {
//     _introController.dispose();
//     super.dispose();
//   }

//   void _onTextChanged(String value) {
//     final initial = widget.intro?.value.trim() ?? '';
//     ref.read(introCanSaveProvider.notifier).state = initial != value;
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     final goRouter = GoRouter.of(context);
//     FocusScope.of(context).unfocus();

//     final introText = _introController.text.trim();
//     final notifier = ref.read(introControllerProvider.notifier);
//     final introId = widget.intro?.id;

//     bool success = widget.intro != null
//         ? await notifier.updateIntro(introId!, Intro(value: introText))
//         : await notifier.createIntro(Intro(value: introText));
//     if (success && mounted) {
//       goRouter.pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool canSave = ref.watch(introCanSaveProvider);
//     final bool isLoading = (ref.watch(
//       introControllerProvider.select((s) => s.isLoading),
//     ));
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           (widget.intro != null) ? 'Edit Intro'.hardcoded : 'New Intro'.hardcoded,
//         ),
//         actions: [
//           SaveButton(
//             onSave: (canSave && !isLoading) ? _submit : null,
//             isLoading: isLoading,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: ResponsiveCenter(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: Sizes.p4,
//               vertical: Sizes.p24,
//             ),
//             child: Form(
//               key: _formKey,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               child: FormCard(
//                 title: 'Introduction'.hardcoded,
//                 subTitle: 'This appears on your portfolio landing page.'.hardcoded,
//                 controller: _introController,
//                 isLoading: isLoading,
//                 onChanged: _onTextChanged,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
