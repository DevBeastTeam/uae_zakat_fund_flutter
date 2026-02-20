import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/view_model/projects_donated_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class ProjectsDonatedScreen extends GetView<ProjectsDonatedViewModel> {
  const ProjectsDonatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "projects"),
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: CupertinoSearchField(
              controller: controller.donatedSearchController,
              onChanged: (_)  => controller.searchProjects(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceSidebar(),
                  10.horizontalSpace,
                  Expanded(
                    child: Obx(() => GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                            crossAxisSpacing: 10.h,
                            mainAxisSpacing: 10.h,
                          ),
                          itemCount: controller.projects.length,
                          itemBuilder: (context, itemIndex) {
                            return ProjectCard(
                                project: controller.projects[itemIndex]);
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceSidebar extends GetView<ProjectsDonatedViewModel> {
  const ServiceSidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGrey1),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        itemCount: controller.donationCategoriesList.length,
        itemBuilder: (context, index) {
          final category = controller.donationCategoriesList[index];

          return GestureDetector(
            onTap: () async {
              controller.fetchProjectsBasedOnCat(index);
            },
            child: Obx(() {
              final isSelected =
                  controller.selectedDonatedCategory.value == index;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondaryDarkBrownColor
                              .withValues(alpha: 0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SvgPicture.asset(
                      index == 0
                          ? AppResources.walletIcon
                          : AppResources.folderIcon,
                      width: 24.w,
                      height: 24.h,
                      color: isSelected
                          ? AppColors.secondaryDarkBrownColor
                          : AppColors.secondaryPrimaryBlackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.tr,
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? AppTextStyle.secondaryDarkBrownColor10spTextStyle
                        : AppTextStyle.greyColor10spTextStyle,

                  ),
                  40.verticalSpace,
                ],
              );
            }),
          );
        },
      ),
    );
  }
}

class ProjectCard extends GetView<ProjectsDonatedViewModel> {
  final ProjectElements project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildProjectImage(project),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.find<HomeViewModel>().remindMe(project.projectId ?? 0);
            },
            child: Container(
              height: 20.h,
              margin: EdgeInsets.symmetric(vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.remindColor),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "remindMe".tr,
                    style: AppTextStyle.tealGreyColor8spTextStyle,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.access_time,
                      size: 10, color: AppColors.tealGreyColor),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 35.h,
            child: Text(
              Utils.isArabic ? project.projectNameArabic : project.projectName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.secondaryPrimaryBlack12spTextStyle2,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 28.h,
            child: ElevatedButton(
              onPressed: () {
                if (controller.selectedDonatedCategory.value == 0) {
                  Get.toNamed(AppRoutes.projectDetailsScreen, arguments: {
                    "projectId": project.projectId,
                    "isPreview": false,
                  });
                } else {
                  Get.find<CartViewModel>().quickDonateDialog(project);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryDarkBrownColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              child: Text(
                  controller.selectedDonatedCategory.value == 0
                      ? "viewDetails".tr
                      : "quickDonate".tr,
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          ),
        ],
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
                  width: 25.w, height: 25.h)),
        ],
      );
    }

    return CachedImage(image: image.mediaUrl, height: 84.h, width: 117.w);
  }
}
