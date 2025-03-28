import 'package:chat_app/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageEntity>> getMessages(String myUid, String userId);
}
