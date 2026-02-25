import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/campaigns_view_model.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';

class CampaignsScreen extends StatelessWidget {
  final CampaignsViewModel viewModel = Get.put(CampaignsViewModel());

  CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: viewModel.refreshData,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: CupertinoSearchField(
            controller: viewModel.searchController,
            onSubmitted: (_) async {
              Utils.showLoadingDialog();
              await viewModel.fetchProjects(search: true, clear: true);
              Utils.hideLoadingDialog();
            },
            onChanged: (String p1) {},
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
                  child: Obx(() {
                    if (viewModel.projects.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            "noProjectsFound".tr,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.black12spTextStyle,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      controller: viewModel.scrollController,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 230.h,
                        crossAxisSpacing: 10.h,
                        mainAxisSpacing: 10.h,
                      ),
                      itemCount: viewModel.projects.length,
                      itemBuilder: (context, itemIndex) {
                        return ProjectCard(
                            project: viewModel.projects[itemIndex]);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        110.verticalSpace,
      ],
    );
  }
}

class ServiceSidebar extends StatelessWidget {
  ServiceSidebar({
    super.key,
  });

  final controller = Get.find<CampaignsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGrey1),
      ),
      child: Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
            itemCount: controller.categoriesList.length,
            itemBuilder: (context, index) {
              final category = controller.categoriesList[index];
              bool isSVG =
                  category.icon?.toString().split(".").last.toLowerCase() ==
                      "svg";
              return GestureDetector(
                onTap: () async {
                  controller.selectedCategory.value = category;
                  Utils.showLoadingDialog();
                  await controller.fetchProjects(search: true, clear: true);
                  Utils.hideLoadingDialog();
                },
                child: Obx(() {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: controller.selectedCategory.value == category
                              ? AppColors.secondaryDarkBrownColor
                                  .withValues(alpha: 0.12)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: category.value == 0
                            ? SvgPicture.asset(
                                AppResources.servicesUnFillIcon,
                                width: 24.w,
                                height: 24.h,
                              )
                            : isSVG
                                ? SvgPicture.network(
                                    '${FlavorConfig.storageUrl}${category.icon}')
                                : CachedImage(
                                    image: category.icon,
                                    width: 24.w,
                                    height: 24.h),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Utils.isArabic ? category.nameAr : category.name,
                        textAlign: TextAlign.center,
                        style: controller.selectedCategory.value == category
                            ? AppTextStyle.secondaryDarkBrownColor10spTextStyle
                            : AppTextStyle.greyColor10spTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      20.verticalSpace,
                    ],
                  );
                }),
              );
            },
          )),
    );
  }
}

class ProjectCard extends GetView<CampaignsViewModel> {
  final ProjectElements project;
  final cartViewModel = Get.find<CartViewModel>();

  ProjectCard({
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
              height: 45.h,
              child: Text(
                Utils.isArabic
                    ? project.projectNameArabic
                    : project.projectName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.secondaryPrimaryBlack12spTextStyle2,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: 28.h,
              child: ElevatedButton(
                onPressed: () {
                  cartViewModel.quickDonateDialog(project);
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor: AppColors.secondaryDarkBrownColor,
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
                  width: 25.w, height: 25.h)),
        ],
      );
    }

    return CachedImage(image: image.mediaUrl, height: 84.h, width: 117.w);
  }
}
