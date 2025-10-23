import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_admin_panel/src/features/auth/data/auth_repository.dart';
import 'package:portfolio_admin_panel/src/features/auth/presentation/account/account_screen.dart';
import 'package:portfolio_admin_panel/src/features/auth/presentation/sign_in/ui/email_password_sign_in_form_type.dart';
import 'package:portfolio_admin_panel/src/features/auth/presentation/sign_in/ui/email_password_sign_in_screen.dart';
import 'package:portfolio_admin_panel/src/features/intro/domain/intro.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/ui/intro_form.dart';
import 'package:portfolio_admin_panel/src/features/intro/presentation/ui/intro_page.dart';
import 'package:portfolio_admin_panel/src/features/home/home.dart';
import 'package:portfolio_admin_panel/src/features/about/domain/about.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/ui/about_form.dart';
import 'package:portfolio_admin_panel/src/features/about/presentation/ui/about_page.dart';
import 'package:portfolio_admin_panel/src/features/skills/domain/skill.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/ui/skill_form.dart';
import 'package:portfolio_admin_panel/src/features/skills/presentation/ui/skills_page.dart';
import 'package:portfolio_admin_panel/src/features/projects/domain/project.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/ui/project_form.dart';
import 'package:portfolio_admin_panel/src/features/projects/presentation/ui/projects_page.dart';
import 'package:portfolio_admin_panel/src/features/social/domain/social_link.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/ui/social_form.dart';
import 'package:portfolio_admin_panel/src/features/social/presentation/ui/social_page.dart';
import 'package:portfolio_admin_panel/src/features/experience/domain/experience.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/ui/experience_form.dart';
import 'package:portfolio_admin_panel/src/features/experience/presentation/ui/experience_page.dart';
import 'package:portfolio_admin_panel/src/features/education/domain/education.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/ui/education_form.dart';
import 'package:portfolio_admin_panel/src/features/education/presentation/ui/education_page.dart';
import 'package:portfolio_admin_panel/src/features/certifications/domain/certification.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/ui/certification_form.dart';
import 'package:portfolio_admin_panel/src/features/certifications/presentation/ui/certifications_page.dart';
import 'package:portfolio_admin_panel/src/features/contact/domain/contact_info.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/ui/contact_form.dart';
import 'package:portfolio_admin_panel/src/features/contact/presentation/ui/contact_page.dart';
import 'package:portfolio_admin_panel/src/routing/go_router_refresh_stream.dart';
import 'package:portfolio_admin_panel/src/routing/not_found_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
/// ```dart
/// context.goNamed(AppRoute.orders.name)
/// ```
enum AppRoute {
  home,
  account,
  signIn,
  intro,
  introEdit,
  about,
  aboutEdit,
  skills,
  skillEdit,
  projects,
  projectEdit,
  social,
  socialEdit,
  experience,
  experienceEdit,
  education,
  educationEdit,
  certifications,
  certificationEdit,
  contact,
  contactEdit,
}

/// returns the GoRouter instance that defines all the routes in the app
@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/signIn',
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
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const MaterialPage(
          //fullscreenDialog: true,
          child: EmailPasswordSignInScreen(formType: EmailPasswordSignInFormType.signIn),
        ),
      ),

      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const Home(),
        routes: [
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => const MaterialPage(child: AccountScreen()),
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
                  // fullscreenDialog: true,
                  child: IntroForm(item: state.extra as Intro?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'about',
            name: AppRoute.about.name,
            builder: (context, state) => const AboutPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.aboutEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  // fullscreenDialog: true,
                  child: AboutForm(item: state.extra as About?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'skills',
            name: AppRoute.skills.name,
            builder: (context, state) => const SkillsPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.skillEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  // fullscreenDialog: true,
                  child: SkillForm(item: state.extra as Skill?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'projects',
            name: AppRoute.projects.name,
            builder: (context, state) => const ProjectsPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.projectEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  // fullscreenDialog: true,
                  child: ProjectForm(item: state.extra as Project?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'social',
            name: AppRoute.social.name,
            builder: (context, state) => const SocialPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.socialEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  //  fullscreenDialog: true,
                  child: SocialForm(item: state.extra as SocialLink?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'experience',
            name: AppRoute.experience.name,
            builder: (context, state) => const ExperiencePage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.experienceEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  // fullscreenDialog: true,
                  child: ExperienceForm(item: state.extra as Experience?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'education',
            name: AppRoute.education.name,
            builder: (context, state) => const EducationPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.educationEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  // fullscreenDialog: true,
                  child: EducationForm(item: state.extra as Education?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'certifications',
            name: AppRoute.certifications.name,
            builder: (context, state) => const CertificationsPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.certificationEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  // fullscreenDialog: true,
                  child: CertificationForm(item: state.extra as Certification?),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'contact',
            name: AppRoute.contact.name,
            builder: (context, state) => const ContactPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.contactEdit.name,
                pageBuilder: (context, state) => MaterialPage(
                  // fullscreenDialog: true,
                  child: ContactForm(item: state.extra as ContactInfo?),
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
