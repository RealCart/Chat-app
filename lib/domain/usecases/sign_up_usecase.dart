import 'dart:io';

import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/entities/user_auth_entity.dart';
import 'package:chat_app/domain/repositories/sign_up_repository.dart';
import 'package:dartz/dartz.dart';

class SignUpUsecase implements Usecase<Either, SignUpReq> {
  SignUpUsecase(this.repository);

  final SignUpRepository repository;

  @override
  Future<Either<Failure, UserAuthEntity>> call({required SignUpReq params}) {
    return repository.signUp(
      imageUrl: params.imageUrl,
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpReq {
  SignUpReq({
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
