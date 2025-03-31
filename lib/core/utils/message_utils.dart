import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:intl/intl.dart';

class MessageUtils {
  static Map<String, List<MessageEntity>> groupMessagesByDate(
      List<MessageEntity> messages) {
    final Map<String, List<MessageEntity>> grouped = {};
    for (final msg in messages) {
      final dateKey = DateFormat('yyyy-MM-dd').format(msg.timestamp);
      grouped.putIfAbsent(dateKey, () => []).add(msg);
    }
    return grouped;
  }

  static String getHeaderLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return "Сегодня";
    } else if (dateToCompare == yesterday) {
      return "Вчера";
    } else {
      return DateFormat.yMMMMd('ru').format(date);
    }
  }
}
