part of 'sign_in_bloc.dart';

abstract class SignInState {}

final class SignInInitial extends SignInState {}

class SignInLoaddingState extends SignInState {}

class SignInSuccessfullyState extends SignInState {
  SignInSuccessfullyState(this.user);

  final UserEntity user;
}

class SignInErrorState extends SignInState {
  SignInErrorState(this.error);

  final String error;
}
