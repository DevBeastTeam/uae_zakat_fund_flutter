import 'package:zakat_fund/chatbot/core/api_helper_chat_bot_ai.dart';
import 'package:zakat_fund/chatbot/data/models/chat_messages_history_model.dart';

const String getChatMessagesApi = 'v1/chat/messages/';

abstract class GetChatMessagesDataSource {
  Future<ChatMessagesHistoryModel?> getChatMessages({
    required String userId,
    required String sessionId,
    required int pageSize,
    required int pageNumber,
  });
}

class GetChatMessagesDataSourceImpl extends GetChatMessagesDataSource {
  final ApiHelperChatBotAi apiBaseHelper;

  GetChatMessagesDataSourceImpl(this.apiBaseHelper);

  @override
  Future<ChatMessagesHistoryModel?> getChatMessages({
    required String userId,
    required String sessionId,
    required int pageSize,
    required int pageNumber,
  }) async {
    final response = await apiBaseHelper.get(
      url: '$getChatMessagesApi$sessionId',
      query: {'userId': userId, 'pageSize': pageSize, 'pageNumber': pageNumber},
    );

    final data = response?['data'];

    if (data == null || data is! Map<String, dynamic>) {
      return null;
    }

    return ChatMessagesHistoryModel.fromJson(data);
  }
}
