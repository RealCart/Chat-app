import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UserListRepository {
  Future<UserEntity> getCurrentUser();
  Future<Either<String, List<UserEntity>>> getAllUsers();
  Future<Either<String, UserEntity>> getUserById(String uid);
}
