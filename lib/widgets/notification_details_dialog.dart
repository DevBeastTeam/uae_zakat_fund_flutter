import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

void notificationDetailsDialog(Notifications notification) {
  final imageName = notification.imageName?.trim();
  final hasImage = imageName != null && imageName.isNotEmpty;
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: Get.back,
                icon: const Icon(
                  Icons.highlight_remove_outlined,
                  color: AppColors.secondaryPrimaryBlackColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Text(
                Utils.getDateAgo(notification.date),
                style: AppTextStyle.black13spTextStyle,
              ),
            ),
            if (hasImage) ...[
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: GestureDetector(
                  onTap: ()=>Get.toNamed(AppRoutes.photoViewScreen,arguments: imageName),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedImage(
                      image: imageName,
                      width: Get.width,
                      height: 250.h,
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
              child: Text(
                Utils.isArabic
                    ? notification.descriptionAr
                    : notification.descriptionEn,
                style: AppTextStyle.darkGrey13spTextStyle,
              ),
            ),
            4.verticalSpace,
          ],
        ),
      ),
    ),
  );
}
