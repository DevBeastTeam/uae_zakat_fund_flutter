import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zakat_fund/chatbot/core/custom_text.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';

class ZakatHeaderComponent extends StatelessWidget {
  const ZakatHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo
        SvgPicture.asset(
          AppResources.newLogo,
          width: 35.w,
          height: 35.h,
        ),

        SizedBox(width: (1.sw * 0.02)),

        // Texts
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            CustomText(
              text: 'app_name'.tr,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),

            // Sub-Title
            CustomText(
              text: 'digital_guide'.tr,
              fontSize: 12,
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }
}
