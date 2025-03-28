import 'dart:io';

import 'package:chat_app/domain/core/value_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/usecases/sign_up_usecase.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUsecase usecase;

  SignUpBloc(this.usecase) : super(SignUpInitial()) {
    on<AuthSignUpEvent>(_onSignUp);
  }

  Future<void> _onSignUp(
    AuthSignUpEvent event,
    Emitter<SignUpState> emit,
  ) async {
    final emailVO = EmailAddress(event.email);
    String? emailError = emailVO.isValid ? null : emailVO.error;

    String? usernameError;
    if (event.username.trim().isEmpty) {
      usernameError = 'Имя пользователя не может быть пустым';
    }

    String? passwordError;
    if (event.password.isEmpty) {
      passwordError = 'Пароль не может быть пустым';
    } else if (event.password.length < 6) {
      passwordError = 'Пароль не может быть короче 6 символов';
    }

    if (emailError != null || usernameError != null || passwordError != null) {
      emit(SignUpValidationErrorState(
        emailError: emailError,
        usernameError: usernameError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(SignUpLoadingSatate());
    final response = await usecase(
      params: SignUpReq(
        imageUrl: event.imageUrl,
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (e) {
        emit(SignUpErrorSatate(e.errorMessage));
      },
      (data) {
        emit(SignUpSuccessfullySatate(data));
      },
    );
  }
}
