
import 'package:zakat_fund/chatbot/domain/entities/chat_messages_history_entity.dart';

abstract class GetChatMessagesRepo {
  Future<ChatMessagesHistoryEntity?> getChatMessages({
    required String userId,
    required String sessionId,
    required int pageSize,
    required int pageNumber,
  });
}
