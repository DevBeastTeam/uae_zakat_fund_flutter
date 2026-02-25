import 'package:zakat_fund/chatbot/domain/entities/chat_messages_history_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/get_chat_messages_repo.dart';

class GetChatMessagesUsecase {
  final GetChatMessagesRepo getChatMessagesRepo;

  const GetChatMessagesUsecase(this.getChatMessagesRepo);

  Future<ChatMessagesHistoryEntity?> call({
    required String userId,
    required String sessionId,
    required int pageSize,
    required int pageNumber,
  }) {
    return getChatMessagesRepo.getChatMessages(
      userId: userId,
      sessionId: sessionId,
      pageSize: pageSize,
      pageNumber: pageNumber,
    );
  }
}
