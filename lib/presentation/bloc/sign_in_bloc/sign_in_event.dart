part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

class AuthSignInEvent extends SignInEvent {
  AuthSignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
