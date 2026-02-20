import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/chat_bot_ai_loading.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/rounded_container.dart';

class ChatBotTextFieldComponent extends StatelessWidget {
  const ChatBotTextFieldComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBotViewModel>(
      builder: (context, viewModel, child) {
        final sendingMessage = viewModel.sendingMessage;

        return SafeArea(
          top: false,
          child: RoundedContainer(
            padding: const EdgeInsets.all(4),
            radius: 50,
            offset: Offset.zero,
            hasShadow: true,
            shadowColor: Colors.black.withAlpha(5),
            spreadRadius: 2,
            backgroundColor: Colors.white,
            child: TextFormField(
              enabled:
                  !viewModel.sendingMessage && !viewModel.loadingExistingChat,
              maxLength: 1000,
              controller: viewModel.messageController,
              keyboardType: TextInputType.text,
              onTap: () => viewModel.scrollToBottom(
                fromTextField: true,
                context: context,
              ),
              onChanged: (_) => viewModel.notifyListeners(),
              onFieldSubmitted: (_) =>
                  viewModel.onSendMessage(context: context),
              textInputAction: TextInputAction.send,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                counterText: '',
                hintText: 'message_field_hint'.tr,
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.grey.withAlpha(30)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.grey.withAlpha(30)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),

                // Send Button
                suffixIcon: RoundedContainer(
                  margin: const EdgeInsets.all(8),
                  onPressed: () => viewModel.onSendMessage(context: context),
                  backgroundColor: Colors.grey,
                  gradient: null,
                  shape: BoxShape.circle,
                  child: sendingMessage
                      ? const ChatBotAiLoading(size: 20)
                      : Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 1.sw * 0.05,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
