import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/chat_bot_text_field_component.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/home_chat_history_component.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/home_tip_component.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/zakat_header_component.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/general/chats_history_drawer_component.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/general/loading_chat_messages_shimmer.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/general/messages_component.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/general/suggestions_component.dart';

class ChatBotView extends StatelessWidget {
  const ChatBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<ChatBotViewModel>().messagesScaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      drawer: const ChatsHistoryDrawerComponent(),
      appBar: AppBar(
        toolbarHeight: (1.sw * 0.12),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: const BackButton(),
        surfaceTintColor: Colors.transparent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            ZakatHeaderComponent(),

            // Home Chat History
            HomeChatHistoryComponent(),
          ],
        ),
      ),
      body: Consumer<ChatBotViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            color: const Color(0xFFB59458).withAlpha(15),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: (1.sw * 0.025)),

                Expanded(
                  child: Consumer<ChatBotViewModel>(
                    builder: (context, viewModel, child) {
                      // Loading Existing Chat
                      if (viewModel.loadingExistingChat) {
                        return const LoadingChatMessagesShimmer();
                      }

                      // Show Suggestions if chat is empty
                      if (viewModel.messages.isEmpty) {
                        return const SuggestionsComponent();
                      }

                      // Chat Messages
                      return MessagesComponent(
                        scrollController: viewModel.messagesScrollController,
                        sendingMessage: viewModel.sendingMessage,
                        paginatingChatMessages:
                            viewModel.paginatingChatMessages,
                        messages: viewModel.messages,
                      );
                    },
                  ),
                ),

                // Home Tip
                if (viewModel.messages.isEmpty) ...[
                  SizedBox(height: (1.sw * 0.025)),
                  const HomeTipComponent(),
                  const SizedBox(height: 10),
                ],

                // Send Message Text Field
                const ChatBotTextFieldComponent(),
              ],
            ),
          );
        },
      ),
    );
  }
}
