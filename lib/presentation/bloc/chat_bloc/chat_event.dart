part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadChatEvent extends ChatEvent {
  final String otherUid;
  LoadChatEvent(this.otherUid);
}

class MessagesUpdatedEvent extends ChatEvent {
  final List<MessageEntity> messages;
  MessagesUpdatedEvent(this.messages);
}

class SendMessageEvent extends ChatEvent {
  final String content;
  final String otherUid;
  SendMessageEvent(this.content, this.otherUid);
}
