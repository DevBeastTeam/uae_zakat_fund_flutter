import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget buildBottomSheetHeader({String text="filter"}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(text.tr,
            style: AppTextStyle.secondaryPrimaryBlack18spTextStyle1),
      ),
      IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.highlight_remove_outlined,
            color: AppColors.secondaryPrimaryBlackColor),
      )
    ],
  );
}