part of 'sign_up_bloc.dart';

abstract class SignUpState {}

final class SignUpInitial extends SignUpState {}

class SignUpLoadingSatate extends SignUpState {}

class SignUpSuccessfullySatate extends SignUpState {
  SignUpSuccessfullySatate(this.user);

  final UserEntity user;
}

class SignUpErrorSatate extends SignUpState {
  SignUpErrorSatate(this.errorMessage);

  final String errorMessage;
}

class SignUpValidationErrorState extends SignUpState {
  SignUpValidationErrorState({
    this.emailError,
    this.passwordError,
    this.usernameError,
  });

  final String? emailError;
  final String? passwordError;
  final String? usernameError;
}
