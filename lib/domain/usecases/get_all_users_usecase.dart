import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_list_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllUsersUsecase {
  GetAllUsersUsecase(this.repository);

  final UserListRepository repository;

  Future<Either<String, List<UserEntity>>> call({params}) {
    return repository.getAllUsers();
  }
}
