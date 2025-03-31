import 'package:chat_app/data/sources/remote/firebase_firestore_remote.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestoreRemote firestoreDataSource;

  ChatRepositoryImpl({
    required this.firestoreDataSource,
  });

  @override
  Future<void> sendMessage(MessageEntity message) async {
    final chatId = _makeChatId(message.senderId, message.receiverId);

    final data = {
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'content': message.content,
      'image': message.image,
      'timestamp': message.timestamp.millisecondsSinceEpoch,
    };

    await firestoreDataSource.sendMessage(chatId: chatId, messageData: data);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String myUid, String otherUid) {
    final chatId = _makeChatId(myUid, otherUid);
    final response = firestoreDataSource.getMessagesStream(chatId);
    print(">>>>>>>>>>>>>> RESPONSE: ${response}");
    return response.map((snapshot) {
      return snapshot.docs.map((doc) {
        final map = doc.data();
        return MessageEntity(
          id: doc.id,
          senderId: map['senderId'] as String,
          receiverId: map['receiverId'] as String,
          content: map['content'] as String?,
          image: map['image'] as String?,
          timestamp:
              DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
        );
      }).toList();
    });
  }

  String _makeChatId(String a, String b) {
    return (a.compareTo(b) < 0) ? '$a\_$b' : '$b\_$a';
  }
}
