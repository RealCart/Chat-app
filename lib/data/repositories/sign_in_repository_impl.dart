import 'package:chat_app/data/model/user_auth_model.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/sign_in_repository.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/data/sources/remote/firebase_auth_remote.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInRepositoryImpl implements SignInRepository {
  SignInRepositoryImpl(this.firebaseAuth);

  final FirebaseAuthRemote firebaseAuth;

  @override
  Future<Either<Failure, UserEntity>> singIn(
      {required String email, required String password}) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final data = UserAuthModel.fromJson(response);
      return Right(data.toEntity());
    } on FirebaseException {
      return Left(Failure(
        type: AuthFailure.repeatEmailOrPassword,
        errorMessage: "Неверный адресс электронной почты или пароль",
      ));
    }
  }
}
