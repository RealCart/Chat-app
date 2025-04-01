part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  ProfileLoadedState(this.data);

  final UserEntity data;
}

class ProfileErrorState extends ProfileState {
  ProfileErrorState(this.errorMessage);

  final String errorMessage;
}
