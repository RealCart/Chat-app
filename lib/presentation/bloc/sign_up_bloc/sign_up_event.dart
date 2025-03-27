part of 'sign_up_bloc.dart';

sealed class SignUpEvent {}

class AuthSignUpEvent extends SignUpEvent {
  AuthSignUpEvent({
    required this.imageUrl,
    required this.username,
    required this.email,
    required this.password,
  });

  final File? imageUrl;
  final String username;
  final String email;
  final String password;
}
