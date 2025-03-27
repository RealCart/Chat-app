class EmailAddress {
  EmailAddress._(this.value, this.error);

  final String value;
  final String? error;

  factory EmailAddress(String input) {
    if (input.isEmpty) {
      return EmailAddress._(input, 'Email пустой');
    } else if (!input.contains('@')) {
      return EmailAddress._(input, 'Некорректный email');
    } else {
      return EmailAddress._(input, null);
    }
  }

  bool get isValid => error == null;
}
