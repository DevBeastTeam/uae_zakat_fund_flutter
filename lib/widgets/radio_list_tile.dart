import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget radioListTile(int index, int value, String choice, int selectedChoice,
    {required void Function(int?)? onChanged,isNew=false}) {
  return Theme(
    data: Get.theme.copyWith(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      listTileTheme: const ListTileThemeData(
        horizontalTitleGap: 0,
        enableFeedback: false,
      ),
    ),
    child: SizedBox(
      width: isNew?Get.width:110,
      child: RadioListTile(
        title:
            Text(choice.tr, style: AppTextStyle.secondaryBlack14spTextStyle1),
        activeColor: AppColors.blackColor,
        value: value,
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        groupValue: selectedChoice,
        onChanged: onChanged,
      ),
    ),
  );
}
