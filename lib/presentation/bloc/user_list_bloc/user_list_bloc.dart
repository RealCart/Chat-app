import 'package:chat_app/domain/usecases/get_all_users_usecase.dart';
import 'package:chat_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/domain/entities/user_entity.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetAllUsersUsecase getAllUsersUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  UserListBloc({
    required this.getAllUsersUsecase,
    required this.getCurrentUserUsecase,
  }) : super(UserListInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter emit,
  ) async {
    emit(UserListLoading());
    final allUsers = await getAllUsersUsecase();
    final currentUser = await getCurrentUserUsecase();
    allUsers.fold(
      (e) {
        emit(UserListError(">>>>>>>>>>>Error: ${e.toString()}"));
      },
      (data) {
        emit(
          UserListLoaded(
            users: data,
            currentUser: currentUser,
          ),
        );
      },
    );
  }
}
