import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/presentation/pages/error_page/error_page.dart';
import 'package:chat_app/service_locator.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

import 'package:chat_app/presentation/pages/auth_page/sign_in.dart';
import 'package:chat_app/presentation/pages/auth_page/sign_up.dart';
import 'package:chat_app/presentation/pages/chats_page/chats_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: AppRoutes.signIn.route,
    routes: [
      GoRoute(
        path: AppRoutes.signIn.route,
        name: AppRoutes.signIn.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: SignIn(),
          transitionsBuilder: _buildSlideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.signUp.route,
        name: AppRoutes.signUp.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: SignUp(),
          transitionsBuilder: _buildSlideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.chats.route,
        name: AppRoutes.chats.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ChatsPage(),
          transitionsBuilder: _buildSlideTransition,
        ),
      ),
    ],
    redirect: (context, state) {
      final userAuthenticated = sl<fbAuth.FirebaseAuth>().currentUser != null;
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>> USER AUTHENTICATED: $userAuthenticated");

      if (!userAuthenticated) {
        return AppRoutes.signIn.route;
      } else if (userAuthenticated) {
        return AppRoutes.chats.route;
      }
      return null;
    },
    errorBuilder: (context, state) => ErrorPage(),
  );

  static Widget _buildSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final inAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(animation);

    final outAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(secondaryAnimation);

    return SlideTransition(
      position: inAnimation,
      child: SlideTransition(
        position: outAnimation,
        child: child,
      ),
    );
  }
}
