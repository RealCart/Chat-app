import 'dart:io';

import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/domain/entities/user_auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class SignUpRepository {
  Future<Either<Failure, UserAuthEntity>> signUp({
    required File? imageUrl,
    required String username,
    required String email,
    required String password,
  });
}
