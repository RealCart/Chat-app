import 'dart:async';

import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_by_id_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUsecase sendMessageUsecase;
  final GetMessagesUsecase getMessagesUsecase;
  final GetUserByIdUsecase getUserByIdUsecase;

  ChatBloc({
    required this.sendMessageUsecase,
    required this.getMessagesUsecase,
    required this.getUserByIdUsecase,
  }) : super(ChatInitial()) {
    on<LoadChatEvent>(_onLoadChat);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final currentUser = sl<fbAuth.FirebaseAuth>().currentUser!;
      final messagesStream = getMessagesUsecase(
        params: GetMessagesParams(
          myUid: currentUser.uid,
          userId: event.otherUid,
        ),
      );
      await for (final messages in messagesStream) {
        final userResult = await getUserByIdUsecase(params: event.otherUid);
        userResult.fold(
          (failure) {
            emit(ChatError(failure.toString()));
          },
          (user) {
            emit(ChatLoaded(user: user, messages: messages));
          },
        );
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    final currentUser = sl<fbAuth.FirebaseAuth>().currentUser!;
    final msg = MessageEntity(
      id: '',
      senderId: currentUser.uid,
      receiverId: event.otherUid,
      content: event.content,
      image: event.imageBase64,
      timestamp: DateTime.now(),
    );
    await sendMessageUsecase(params: msg);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
