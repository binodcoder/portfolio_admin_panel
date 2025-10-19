import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/auth/data/auth_repository.dart';
import 'package:portfolio_admin_panel/src/features/auth/presentation/account/account_screen.dart';
import 'package:portfolio_admin_panel/src/features/auth/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:portfolio_admin_panel/src/features/auth/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/ui/intro_form.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/ui/intro_page.dart';
import 'package:portfolio_admin_panel/src/features/home/home.dart';
import 'package:portfolio_admin_panel/src/routing/go_router_refresh_stream.dart';
import 'package:portfolio_admin_panel/src/routing/not_found_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
/// ```dart
/// context.goNamed(AppRoute.orders.name)
/// ```
enum AppRoute { home, account, signIn, intro, introEdit }

/// returns the GoRouter instance that defines all the routes in the app
@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // * redirect logic based on the authentication state
    redirect: (context, state) async {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final isLoggingIn = state.matchedLocation == '/signIn';

      // If not logged in, redirect to sign in
      if (!isLoggedIn && !isLoggingIn) {
        return '/signIn';
      }

      // If logged in and trying to go to signIn, redirect to home
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      // No redirect needed
      return null;
    },

    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const Home(),
        routes: [
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) =>
                const MaterialPage(fullscreenDialog: true, child: AccountScreen()),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
            ),
          ),
          GoRoute(
            path: 'intro',
            name: AppRoute.intro.name,
            builder: (context, state) => const IntroPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.introEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  fullscreenDialog: true,
                  child: IntroForm(item: state.extra as Intro?),
                ),
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
