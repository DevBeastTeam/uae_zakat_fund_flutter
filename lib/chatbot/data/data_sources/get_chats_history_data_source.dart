import 'package:zakat_fund/chatbot/core/api_helper_chat_bot_ai.dart';
import 'package:zakat_fund/chatbot/data/models/chat_bot_ai_chats_model.dart';

const String getChatsApi = 'v1/chat';

abstract class GetChatsHistoryDataSource {
  Future<ChatBotAiChatsModel?> getChats({
    required String userId,
    required int pageSize,
    required int pageNumber,
  });
}

class GetChatsHistoryDataSourceImpl implements GetChatsHistoryDataSource {
  final ApiHelperChatBotAi client;

  GetChatsHistoryDataSourceImpl(this.client);

  @override
  Future<ChatBotAiChatsModel?> getChats({
    required String userId,
    required int pageSize,
    required int pageNumber,
  }) async {
    final response = await client.get(
      url: getChatsApi,
      query: {'userId': userId, 'pageSize': pageSize, 'pageNumber': pageNumber},
    );

    final data = response?['data'];

    if (data == null || data is! Map<String, dynamic>) {
      return null;
    }

    return ChatBotAiChatsModel.fromJson(data);
  }
}
