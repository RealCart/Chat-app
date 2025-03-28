import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/utils/user_database_status.dart';
import 'package:chat_app/presentation/pages/chat_page/chat_page.dart';
import 'package:chat_app/presentation/pages/error_page/error_page.dart';
import 'package:chat_app/presentation/pages/user_list_page/user_list_page.dart';
import 'package:chat_app/service_locator.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

import 'package:chat_app/presentation/pages/auth_page/sign_in.dart';
import 'package:chat_app/presentation/pages/auth_page/sign_up.dart';
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
        path: AppRoutes.userList.route,
        name: AppRoutes.userList.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const UserListPage(),
          transitionsBuilder: _buildSlideTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.chatPage.route,
        name: AppRoutes.chatPage.name,
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: Duration(milliseconds: 150),
            reverseTransitionDuration: Duration(milliseconds: 150),
            child: ChatPage(
              otherUserUid: uid,
            ),
            transitionsBuilder: _buildSlideTransition,
          );
        },
      )
    ],
    redirect: (context, state) {
      final userAuthenticated = sl<fbAuth.FirebaseAuth>().currentUser != null;
      final isOnAuthPage = state.fullPath == AppRoutes.signIn.route ||
          state.fullPath == AppRoutes.signUp.route;

      if (!userAuthenticated && !isOnAuthPage) {
        return AppRoutes.signIn.route;
      } else if (userAuthenticated && isOnAuthPage) {
        setupPresence();
        return AppRoutes.userList.route;
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
