class UserEntity {
  UserEntity({
    required this.uid,
    required this.imageUrl,
    required this.username,
    this.email,
  });

  final String uid;
  final String? imageUrl;
  final String username;
  final String? email;
}
