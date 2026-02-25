import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

class CupertinoSearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;

  const CupertinoSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: CupertinoSearchTextField(
        placeholder: "search".tr,
        onChanged: onChanged,
        controller: controller,
        onSubmitted: onSubmitted,
        onSuffixTap: onClear,
        style: AppTextStyle.secondaryBlack14spTextStyle1,
        placeholderStyle: AppTextStyle.darkGrey14spTextStyle,
        prefixInsets: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border:
            Border.all(width: 1.w, color: AppColors.secondaryLightGreyColor)),
        prefixIcon: SvgPicture.asset(
          AppResources.searchIcon,
          width: 16.w,
          height: 16.h,
        ),
      ),
    );
  }
}