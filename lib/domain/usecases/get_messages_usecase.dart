import 'package:chat_app/domain/repositories/chat_repository.dart';

class GetMessagesUsecase {
  GetMessagesUsecase(this.repository);

  final ChatRepository repository;

  Stream call({required GetMessagesParams params}) {
    return repository.getMessages(params.myUid, params.userId);
  }
}

class GetMessagesParams {
  GetMessagesParams({
    required this.myUid,
    required this.userId,
  });

  final String myUid;
  final String userId;
}
