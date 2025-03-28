import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_list_repository.dart';

class GetCurrentUserUsecase {
  GetCurrentUserUsecase(this.repository);

  final UserListRepository repository;

  Future<UserEntity> call() {
    return repository.getCurrentUser();
  }
}
