import 'package:zakat_fund/chatbot/data/data_sources/chat_data_source.dart';
import 'package:zakat_fund/chatbot/data/models/message_context_model.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';
import 'package:zakat_fund/chatbot/domain/repositories/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatDataSource chatDataSource;

  const ChatRepoImpl(this.chatDataSource);

  @override
  Future<MessageEntity?> sendMessage({
    required String message,
    required String sessionId,
    required String userId,
    required List<MessageContextModel> messageContext,
  }) {
    return chatDataSource.sendMessage(
      message: message,
      sessionId: sessionId,
      userId: userId,
      messageContext: messageContext,
    );
  }
}
