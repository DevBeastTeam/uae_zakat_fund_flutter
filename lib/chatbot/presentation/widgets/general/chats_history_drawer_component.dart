import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:zakat_fund/chatbot/core/custom_text.dart';
import 'package:zakat_fund/chatbot/domain/entities/chat_message_entity.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/drawer_chat_history_component.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/loading_dots.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/general/chats_history_shimmer.dart';

class ChatsHistoryDrawerComponent extends StatefulWidget {
  const ChatsHistoryDrawerComponent({super.key});

  @override
  State<ChatsHistoryDrawerComponent> createState() =>
      _ChatsHistoryDrawerComponentState();
}

class _ChatsHistoryDrawerComponentState
    extends State<ChatsHistoryDrawerComponent> {
  @override
  void initState() {
    super.initState();

    final viewModel = context.read<ChatBotViewModel>();

    viewModel.chatsSearchController.clear();

    if (viewModel.chatsHistoryInstance == null) {
      Future.microtask(
        () => viewModel.addScrollControllerListener(
          paginateFromBottom: true,
          controller: viewModel.chatsScrollController,
          callback: () {
            viewModel.getChatsHistory();
          },
        ),
      );

      Future.microtask(() => viewModel.getChatsHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Consumer<ChatBotViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      // Title
                      Expanded(child: CustomText(text: 'chats_history'.tr)),

                      // New Chat
                      GestureDetector(
                        onTap: () => viewModel.startNewChat(),
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.sh * 0.03),

                  // Chats List
                  Expanded(
                    child: Consumer<ChatBotViewModel>(
                      builder: (context, viewModel, child) {
                        final chats = viewModel.searchedChats;

                        // Loading
                        if (viewModel.loadingChatsHistory) {
                          return const ChatsHistoryShimmer();
                        }

                        // Empty List
                        if (chats.isEmpty) {
                          return Center(
                            child: CustomText(
                              text: viewModel.chatsSearchController.text.isEmpty
                                  ? 'chatBotHistoryEmpty'.tr
                                  : 'noChatsFound'.tr,
                            ),
                          );
                        }

                        return SafeArea(
                          child: SingleChildScrollView(
                            controller: viewModel.chatsScrollController,
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                // Chats List
                                _showChatsList(
                                  title: 'today'.tr,
                                  chats: viewModel.todayChats,
                                ),

                                _showChatsList(
                                  title: 'yesterday'.tr,
                                  chats: viewModel.yesterdayChats,
                                ),

                                _showChatsList(
                                  title: 'thisWeek'.tr,
                                  chats: viewModel.thisWeekChats,
                                ),

                                _showChatsList(
                                  title: 'other_chats'.tr,
                                  chats: viewModel.otherChats,
                                ),

                                // Pagination Loading Indicator
                                if (viewModel.paginatingChatsHistory) ...[
                                  const SizedBox(height: 20),
                                  const LoadingDots(),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _showChatsList({
    required String title,
    required List<ChatMessageEntity> chats,
  }) {
    if (chats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        CustomText(text: title, color: Colors.black),

        const SizedBox(height: 10),

        // Chats List
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chats.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final currentChat = chats[index];

            return DrawerChatHistoryComponent(chat: currentChat);
          },
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
      ],
    );
  }
}
