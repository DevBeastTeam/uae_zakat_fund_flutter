import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/feature_column.dart';
import 'package:zakat_fund/widgets/slider_indicator.dart';

class FeaturedProjectsSection extends StatelessWidget {
  final RxList<ProjectElements> featuredProjects;
  final RxInt campaignIndex;
  final Function(int index, CarouselPageChangedReason reason) onPageChanged;

  const FeaturedProjectsSection({
    super.key,
    required this.featuredProjects,
    required this.campaignIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (featuredProjects.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 215.h,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: onPageChanged,
            ),
            itemCount: featuredProjects.length,
            itemBuilder: (context, index, realIndex) {
              final project = featuredProjects[index];
              return _FeaturedProjectCard(project: project);
            },
          ),
          16.verticalSpace,
          buildSliderIndicator(campaignIndex.value,
              length: featuredProjects.length),
          10.verticalSpace,
        ],
      );
    });
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final ProjectElements project;

  const _FeaturedProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      alignment: Utils.isArabic ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          _buildBackgroundImage(project),
          _buildOverlayContent(project),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(ProjectElements project) {
    final image = project.projectCoverApp;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30.r),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        child: image != null
            ? CachedImage(image: image, width: Get.width, height: 215.h)
            : Image.asset(AppResources.placeholder,
                width: Get.width, height: 215.h, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildOverlayContent(ProjectElements project) {
    final title = Utils.isArabic ? project.titleAr : project.titleEn;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("featuredProjects".tr,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: AppColors.lightGreyColor)),
          Text(title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.lightGreyColor,
                  height: 0)),
          _buildJoinButton(project),
          Row(
            children: [
              buildFeatureColumn(project, "collected"),
              16.horizontalSpace,
              buildFeatureColumn(project, "remaining"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton(ProjectElements project) {
    return SizedBox(
      height: 34.h,
      child: ElevatedButton(
        onPressed: () =>
            Get.toNamed(AppRoutes.projectDetailsScreen, arguments: {
          "projectId": project.projectId,
          "isPreview": false,
        }),
        style: ElevatedButton.styleFrom(backgroundColor: themeViewModel.color),
        child: Text(
          "joinNow".tr,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.lightWhiteColor),
        ),
      ),
    );
  }
}
