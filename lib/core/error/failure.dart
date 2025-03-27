enum AuthFailure {
  emailAlreadyInUse,
  repeatEmailOrPassword,
  unknownError,
}

class Failure implements Exception {
  Failure({
    required this.type,
    required this.errorMessage,
  });

  final AuthFailure type;
  final String errorMessage;
}
