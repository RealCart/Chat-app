import 'package:chat_app/core/config/theme/app_theme.dart';
import 'package:chat_app/presentation/pages/auth_pages/sign_in.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: SignIn(),
    );
  }
}
