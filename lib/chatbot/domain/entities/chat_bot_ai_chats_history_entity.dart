import 'package:zakat_fund/chatbot/domain/entities/chat_message_entity.dart';

class ChatBotAiChatsHistoryEntity {
  List<ChatMessageEntity>? chats;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  int? nextPage;
  bool? hasPrevPage;
  bool? hasNextPage;

  ChatBotAiChatsHistoryEntity({
    required this.chats,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.nextPage,
    required this.hasPrevPage,
    required this.hasNextPage,
  });
}
