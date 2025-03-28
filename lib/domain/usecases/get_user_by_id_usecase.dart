import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_list_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserByIdUsecase implements Usecase<Either, String> {
  GetUserByIdUsecase(this.repository);

  final UserListRepository repository;

  @override
  Future<Either<String, UserEntity>> call({required String params}) {
    return repository.getUserById(params);
  }
}
