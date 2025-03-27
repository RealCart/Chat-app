import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/domain/usecases/sign_in_usecase.dart';
import 'package:chat_app/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:chat_app/presentation/pages/auth_pages/sign_up.dart';
import 'package:chat_app/presentation/pages/home_pages/homa_page.dart';
import 'package:chat_app/presentation/widgets/circular_progress.dart';
import 'package:chat_app/presentation/widgets/password_field.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(sl<SignInUsecase>()),
      child: Scaffold(
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
        body: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccessfullyState) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomaPage()),
                ModalRoute.withName("/"),
              );
            }

            if (state is SignInErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          child: SingleChildScrollView(
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
                    controller: emailController,
                  ),
                  const SizedBox(height: 10.0),
                  PasswordField(
                    label: "Password",
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 40.0),
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () => context.read<SignInBloc>().add(
                              AuthSignInEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            ),
                        child: state is SignInLoaddingState
                            ? CircularProgress()
                            : Text("Login"),
                      );
                    },
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
