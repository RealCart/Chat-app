part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadChatEvent extends ChatEvent {
  final String otherUid;
  LoadChatEvent(this.otherUid);
}

class MessagesUpdatedEvent extends ChatEvent {
  final String uid;
  final List<MessageEntity> messages;
  MessagesUpdatedEvent({
    required this.messages,
    required this.uid,
  });
}

class SendMessageEvent extends ChatEvent {
  final String content;
  final String otherUid;
  SendMessageEvent(this.content, this.otherUid);
}
