part of 'sign_in_bloc.dart';

abstract class SignInEvent {}

class AuthSignInEvent extends SignInEvent {
  AuthSignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
