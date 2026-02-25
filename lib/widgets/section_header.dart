import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

import '../my_app/my_app.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1
                .copyWith(height: 0),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Row(
              children: [
                Text(
                  "viewAll".tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    // color: const Color(0xFF8B7355),
                    color: themeViewModel.color,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF8B7355),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
