import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:zakat_fund/chatbot/core/custom_text.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_message_entity.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/rounded_container.dart';

class DrawerChatHistoryComponent extends StatelessWidget {
  final ChatMessageEntity chat;

  const DrawerChatHistoryComponent({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final selected =
        context.watch<ChatBotViewModel>().sessionId == chat.sessionId;

    return RoundedContainer(
      backgroundColor: selected ? Colors.grey : null,
      child: ListTile(
        minTileHeight: 0,
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        onTap: () {
          if (chat.sessionId == null) return;

          context.read<ChatBotViewModel>().getChatMessagesHistory(
            chatSessionId: chat.sessionId!,
            pageNumber: 1,
          );
        },
        title: CustomText(
          text: chat.title ?? 'new_chat'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
