import 'package:zakat_fund/chatbot/data/models/message_context_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/chat_repo.dart';

class ChatUsecase {
  final ChatRepo chatRepo;

  const ChatUsecase(this.chatRepo);

  Future<MessageEntity?> call({
    required String message,
    required String sessionId,
    required String userId,
    required List<MessageContextModel> messageContext,
  }) {
    return chatRepo.sendMessage(
      message: message,
      sessionId: sessionId,
      userId: userId,
      messageContext: messageContext,
    );
  }
}
