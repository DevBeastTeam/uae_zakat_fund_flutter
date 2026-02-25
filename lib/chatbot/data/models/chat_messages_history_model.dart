import 'package:zakat_fund/chatbot/data/models/chat_message_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_messages_history_entity.dart';

class ChatMessagesHistoryModel extends ChatMessagesHistoryEntity {
  ChatMessagesHistoryModel({
    required super.messages,
    required super.totalDocs,
    required super.limit,
    required super.totalPages,
    required super.page,
    required super.pagingCounter,
    required super.nextPage,
    required super.hasPrevPage,
    required super.hasNextPage,
  });

  factory ChatMessagesHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatMessagesHistoryModel(
      messages: ((json['docs'] ?? []) as List<dynamic>)
          .map((e) => ChatMessageModel.fromJson(e))
          .toList(),
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
