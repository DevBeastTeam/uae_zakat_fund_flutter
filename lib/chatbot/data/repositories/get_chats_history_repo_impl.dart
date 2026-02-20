import 'package:zakat_fund/chatbot/data/data_sources/get_chats_history_data_source.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_bot_ai_chats_history_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/get_chats_history_repo.dart';

class GetChatsHistoryRepoImpl implements GetChatsHistoryRepo {
  final GetChatsHistoryDataSource chatsDataSource;

  const GetChatsHistoryRepoImpl(this.chatsDataSource);

  @override
  Future<ChatBotAiChatsHistoryEntity?> getChats({
    required String userId,
    required int pageSize,
    required int pageNumber,
  }) {
    return chatsDataSource.getChats(
      userId: userId,
      pageSize: pageSize,
      pageNumber: pageNumber,
    );
  }
}
