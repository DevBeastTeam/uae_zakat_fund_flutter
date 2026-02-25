import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class ServiceCard extends StatelessWidget {
  final OurServices category;
  final List<OurServices> allServices;

  const ServiceCard({
    super.key,
    required this.category,
    required this.allServices,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.serviceDetails,
            arguments: {"service": category, "allServices": allServices});
      },
      child: Container(
        width: 127.w,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.borderColor)),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CachedImage(
                  image: category.icon ?? "", width: 24.w, height: 24.h),
            ),
            10.verticalSpace,
            Flexible(
              child: Text(
                Utils.isArabic ? category.titleAr : category.titleEn,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.secondaryPrimaryBlack14spTextStyle2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
