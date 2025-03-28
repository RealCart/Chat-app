import 'dart:async';

import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/usecases/get_current_user_usecase.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUsecase sendMessageUsecase;
  final GetMessagesUsecase getMessagesUsecase;
  StreamSubscription? _subscription;

  ChatBloc({
    required this.sendMessageUsecase,
    required this.getMessagesUsecase,
  }) : super(ChatInitial()) {
    on<LoadChatEvent>(_onLoadChat);
    on<MessagesUpdatedEvent>(_onMessagesUpdated);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final currentUser = sl<fbAuth.FirebaseAuth>().currentUser!;
      _subscription?.cancel();
      _subscription = getMessagesUsecase(
          params: GetMessagesParams(
        myUid: currentUser.uid,
        userId: event.otherUid,
      )).listen((messages) {
        add(MessagesUpdatedEvent(messages));
      }, onError: (err) {
        emit(ChatError(err.toString()));
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onMessagesUpdated(MessagesUpdatedEvent event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    final currentUser = sl<fbAuth.FirebaseAuth>().currentUser!;
    final msg = MessageEntity(
      id: '',
      senderId: currentUser.uid,
      receiverId: event.otherUid,
      content: event.content,
      timestamp: DateTime.now(),
    );
    await sendMessageUsecase(params: msg);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
