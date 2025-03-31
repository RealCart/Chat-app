import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';

class SendMessageUsecase implements Usecase<void, MessageEntity> {
  SendMessageUsecase(this.repository);

  final ChatRepository repository;

  @override
  Future<void> call({required params}) async {
    return await repository.sendMessage(params);
  }
}
