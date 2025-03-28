part of "user_list_bloc.dart";

abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<UserEntity> users;
  final UserEntity currentUser;
  UserListLoaded({
    required this.users,
    required this.currentUser,
  });
}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);
}
