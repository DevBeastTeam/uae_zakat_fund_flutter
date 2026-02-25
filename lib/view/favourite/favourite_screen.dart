import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/favourite_project.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/our_services.dart';
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
    return Obx(() => ListView.separated(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          itemCount: controller.projects.length,
          separatorBuilder: (BuildContext context, int index) =>
              16.verticalSpace,
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
        height: 116.h,
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
        child: Row(
          children: [
            _buildImage(project.projectImage),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  left: Utils.isArabic ? 0 : 16.w,
                  right: Utils.isArabic ? 16.w : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.isArabic
                        ? project.projectNameArabic
                        : project.projectName,
                    maxLines: 2,
                    style: TextStyle(
                        color: AppColors.darkBrownColor,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  8.verticalSpace,
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50.r)),
                      child: LinearProgressIndicator(
                        minHeight: 4.h,
                        color: AppColors.darkBrownColor,
                        backgroundColor: AppColors.progressBarBackgroundColor,
                        value: project.percentOfCompletion != null
                            ? project.percentOfCompletion / 100
                            : 0,
                      )),
                  8.verticalSpace,
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontFamily: 'Alexandria'),
                      children: <TextSpan>[
                        TextSpan(
                          text: "remaining".tr,
                          style: TextStyle(
                              color: AppColors.secondaryDarkGreyColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Alexandria',
                              fontSize: 12.sp),
                        ),
                        TextSpan(
                          text:
                              " ${Utils.getCurrency(project.remainingAmount.toInt())} ${"currency".tr}",
                          style: TextStyle(
                              fontFamily: "Inter",
                              color: AppColors.secondaryBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            IconButton(
                onPressed: () => controller.addProjectFavorite(index),
                icon: SvgPicture.asset(AppResources.starFillIcon))
          ],
        ),
      ),
    );
  }

  Widget _buildNewsListView() {
    return Obx(() => ListView.separated(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          itemCount: controller.news.length,
          separatorBuilder: (BuildContext context, int index) =>
              16.verticalSpace,
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
        height: 116.h,
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
        child: Row(
          children: [
            _buildImage(news.thumbNail),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  left: Utils.isArabic ? 0 : 16.w,
                  right: Utils.isArabic ? 16.w : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.isArabic ? news.titleAr : news.titleEn,
                    maxLines: 2,
                    style: TextStyle(
                        color: AppColors.darkBrownColor,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  8.verticalSpace,
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      controller.dateFormat.format(news.createdDate),
                      style: AppTextStyle.darkGreyOne12spTextStyle,
                    ),
                  ),
                ],
              ),
            )),
            IconButton(
                onPressed: () => controller.addNewsFavorite(index),
                icon: SvgPicture.asset(AppResources.starFillIcon))
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.isArabic ? service.titleAr : service.titleEn,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.secondaryBlack20spTextStyle,
            ),
            8.verticalSpace,
            Row(
              children: [
                buildIconButton(
                  icon: service.isFavorite
                      ? AppResources.starFillIcon
                      : AppResources.starIcon,
                  onPressed: () => controller.addServiceFavorite(index),
                ),
                buildIconButton(
                  color: AppColors.darkBrownColor,
                  icon: AppResources.shareColorIcon,
                  onPressed: () => Utils.sharePlainText(
                      "${FlavorConfig.webSiteUrl}service/${service.serviceId}"),
                ),
              ],
            ),
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
      ),
    );
  }

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(
        left: !Utils.isArabic ? Radius.circular(20.r) : Radius.zero,
        right: Utils.isArabic ? Radius.circular(20.r) : Radius.zero,
      ),
      child: url.isEmpty
          ? Image.asset(AppResources.placeholder,
              width: 120.w, height: 116.h, fit: BoxFit.cover)
          : CachedImage(image: url, width: 120.w, height: 116.h),
    );
  }
}
