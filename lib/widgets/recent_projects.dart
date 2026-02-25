import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/progress_bar_content.dart';
import 'package:zakat_fund/widgets/remind_me_button.dart';
import 'package:zakat_fund/widgets/slider_indicator.dart';

class ProjectsCarousel extends StatelessWidget {
  final RxList<ProjectElements> projects;
  final RxInt projectIndex;
  final CarouselSliderController carouselController;
  final Function(int index, CarouselPageChangedReason reason) onPageChanged;

  const ProjectsCarousel({
    super.key,
    required this.carouselController,
    required this.onPageChanged,
    required this.projectIndex,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => projects.isNotEmpty
        ? Column(
            children: [
              CarouselSlider.builder(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: 440.h,
                  viewportFraction: 1,
                  onPageChanged: onPageChanged,
                  enableInfiniteScroll: false,
                ),
                itemCount: projects.length > 4 ? 4 : projects.length,
                itemBuilder: (context, index, _) {
                  final project = projects[index];
                  return ProjectCard(project: project);
                },
              ),
              8.verticalSpace,
              buildSliderIndicator(projectIndex.value,
                  length: projects.length > 4 ? 4 : projects.length),
              10.verticalSpace,
            ],
          )
        : SizedBox.shrink());
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectElements project;
  final bool isVertical;

  const ProjectCard(
      {super.key, required this.project, this.isVertical = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.projectDetailsScreen, arguments: {
        "projectId": project.projectId,
        "isPreview": false,
      }),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: isVertical ? 0 : 16.h),
        padding: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
                child: _buildProjectImage(project)),
            _buildChip(project),
            _buildContent(project),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectImage(ProjectElements project) {
    if (project.projectImages.isEmpty) {
      return Image.asset(AppResources.placeholder,
          height: 200.h, width: double.infinity, fit: BoxFit.cover);
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
                      height: 200.h, width: double.infinity, fit: BoxFit.cover)
                  : Image.asset(AppResources.placeholder,
                      height: 200.h, width: double.infinity, fit: BoxFit.cover);
            },
          ),
          Center(
              child: SvgPicture.asset(AppResources.playIcon,
                  width: 33.w, height: 33.h)),
        ],
      );
    }

    return CachedImage(
        image: image.mediaUrl, height: 200.h, width: double.infinity);
  }

  Widget _buildChip(ProjectElements project) {
    final label = Utils.isArabic
        ? project.associationNameArabic
        : project.associationName;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Chip(
        label: Text(label ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.darkBrownColor)),
        backgroundColor: AppColors.chipBackgroundColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildContent(ProjectElements project) {
    final projectName =
        Utils.isArabic ? project.projectNameArabic : project.projectName;
    final homeViewModel = Get.find<HomeViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: RemindMeButton(
                onPressed: () =>
                    homeViewModel.remindMe(project.projectId ?? 0))),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(projectName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDarkBrownColor)),
        ),
        10.verticalSpace,
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ProgressBarContent(project: project)),
      ],
    );
  }
}
