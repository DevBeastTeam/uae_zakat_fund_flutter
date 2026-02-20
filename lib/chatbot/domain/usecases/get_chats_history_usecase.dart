import 'package:zakat_fund/chatbot/domain/entities/chat_bot_ai_chats_history_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/get_chats_history_repo.dart';

class GetChatsHistoryUsecase {
  final GetChatsHistoryRepo getChatsHistoryRepo;
  const GetChatsHistoryUsecase(this.getChatsHistoryRepo);

  Future<ChatBotAiChatsHistoryEntity?> call({
    required String userId,
    required int pageSize,
    required int pageNumber,
  }) {
    return getChatsHistoryRepo.getChats(
      userId: userId,
      pageSize: pageSize,
      pageNumber: pageNumber,
    );
  }
}
