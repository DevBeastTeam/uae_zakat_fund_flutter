import 'package:zakat_fund/chatbot/data/models/chat_message_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_bot_ai_chats_history_entity.dart';

class ChatBotAiChatsModel extends ChatBotAiChatsHistoryEntity {
  ChatBotAiChatsModel({
    required super.chats,
    required super.totalDocs,
    required super.limit,
    required super.totalPages,
    required super.page,
    required super.pagingCounter,
    required super.nextPage,
    required super.hasPrevPage,
    required super.hasNextPage,
  });

  factory ChatBotAiChatsModel.fromJson(Map<String, dynamic> json) {
    return ChatBotAiChatsModel(
      chats: List<ChatMessageModel>.from(
        (json['docs'] as List?)?.map(
              (data) => ChatMessageModel.fromJson(data),
            ) ??
            [],
      ),
      totalDocs: json['totalDocs'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      page: json['page'],
      pagingCounter: json['pagingCounter'],
      nextPage: json['nextPage'],
      hasPrevPage: json['hasPrevPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
