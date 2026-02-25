import 'package:flutter/material.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/loading_dots.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/loading_message_bubble.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/message_bubble.dart';

class MessagesComponent extends StatelessWidget {
  final ScrollController scrollController;
  final bool sendingMessage;
  final bool paginatingChatMessages;
  final List<MessageEntity> messages;

  const MessagesComponent({
    super.key,
    required this.scrollController,
    required this.sendingMessage,
    required this.paginatingChatMessages,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pagination Loading Indicator
        if (paginatingChatMessages) ...[
          const SafeArea(child: LoadingDots()),
          const SizedBox(height: 20),
        ],

        // Messages List
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: messages.length,
            padding: paginatingChatMessages
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: (kToolbarHeight + 40)),
            itemBuilder: (context, index) {
              final message = messages[index];

              return Column(
                children: [
                  MessageBubble(messageIndex: index, message: message),

                  // Loading Message
                  if (sendingMessage && index == messages.length - 1) ...[
                    const LoadingMessageBubble(),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
