import 'dart:io';

import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class SignUpRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required File? imageUrl,
    required String username,
    required String email,
    required String password,
  });
}
