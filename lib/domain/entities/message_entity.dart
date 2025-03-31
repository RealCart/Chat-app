class MessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String? content;
  final DateTime timestamp;
  final String? image;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.content,
    required this.timestamp,
    this.image,
  });
}
