import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:zakat_fund/chatbot/core/ar_en_text.dart';
import 'package:zakat_fund/chatbot/core/custom_text.dart';
import 'package:zakat_fund/chatbot/domain/entities/suggestion_entity.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/chatbot/presentation/widgets/components/rounded_container.dart';

class SuggestionsComponent extends StatelessWidget {
  const SuggestionsComponent({super.key});

  String get getGreeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'good_morning'.tr;
    } else if (hour < 17) {
      return 'good_afternoon'.tr;
    } else {
      return 'good_evening'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = context.read<ChatBotViewModel>().suggestions;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Greeting
        CustomText(
          text: getGreeting,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),

        // How to Help
        CustomText(
          text: 'how_to_help'.tr,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),

        const SizedBox(height: 5),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomText(
            text: 'chat_bot_choose_service'.tr,
            color: Colors.grey,
            fontSize: 12,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 20),

        // Suggestions
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];

            return _buildSuggestionWidget(
              context: context,
              suggestion: suggestion,
              onPressed: () {
                context.read<ChatBotViewModel>().onSendMessage(
                  context: context,
                  suggestion: suggestion,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSuggestionWidget({
    required BuildContext context,
    required SuggestionEntity suggestion,
    required VoidCallback onPressed,
  }) {
    return RoundedContainer(
      radius: 30,
      spreadRadius: 2,
      hasShadow: true,
      hasBorder: true,
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shadowColor: Colors.black.withAlpha(5),
      borderColor: Colors.grey.withAlpha(10),
      onPressed: onPressed,
      child: Center(
        child: FittedBox(
          child: CustomText(
            text: arEnText(
              context: context,
              ar: suggestion.titleAr,
              en: suggestion.titleEn,
            ),
            fontSize: 14,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
