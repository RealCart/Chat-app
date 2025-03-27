part of 'sign_in_bloc.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

class SignInLoaddingState extends SignInState {}

class SignInSuccessfullyState extends SignInState {
  SignInSuccessfullyState(this.user);

  final UserAuthEntity user;
}

class SignInErrorState extends SignInState {
  SignInErrorState(this.error);

  final String error;
}
