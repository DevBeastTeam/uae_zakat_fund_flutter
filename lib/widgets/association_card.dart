import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class AssociationCard extends StatelessWidget {
  final Project association;

  const AssociationCard({
    super.key,
    required this.association,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.associationDetailsScreen,
        arguments: association.accountId,
      ),
      child: Container(
        width: 140.w,
        margin: const EdgeInsets.only(left: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 117.w,
                height: 84.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.greyBackColor),
                child: association.accountLogo != null
                    ? CachedImage(
                        image: association.accountLogo!,
                        isCover: false,
                        width: 100.w,
                        height: 75.h,
                      )
                    : Image.asset(
                        AppResources.placeholder,
                        width: 100.w,
                        height: 75.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            10.verticalSpace,
            Flexible(
              child: Text(
                Utils.isArabic
                    ? association.accountNameArabic
                    : association.accountName,
                style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
