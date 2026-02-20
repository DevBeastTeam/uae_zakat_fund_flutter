import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class ContentHelpfulWidget extends GetView<MainViewModel> {
  final int id;
  final String type;

  const ContentHelpfulWidget({super.key, required this.id, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "contentHelpful".tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle4,
          ),
          10.verticalSpace,
          Text(
            "feedbackAboutExperience".tr,
            style: AppTextStyle.darkGreyOne16spTextStyle,
          ),
          16.verticalSpace,
          Row(
            children: [
              OutlinedButton.icon(
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(100.w, 43.h)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r))),
                  side: WidgetStatePropertyAll(BorderSide(
                      width: 2.w, color: AppColors.secondaryDarkBrownColor)),
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w)),
                  elevation: const WidgetStatePropertyAll(0),
                ),
                onPressed: () => addRating(type: type, pageId: id, yes: true),
                label: Text(
                  "yes".tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.secondaryDarkBrownColor16spTextStyle1,
                ),
                icon: SvgPicture.asset(
                  AppResources.thumbsUpIcon,
                  color: AppColors.secondaryDarkBrownColor,
                ),
              ),
              16.horizontalSpace,
              OutlinedButton.icon(
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(100.w, 43.h)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r))),
                  side: WidgetStatePropertyAll(BorderSide(
                      width: 2.w, color: AppColors.secondaryDarkBrownColor)),
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w)),
                  elevation: const WidgetStatePropertyAll(0),
                ),
                onPressed: () => addRating(type: type, pageId: id, yes: false),
                label: Text(
                  "no".tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.secondaryDarkBrownColor16spTextStyle1,
                ),
                icon: SvgPicture.asset(
                  AppResources.thumbsDownIcon,
                  color: AppColors.secondaryDarkBrownColor,
                ),
              )
            ],
          ),
          25.verticalSpace,
          const Divider(color: AppColors.lightGrey1),

          20.verticalSpace,
          Text(
            "haveUsedOurService".tr,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
          ),
          25.verticalSpace,
          OutlinedButton(
            onPressed: () => Get.toNamed(AppRoutes.addFeedbackScreen),
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                  width: 1.w, color: AppColors.secondaryDarkBrownColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            ),
            child: Text(
              "giveYourOpinion".tr,
              style: AppTextStyle.secondaryDarkBrownColor16spTextStyle1,
            ),
          )
        ],
      ),
    );
  }

  addRating({
    required int pageId,
    required String type,
    required bool yes,
  }) {
    controller.addContentRating(
      pageId: pageId,
      type: type,
      yes: yes,
    );
  }
}
