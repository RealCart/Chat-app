part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final UserEntity user;
  final List<MessageEntity> messages;
  ChatLoaded({
    required this.messages,
    required this.user,
  });
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
