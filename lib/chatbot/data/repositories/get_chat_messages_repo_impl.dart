import 'package:zakat_fund/chatbot/data/data_sources/get_chat_messages_data_source.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_messages_history_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/get_chat_messages_repo.dart';

class GetChatMessagesRepoImpl implements GetChatMessagesRepo {
  final GetChatMessagesDataSource getChatMessagesDataSource;

  const GetChatMessagesRepoImpl(this.getChatMessagesDataSource);

  @override
  Future<ChatMessagesHistoryEntity?> getChatMessages({
    required String userId,
    required String sessionId,
    required int pageSize,
    required int pageNumber,
  }) {
    return getChatMessagesDataSource.getChatMessages(
      userId: userId,
      sessionId: sessionId,
      pageSize: pageSize,
      pageNumber: pageNumber,
    );
  }
}
