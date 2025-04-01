part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetUserEvent extends ProfileEvent {}
