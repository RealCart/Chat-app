import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/presentation/pages/auth_pages/sign_up.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/icons/chat.png", height: 30.0),
            SizedBox(width: 10.0),
            Text(
              "Chat app",
              style: getTextStyle(CustomTextStyle.s32w600),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              SignInTitle(),
              const SizedBox(height: 40.0),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {},
                child: Text("Login"),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  );
                },
                child: Text("Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInTitle extends StatelessWidget {
  const SignInTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Приветствуем! \nобщайся и развлекайся",
      textAlign: TextAlign.left,
      style: getTextStyle(
        CustomTextStyle.s32w600,
        color: AppColors.black,
      ),
    );
  }
}
