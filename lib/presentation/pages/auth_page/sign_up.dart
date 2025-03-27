import 'dart:io';

import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/media_image.dart';
import 'package:chat_app/domain/usecases/sign_up_usecase.dart';
import 'package:chat_app/presentation/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:chat_app/presentation/widgets/circular_progress.dart';
import 'package:chat_app/presentation/widgets/password_field.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _usernameError;

  final MediaImage _mediaImage = MediaImage();

  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(sl<SignUpUsecase>()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text("Sign Up"),
          centerTitle: true,
        ),
        body: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccessfullySatate) {
              context.goNamed(AppRoutes.chats.name);
            }

            if (state is SignUpErrorSatate) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            }

            if (state is SignUpValidationErrorState) {
              setState(() {
                _emailError = state.emailError;
                _passwordError = state.passwordError;
                _usernameError = state.usernameError;
              });
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () async {
                      File? file = await _mediaImage.getImageInGallery();
                      if (file != null) {
                        setState(() => pickedImage = file);
                      }
                    },
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.20,
                      backgroundColor: AppColors.green,
                      backgroundImage:
                          pickedImage != null ? FileImage(pickedImage!) : null,
                      child: pickedImage == null
                          ? SvgPicture.asset(
                              "assets/icons/user.svg",
                              width: 80.0,
                              height: 80.0,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      label: Text("User name"),
                      errorText: _usernameError,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      label: Text("Email"),
                      errorText: _emailError,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  PasswordField(
                    label: "Password",
                    errorText: _passwordError,
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 40.0),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () => context.read<SignUpBloc>().add(
                              AuthSignUpEvent(
                                imageUrl: pickedImage,
                                username: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            ),
                        child: state is SignUpLoadingSatate
                            ? CircularProgress()
                            : Text("Sign Up"),
                      );
                    },
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
