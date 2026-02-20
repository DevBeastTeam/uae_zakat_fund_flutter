import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';

class HomeStatsWidget extends GetView<HomeViewModel> {
  const HomeStatsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          buildContainer(
              icon: AppResources.donatedProjects,
              borderColor: AppColors.darkerGreenColor,
              title: "mostDonatedProjects",
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffF3FAF4),
                  Color(0xffCAE8CF),
                ],
              ),
              style: AppTextStyle.darkerGreen14spTextStyle1),
          10.horizontalSpace,
          buildContainer(
              icon: AppResources.expireProjects,
              title: "projectsExpiringSoon",
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffF9F7ED),
                  Color(0xffE6D7A2),
                ],
              ),
              style: AppTextStyle.accentBrown14spTextStyle,
              borderColor: AppColors.accentBrownColor),
        ],
      ),
    );
  }

  Expanded buildContainer(
      {required String icon,
      required String title,
      required TextStyle style,
      required Color borderColor,
      required LinearGradient gradient}) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          Get.toNamed(AppRoutes.projectsDonatedScreen,arguments: title=="mostDonatedProjects");
        },
        child: Container(
          height: 110.h,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: borderColor.withValues(alpha: 0.3)),
            gradient: gradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 40.w,
                height: 40.h,
              ),
              10.verticalSpace,
              Flexible(
                child: Text(
                  title.tr,
                  style: style,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
