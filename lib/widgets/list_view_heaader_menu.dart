import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/status_chip.dart';

Widget listViewHeaderPopUpMenu({required String status,required Function(String) onSelected,required List<PopupMenuItem<String>> menuItems}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statusChip(status),
        if(menuItems.isNotEmpty)popupMenuButton(onSelected:onSelected, menuItems:menuItems),
      ],
    ),
  );
}

PopupMenuButton<String> popupMenuButton(
    {required Function(String) onSelected,required List<PopupMenuItem<String>> menuItems}) {
  return PopupMenuButton<String>(
        splashRadius: 50.r,
        padding: EdgeInsets.zero,
        color: Colors.white,
        onOpened: Utils.hideKeyboard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        onSelected: onSelected,
        itemBuilder: (_) => menuItems,
        child: const CircleAvatar(
          backgroundColor: AppColors.chipBackgroundColor,
          child: Icon(Icons.more_horiz, color: AppColors.secondaryBtnBackgroundColor),
        ),
      );
}

PopupMenuItem<String> popupMenuItem({required String label,required String icon,required TextStyle textStyle,Color? iconColor}) {
  return PopupMenuItem<String>(
    value: label,
    child: Row(
      children: [
        SvgPicture.asset(icon, width: 16.w, height: 16.h, color: iconColor),
        10.horizontalSpace,
        Text(label.tr, style: textStyle),
      ],
    ),
  );
}