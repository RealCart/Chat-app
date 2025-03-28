import 'dart:io';

import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/utils/image_utils.dart';
import 'package:chat_app/data/model/user_auth_model.dart';
import 'package:chat_app/data/sources/remote/firebase_auth_remote.dart';
import 'package:chat_app/data/sources/remote/firebase_firestore_remote.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/sign_up_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  SignUpRepositoryImpl({
    required this.firebaseAuth,
    required this.firebaseFireStore,
  });

  final FirebaseAuthRemote firebaseAuth;
  final FirebaseFirestoreRemote firebaseFireStore;

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required File? imageUrl,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final auth = await firebaseAuth.signUpWithEmailAndPassword(
          email: email, password: password);

      String? avatar;
      if (imageUrl != null) {
        avatar = await ImageUtils.imageFileToBase64(imageUrl);
      }

      await firebaseFireStore.saveUserData(
        uid: auth.uid,
        username: username,
        imageUrl: avatar,
      );

      final data = UserAuthModel.fromJson(auth).toEntity();
      return Right(data);
    } on FirebaseException catch (e) {
      if (e.code == "email-already-in-use") {
        return Left(Failure(
          type: AuthFailure.emailAlreadyInUse,
          errorMessage: "Адресс электроной почты уже используется",
        ));
      }
      return Left(
        Failure(
          type: AuthFailure.unknownError,
          errorMessage: "Ошибка! Попробуйте позже",
        ),
      );
    }
  }
}
