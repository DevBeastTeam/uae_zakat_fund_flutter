import 'package:flutter/material.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/loading_dots.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/zakat_logo.dart';

class LoadingMessageBubble extends StatelessWidget {
  const LoadingMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          const ZakatLogo(size: 40, radius: 50),

          const SizedBox(width: 8),

          // Loading
          Flexible(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadiusDirectional.only(
                    topStart: Radius.zero,
                    topEnd: Radius.circular(20),
                    bottomEnd: Radius.circular(20),
                    bottomStart: Radius.circular(20),
                  ),
                ),
                child: const LoadingDots(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
