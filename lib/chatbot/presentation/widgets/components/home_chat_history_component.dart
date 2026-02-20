import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/rounded_container.dart';

class HomeChatHistoryComponent extends StatelessWidget {
  const HomeChatHistoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: (1.sw * 0.09),
      width: (1.sw * 0.09),
      radius: (1.sw * 0.025),
      onPressed: () =>
          context.read<ChatBotViewModel>().openChatHistory(context),
      child: Icon(
        Icons.history_rounded,
        color: Colors.black,
        size: (1.sw * 0.05),
      ),
    );
  }
}
