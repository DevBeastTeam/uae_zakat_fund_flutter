import 'package:zakat_fund/chatbot/domain/entities/chat_bot_ai_chats_history_entity.dart';

abstract class GetChatsHistoryRepo {
  Future<ChatBotAiChatsHistoryEntity?> getChats({
    required String userId,
    required int pageSize,
    required int pageNumber,
  });
}
