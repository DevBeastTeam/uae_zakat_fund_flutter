import 'package:zakat_fund/chatbot/data/models/message_context_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';

abstract class ChatRepo {
  Future<MessageEntity?> sendMessage({
    required String message,
    required String sessionId,
    required String userId,
    required List<MessageContextModel> messageContext,
  });
}
