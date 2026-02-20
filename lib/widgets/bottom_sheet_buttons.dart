import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

Widget buildBottomSheetButtons({
  required VoidCallback? onApply,
  required VoidCallback? onClear,
}) {
  return Row(
    children: [
      Expanded(
        child: elevatedButton(
          text: 'clear',
          backgroundColor: AppColors.lightGreyColor,
          onPressed: onClear,
        ),
      ),
      10.horizontalSpace,
      Expanded(
        child: elevatedButton(
          text: 'applyFilter',
          onPressed: onApply,
        ),
      ),
    ],
  );
}
