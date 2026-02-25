import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zakat_fund/chatbot/core/custom_text.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/chat_bot_ai_loading.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/rounded_container.dart';

class ChatBotAiCustomButton extends StatelessWidget {
  final bool loading;
  final double? height;
  final double? width;
  final String title;
  final Widget? trailing;
  final VoidCallback onPressed;

  const ChatBotAiCustomButton({
    super.key,
    this.loading = false,
    required this.title,
    required this.onPressed,
    this.height = 50,
    this.width,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: height,
      width: width,
      radius: 14,
      onPressed: loading ? null : onPressed,
      child: loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ChatBotAiLoading(size: 1.sw * 0.04)],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: title,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
    );
  }
}
