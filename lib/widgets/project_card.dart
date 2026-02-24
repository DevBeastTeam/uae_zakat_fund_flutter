import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class ProjectCard extends StatelessWidget {
  final ProjectElements project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.projectDetailsScreen, arguments: {
        "projectId": project.projectId,
        "isPreview": false,
      }),
      child: Container(
        width: 127.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: _buildProjectImage(project)),
            ),
            10.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.secondaryDarkBrownColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.63.r),
              ),
              child: Text(
                "${Utils.isArabic ? project.associationNameArabic : project.associationName}",
                style: AppTextStyle.secondaryDarkBrownColor8spTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            10.verticalSpace,
            SizedBox(
              height: 42.h,
              child: Text(
                Utils.isArabic
                    ? project.projectNameArabic
                    : project.projectName,
                style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 28.h,
              child: ElevatedButton(
                onPressed: () {
                  final cart = Get.find<CartViewModel>();
                  cart.quickDonateDialog(project);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeViewModel.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: Text("quickDonate".tr,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectImage(ProjectElements project) {
    if (project.projectImages.isEmpty) {
      return Image.asset(AppResources.placeholder,
          height: 84.h, width: 117.w, fit: BoxFit.cover);
    }

    final image = project.projectImages.first;

    if (image.mediaType == 1) {
      return Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
            future: Utils.urlThumbnail(image.mediaUrl),
            builder: (context, snapshot) {
              final hasData = snapshot.hasData && snapshot.data != null;
              return hasData
                  ? Image.file(File(snapshot.data!),
                      height: 84.h, width: 117.w, fit: BoxFit.cover)
                  : Image.asset(AppResources.placeholder,
                      height: 84.h, width: 117.w, fit: BoxFit.cover);
            },
          ),
          Center(
              child: SvgPicture.asset(AppResources.playIcon,
                  width: 15.w, height: 15.h)),
        ],
      );
    }

    return CachedImage(image: image.mediaUrl, height: 84.h, width: 117.w);
  }
}
