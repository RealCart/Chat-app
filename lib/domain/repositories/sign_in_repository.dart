import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class SignInRepository {
  Future<Either<Failure, UserEntity>> singIn({
    required String email,
    required String password,
  });
}
