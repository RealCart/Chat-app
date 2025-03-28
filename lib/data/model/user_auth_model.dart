import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthModel {
  UserAuthModel({
    required this.uid,
    required this.imageUrL,
    required this.email,
    required this.username,
  });

  final String uid;
  final String username;
  final String? imageUrL;
  final String email;

  factory UserAuthModel.fromJson(User user) {
    return UserAuthModel(
      uid: user.uid,
      username: user.displayName ?? "",
      imageUrL: user.photoURL,
      email: user.email ?? "",
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      username: username,
      imageUrl: imageUrL,
      email: email,
    );
  }
}
