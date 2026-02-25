import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Column totalDonutSummaryText({required String title, required String value}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title.tr,
        style: AppTextStyle.greyDark8spTextStyle,
      ),
      Text(
        value,
        style: AppTextStyle.secondaryBlack10spTextStyle1,
      ),
    ],
  );
}