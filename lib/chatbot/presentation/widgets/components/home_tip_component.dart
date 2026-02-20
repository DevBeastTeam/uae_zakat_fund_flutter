import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zakat_fund/chatbot/core/custom_text.dart';

class HomeTipComponent extends StatelessWidget {
  const HomeTipComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.only(top: 3),
          child: Icon(
            Icons.info,
            color: Colors.grey,
            size: 1.sh * 0.022,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomText(text: 'chat_note'.tr, color: Colors.grey),
        ),
      ],
    );
  }
}
