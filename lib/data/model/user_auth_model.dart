import 'package:chat_app/domain/entities/user_auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthModel {
  UserAuthModel({
    required this.uid,
    required this.username,
    required this.imageUrL,
    required this.email,
  });

  final String uid;
  final String? username;
  final String? imageUrL;
  final String email;

  factory UserAuthModel.fromJson(User user) {
    return UserAuthModel(
      uid: user.uid,
      username: user.displayName,
      imageUrL: user.photoURL,
      email: user.email ?? "",
    );
  }

  UserAuthEntity toEntity() {
    return UserAuthEntity(
      uid: uid,
      username: username,
      imageUrl: imageUrL,
      email: email,
    );
  }
}
