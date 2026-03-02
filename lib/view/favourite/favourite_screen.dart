import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/favourite_project.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/favourite_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/tabbar_widget_v2.dart';

class FavouriteScreen extends GetView<FavouriteViewModel> {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: myAppBar(title: "favourites"),
      body: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(),
        _buildTabBarView(),
      ],
    );
  }

  Expanded _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: controller.tabViewController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildProjectListView(),
          _buildNewsListView(),
          _buildServicesListView(),
        ],
      ),
    );
  }

  Obx _buildTabBar() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: TabBarWidgetV2(
          tabs: controller.tabs,
          currentIndex: controller.currentTabIndex.value,
          onTabChanged: (index) {
            controller.currentTabIndex.value = index;
            controller.tabViewController.animateTo(index);
          },
        ),
      ),
    );
  }

  Widget _buildProjectListView() {
    return Obx(() => GridView.builder(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 230.h,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.h,
          ),
          itemCount: controller.projects.length,
          itemBuilder: (BuildContext context, int index) {
            FavouriteProject project = controller.projects[index];
            return _buildProjectItem(project, context, index);
          },
        ));
  }

  GestureDetector _buildProjectItem(
      FavouriteProject project, BuildContext context, int index) {
    return GestureDetector(
      onTap: () => controller.openProjectDetailsScreen(project.projectId),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: _buildImage(project.projectImage),
                  ),
                ),
                Positioned(
                  top: 2.w,
                  left: 2.w,
                  child: GestureDetector(
                    onTap: () => controller.addProjectFavorite(index),
                    child: Container(
                      width: 24.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: themeViewModel.color,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.bookmark,
                          color: AppColors.lightWhiteColor,
                          size: 18.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement remind me functionality if available
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
                  controller.quickDonateFromFavourite(project);
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

  Widget _buildNewsListView() {
    return Obx(() => GridView.builder(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 230.h,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.h,
          ),
          itemCount: controller.news.length,
          itemBuilder: (BuildContext context, int index) {
            News news = controller.news[index];
            return _buildNewsItem(news, index);
          },
        ));
  }

  GestureDetector _buildNewsItem(News news, int index) {
    return GestureDetector(
      onTap: () => controller.openNewsDetailsScreen(news.newsId!),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: _buildImage(news.thumbNail),
                  ),
                ),
                Positioned(
                  top: 8.w,
                  left: 8.w,
                  child: GestureDetector(
                    onTap: () => controller.addProjectFavorite(index),
                    child: Container(
                      width: 24.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: themeViewModel.color,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.bookmark,
                          color: AppColors.lightWhiteColor,
                          size: 18.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                controller.dateFormat.format(news.createdDate),
                style: AppTextStyle.darkGreyOne12spTextStyle,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 50.h,
              child: Text(
                Utils.isArabic ? news.titleAr : news.titleEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.secondaryPrimaryBlack12spTextStyle2,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  "View Details".tr,
                  style: AppTextStyle.secondaryDarkBrownColor12spTextStyle,
                ),
                SizedBox(width: 4.w),
                Icon(
                  Utils.isArabic ? Icons.arrow_back : Icons.arrow_forward,
                  size: 14.sp,
                  color: AppColors.secondaryDarkBrownColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesListView() {
    return Obx(() => ListView.separated(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          itemCount: controller.services.length,
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (BuildContext context, int index) =>
              16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            OurServices service = controller.services[index];
            return _buildServiceItem(service, index);
          },
        ));
  }

  GestureDetector _buildServiceItem(OurServices service, int index) {
    return GestureDetector(
      onTap: () => controller.openServiceDetailsScreen(service),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0.0, 4.0),
              blurRadius: 150.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.isArabic ? service.titleAr : service.titleEn,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.secondaryBlack20spTextStyle,
                ),
                8.verticalSpace,
                8.verticalSpace,
                Text(
                  Utils.htmlToPlainText(Utils.isArabic
                      ? service.descriptionAr
                      : service.descriptionEn),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.darkGrey16spTextStyle,
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  buildIconButton(
                    color: themeViewModel.color,
                    icon: AppResources.shareColorIcon,
                    onPressed: () => Utils.sharePlainText(
                        "${FlavorConfig.webSiteUrl}service/${service.serviceId}"),
                  ),
                  IconButton(
                    icon: Icon(
                      service.isFavorite
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: themeViewModel.color,
                    ),
                    onPressed: () => controller.addServiceFavorite(index),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return url.isEmpty
        ? Image.asset(AppResources.placeholder,
            height: 84.h, width: 117.w, fit: BoxFit.cover)
        : CachedImage(image: url, height: 84.h, width: 117.w);
  }
}
