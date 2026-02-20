import 'dart:io';

import 'package:zakat_fund/chatbot/core/api_helper_chat_bot_ai.dart';
import 'package:zakat_fund/chatbot/data/models/message_context_model.dart';
import 'package:zakat_fund/chatbot/data/models/message_model.dart';

const String chatBotAiSendMessageEndpoint = 'v2/chat/send';

abstract class ChatDataSource {
  Future<MessageModel?> sendMessage({
    required String message,
    required String sessionId,
    required String userId,
    required List<MessageContextModel> messageContext,
  });
}

class ChatDataSourceImpl implements ChatDataSource {
  final ApiHelperChatBotAi client;

  const ChatDataSourceImpl(this.client);

  @override
  Future<MessageModel?> sendMessage({
    required String message,
    required String sessionId,
    required String userId,
    required List<MessageContextModel> messageContext,
  }) async {
    final response = await client.post(
      url: chatBotAiSendMessageEndpoint,
      body: {
        'message': message,
        'sessionId': sessionId,
        'userId': userId,
        'system': 'zacat_bot',
        'platform': Platform.isAndroid ? 'android' : 'ios',
        if (messageContext.isNotEmpty)
          'context': messageContext.map((e) => e.toJson()).toList(),
      },
    );

    final data = response?['data']?['output'];

    if (data == null || data is! Map<String, dynamic>) {
      return null;
    }

    return MessageModel.fromJson(data);
  }
}
