class UserAuthEntity {
  UserAuthEntity({
    required this.uid,
    required this.imageUrl,
    required this.username,
    required this.email,
  });

  final String uid;
  final String? imageUrl;
  final String? username;
  final String email;
}
