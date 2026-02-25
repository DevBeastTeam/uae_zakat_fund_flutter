import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';

Container searchAddContainer(
    {required Widget child,
    required TextEditingController controller,
    required Function(String) onChanged,
    Function(String)? onSubmitted,
    required void Function()? onFilterPressed,
      VoidCallback? onClear,
    bool noContainer = false}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: noContainer ? 0.w : 16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15.r)),
      boxShadow: [
        if (!noContainer)
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0.0, 4.0),
            blurRadius: 150.0,
          ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CupertinoSearchField(
                controller: controller,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                onClear: onClear,
              ),
            ),
            8.horizontalSpace,
            buildRawChip(
              label: 'filter',
              icon: AppResources.filterIcon,
              onPressed: onFilterPressed,
            )
          ],
        ),
        8.verticalSpace,
        child,
      ],
    ),
  );
}

Widget buildRawChip(
    {required void Function()? onPressed,
    required String label,
    required String icon}) {
  return RawChip(
    tapEnabled: true,
    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
    onPressed: onPressed,
    avatar: SvgPicture.asset(
      icon,
      width: 16.w,
      height: 16.h,
    ),
    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    label: Text(label.tr, style: AppTextStyle.darkGrey14spTextStyle),
    side: BorderSide(color: AppColors.secondaryLightGreyColor, width: 1.w),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
    backgroundColor: Colors.white,
  );
}

Widget expandedChip(
    {required void Function()? onPressed,
    required String label,
    required String icon}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.r),
          border:
              Border.all(color: AppColors.secondaryLightGreyColor, width: 1.w)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 16.w,
            height: 16.h,
          ),
          8.horizontalSpace,
          Text(label.tr, style: AppTextStyle.darkGrey14spTextStyle)
        ],
      ),
    ),
  );
}
