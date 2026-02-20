import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/chatbot/core/custom_text.dart';
import 'package:zakat_fund/chatbot/core/date_utils.dart';
import 'package:zakat_fund/chatbot/domain/entities/message_entity.dart';
import 'package:zakat_fund/utils/utils.dart';

class MessageBubble extends StatelessWidget {
  final int messageIndex;
  final MessageEntity message;

  const MessageBubble({
    super.key,
    required this.messageIndex,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 20),
      child: Column(
        children: [
          // Message
          Align(
            alignment: (message.fromZakat ?? false)
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.centerEnd,
            child: Column(
              crossAxisAlignment: (message.fromZakat ?? false)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                // Message Content
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: (message.fromZakat ?? false)
                        ? Colors.white
                        : Colors.black,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: (message.fromZakat ?? false)
                          ? Radius.zero
                          : const Radius.circular(20),
                      topEnd: (message.fromZakat ?? false)
                          ? const Radius.circular(20)
                          : Radius.zero,
                      bottomEnd: const Radius.circular(20),
                      bottomStart: const Radius.circular(20),
                    ),
                  ),
                  child: CustomText(
                    height: 1.5,
                    text: message.reply ?? 'generic_error'.tr,
                    fontWeight: FontWeight.w500,
                    textAlign: getTheCorrectTextAlign(
                      text: message.reply ?? 'generic_error'.tr,
                      isArabic: Utils.isArabic,
                    ),
                    color: (message.fromZakat ?? false)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                // Data
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: (message.fromZakat ?? false) ? 10 : 0,
                    end: (message.fromZakat ?? false) ? 0 : 10,
                  ),
                  child: Row(
                    mainAxisAlignment: (message.fromZakat ?? false)
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      // Sender
                      CustomText(
                        height: 1.5,
                        text:
                            ((message.fromZakat ?? false) ? 'app_name' : 'you')
                                .tr,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 10),

                      const Icon(Icons.circle, size: 5, color: Colors.grey),

                      const SizedBox(width: 10),

                      // Time
                      CustomText(
                        height: 1.5,
                        text: (message.date ?? DateTime.now())
                            .toLocal()
                            .formatAiChatTime(locale: Get.locale!),
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextAlign getTheCorrectTextAlign({
  required String text,
  required bool isArabic,
}) {
  final RegExp arabicRegExp = RegExp(
    r'^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s]+$',
  );

  final RegExp englishRegExp = RegExp(r'^[a-zA-Z\s]+$');

  int arabicLetters = 0;
  int englishLetters = 0;

  for (int i = 0; i < (_removeNonLetters(text)).length; i++) {
    if (arabicRegExp.hasMatch(text[i])) {
      arabicLetters++;
    } else if (englishRegExp.hasMatch(text[i])) {
      englishLetters++;
    }
  }

  arabicLetters > englishLetters;

  final bool arabic = arabicLetters > englishLetters;
  final bool english = arabicLetters < englishLetters;

  if (arabic) {
    return TextAlign.right;
  } else if (english) {
    return TextAlign.left;
  } else {
    return isArabic ? TextAlign.right : TextAlign.left;
  }
}

String _removeNonLetters(String text) {
  final RegExp regExp = RegExp(r'[^a-zA-Z\u0600-\u06FF\s]');

  return text.replaceAll(regExp, '');
}
