import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/campaigns_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/remind_me_button.dart';

class CampaignItemWidget extends GetView<CampaignsViewModel> {
  final ProjectElements project;
  final bool showRemindMe;

  const CampaignItemWidget(
      {super.key, required this.project, this.showRemindMe = false});

  @override
  Widget build(BuildContext context) {
    final category = _resolveCategory(project.category);
    final height = Utils.isArabic
        ? (showRemindMe ? 155.h : 115.h)
        : (showRemindMe ? 145.h : 105.h);
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.projectDetailsScreen, arguments: {
        "projectId": project.projectId,
        "isPreview": false,
      }),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 4.0),
              blurRadius: 150.0,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildProjectImage(project, category),
            Expanded(child: _buildProjectInfo(project)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectImage(ProjectElements project, String category) {
    final imageWidget = project.projectImages.isEmpty
        ? Image.asset(AppResources.placeholder,
            height: showRemindMe ? 145.h : 105.h,
            width: 145.w,
            fit: BoxFit.cover)
        : project.projectImages[0].mediaType == 1
            ? _buildVideoThumbnail(project.projectImages[0].mediaUrl)
            : CachedImage(
                height: showRemindMe ? 145.h : 105.h,
                width: 145.w,
                image: project.projectImages[0].mediaUrl,
              );

    return SizedBox(
      width: 145.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: !Utils.isArabic ? Radius.circular(20.r) : Radius.zero,
              right: Utils.isArabic ? Radius.circular(20.r) : Radius.zero,
            ),
            child: imageWidget,
          ),
          if (category.isNotEmpty)
            Container(
              height: 30.h,
              margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.r)),
                color: AppColors.chipBackgroundColor,
              ),
              child: Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.darkBrownColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail(String mediaUrl) {
    return Stack(
      children: [
        FutureBuilder(
          future: Utils.urlThumbnail(mediaUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.file(File(snapshot.data!),
                  height: 145.h, width: 145.w, fit: BoxFit.cover);
            } else {
              return Image.asset(AppResources.placeholder,
                  height: 145.h, width: 145.w, fit: BoxFit.cover);
            }
          },
        ),
        Center(
          child: SvgPicture.asset(
            AppResources.playIcon,
            width: 33.w,
            height: 33.h,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectInfo(ProjectElements project) {
    final remainingAmount = project.remainingAmount ??
        double.tryParse(project.projectAmountObjective.toString()) ??
        0;
    final double completionPercent = project.percentOfCompletion != null
        ? project.percentOfCompletion! / 100
        : 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.isArabic ? project.projectNameArabic : project.projectName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.darkBrownColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          8.verticalSpace,
          if (showRemindMe)...[
            RemindMeButton(onPressed: () {
              controller.homeViewModel.remindMe(project.projectId ?? 0);
            }),
          13.verticalSpace],
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: LinearProgressIndicator(
              minHeight: 4.h,
              value: completionPercent,
              color: AppColors.darkBrownColor,
              backgroundColor: AppColors.progressBarBackgroundColor,
            ),
          ),
          8.verticalSpace,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${"remaining".tr} ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryDarkGreyColor,
                  ),
                ),
                TextSpan(
                  text:
                      "${Utils.getCurrency(remainingAmount.round())} ${"currency".tr}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: AppColors.secondaryBlackColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _resolveCategory(String? categoryString) {
    if (categoryString == null || categoryString.isEmpty) return "";
    try {
      final id = int.parse(categoryString.split(',')[0]);
      final cat = controller.categoriesList.firstWhere((e) => e.value == id);
      return Utils.isArabic ? cat.nameAr : cat.name;
    } catch (_) {
      return "";
    }
  }
}
