import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/association_detail_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/contact_us_widget.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/row_header.dart';
import 'package:zakat_fund/widgets/section_header.dart';
import 'package:zakat_fund/widgets/slider_indicator.dart';

import '../../../widgets/project_card.dart';

class AssociationDetailsScreen extends GetView<AssociationDetailViewModel> {
  const AssociationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackColor,
      appBar: myAppBar(title: "associations"),
      body: _buildBody(),
    );
  }

  Obx _buildBody() {
    return Obx(() {
      final association = controller.association.value;
      if (association == null) return const SizedBox.shrink();

      return KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(association),
              20.verticalSpace,
              _buildAboutUsSection(),
              20.verticalSpace,
              SectionHeader(
                  title: "ourCurrentProjects",
                  onViewAll: () {
                    Get.toNamed(AppRoutes.allProjectsScreen, arguments: {
                      "projects": controller.allProjects,
                      "title": "projects",
                    });
                  }),
              Obx(() => SizedBox(
                    height: 215.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemBuilder: (BuildContext context, int index) =>
                          ProjectCard(
                        project: controller.projects[index],
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          10.horizontalSpace,
                      itemCount: controller.projects.length,
                    ),
                  )),
              20.verticalSpace,
              // SectionHeader(
              //     title: "latestNewsEvents",
              //     onViewAll: () {
              //       Get.toNamed(AppRoutes.allNewsScreen);
              //     }),
              // Container(
              //   height: 52.h,
              //   margin: EdgeInsets.symmetric(
              //     horizontal: 16.w,
              //   ),
              //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(24.r),
              //       border: Border.all(color: AppColors.lightGrey),
              //       color: Colors.white),
              //   child: Obx(() => ListView.separated(
              //         scrollDirection: Axis.horizontal,
              //         itemBuilder: (BuildContext context, int index) {
              //           final category = controller.categoriesList[index];
              //           return GestureDetector(
              //             onTap: () => controller.filterLatestNews(category),
              //             child: Obx(() {
              //               return Container(
              //                 padding: EdgeInsets.symmetric(horizontal: 10.w),
              //                 alignment: Alignment.center,
              //                 decoration: controller.selectedNewsCat.value ==
              //                         category
              //                     ? BoxDecoration(
              //                         borderRadius: BorderRadius.circular(24.r),
              //                         color: AppColors.secondaryDarkBrownColor
              //                             .withValues(alpha: 0.12))
              //                     : null,
              //                 child: Text(
              //                   Utils.isArabic
              //                       ? category.nameAr
              //                       : category.name,
              //                   style: AppTextStyle
              //                       .secondaryDarkBrownColor14spTextStyle,
              //                 ),
              //               );
              //             }),
              //           );
              //         },
              //         separatorBuilder: (BuildContext context, int index) =>
              //             16.horizontalSpace,
              //         itemCount: controller.categoriesList.length,
              //       )),
              // ),
              // 20.verticalSpace,
              // Obx(() => SizedBox(
              //       height: 166.h,
              //       child: ListView.separated(
              //         padding: EdgeInsets.symmetric(horizontal: 16.w),
              //         scrollDirection: Axis.horizontal,
              //         itemBuilder: (BuildContext context, int index) =>
              //             GestureDetector(
              //                 child: NewsCard(
              //           news: controller.news[index],
              //           all: false,
              //         )),
              //         separatorBuilder: (BuildContext context, int index) =>
              //             10.horizontalSpace,
              //         itemCount: controller.news.length > 10
              //             ? 10
              //             : controller.news.length,
              //       ),
              //     )),

              _buildContactUsSection(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAssociationName(Project association) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        Utils.isArabic
            ? association.accountNameArabic
            : association.accountName,
        style: AppTextStyle.white32spTextStyle.copyWith(height: 0),
      ),
    );
  }

  Widget _buildAssociationDescription(Project association) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Text(
        Utils.isArabic
            ? association.associationDescriptionAR ?? ''
            : association.associationDescriptionEN ?? '',
        style: AppTextStyle.white14spTextStyle1,
      ),
    );
  }

  Widget _buildSocialIcons(Project association) {
    final icons = [
      if (association.facebook != null)
        _buildSocialIcon(AppResources.facebookLink, association.facebook!),
      if (association.instagram != null)
        _buildSocialIcon(AppResources.instagramLink, association.instagram!),
      if (association.linkedIn != null)
        _buildSocialIcon(AppResources.linkedinLink, association.linkedIn!),
      if (association.twitter != null)
        _buildSocialIcon(AppResources.twitterLink, association.twitter!),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(children: icons),
    );
  }

  Widget _buildSocialIcon(String iconPath, String url) {
    return buildIconButton(
      isLink: true,
      icon: iconPath,
      color: Colors.white,
      onPressed: () => Utils.openUrl(url),
    );
  }

  Widget _buildProjectCountChip() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Chip(
        label: Obx(() => Text(
              "${controller.projectsCount} ${'projects'.tr}",
              style: AppTextStyle.primaryDarkBrown14spTextStyle2,
            )),
        backgroundColor: AppColors.chipBackgroundColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        side: BorderSide.none,
        visualDensity: VisualDensity.compact,
        avatarBoxConstraints:
            BoxConstraints.tightFor(width: 14.w, height: 14.h),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildContactUsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.verticalSpace,
          Text("stayInTouch".tr,
              style: AppTextStyle.secondaryPrimaryBlack26spTextStyle1),
          16.verticalSpace,
          _buildAssociationAvatar(controller.association.value?.accountLogo),
          16.verticalSpace,
          ContactUsWidget(controller.association.value),
        ],
      ),
    );
  }

  Widget _buildProjectsSlider() {
    return Obx(() {
      if (controller.projects.isEmpty && controller.allProjects.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          buildHeader(
            title: 'projects',
            onPressed: () =>
                Get.toNamed(AppRoutes.allProjectsScreen, arguments: {
              "projects": controller.allProjects,
              "title": "projects",
            }),
          ),
        ],
      );
    });
  }

  Widget _buildNewsSlider() {
    return Obx(() {
      if (controller.news.isEmpty) return const SizedBox.shrink();

      final newsList = controller.news.take(4).toList();

      return Column(
        children: [
          16.verticalSpace,
          buildHeader(
            title: 'news',
            onPressed: () => Get.toNamed(AppRoutes.allNewsScreen),
          ),
          16.verticalSpace,
          CarouselSlider.builder(
            carouselController: controller.newsCarouselController,
            options: CarouselOptions(
              height: 380.h,
              viewportFraction: 1,
              onPageChanged: (index, reason) =>
                  controller.updateNewsIndicator(index),
              enableInfiniteScroll: false,
            ),
            itemCount: newsList.length,
            itemBuilder: (context, index, _) => _buildNewsItem(newsList[index]),
          ),
          buildSliderIndicator(controller.newsIndex.value,
              length: newsList.length),
          10.verticalSpace,
        ],
      );
    });
  }

  Widget _buildNewsItem(News news) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.newsDetailScreen, arguments: {
        "id": news.id,
        "allNews": false,
      }),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              child: news.thumbNail.isNotEmpty
                  ? CachedImage(
                      image: news.thumbNail,
                      width: Get.width,
                      height: 200.h,
                    )
                  : Image.asset(AppResources.placeholder,
                      width: Get.width, height: 200.h, fit: BoxFit.cover),
            ),
            _buildNewsTextSection(news),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsTextSection(News news) {
    return Container(
      height: 165.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r)),
        border: Border.all(color: AppColors.lightGrey, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            controller.dateFormat.format(news.createdDate),
            style: AppTextStyle.darkGreyOne12spTextStyle,
          ),
          8.verticalSpace,
          Text(
            Utils.isArabic ? news.titleAr : news.titleEn,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.secondaryBlack16spTextStyle,
          ),
          2.verticalSpace,
          Text(
            Utils.isArabic
                ? Utils.htmlToPlainText(news.descriptionShortAR)
                : Utils.htmlToPlainText(news.descriptionShortEN),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.secondaryBlack14spTextStyle1,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutUsSection() {
    return Obx(() {
      if (controller.aboutUs.isEmpty) return const SizedBox.shrink();
      final about = controller.aboutUs[0];

      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("aboutUs".tr,
                style: AppTextStyle.secondaryPrimaryBlack32spTextStyle2),
            16.verticalSpace,
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.greyBackColor),
                child: Column(
                  children: [
                    _buildProjectsCompleted(about.projectsCompleted),
                    16.verticalSpace,
                    Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.white),
                        child: Column(
                          children: [
                            _buildColumn(
                                AppResources.donationIcon,
                                "beneficiaries",
                                Utils.formatWithPlus('5000000000')),
                            20.verticalSpace,
                            _buildColumn(AppResources.moneyIcon, "collected",
                                Utils.getCurrency(about.amountRaised)),
                          ],
                        )),
                    if (about.firstPicture.isNotEmpty) ...[
                      16.verticalSpace,
                      buildAboutUsImage(about.firstPicture)
                    ],
                  ],
                )),
            16.verticalSpace,
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.greyBackColor),
                child: Column(
                  children: [
                    Text(Utils.isArabic ? about.titleAr : about.titleEn,
                        style:
                            AppTextStyle.secondaryPrimaryBlack32spTextStyle2),
                    16.verticalSpace,
                    HtmlWidget(
                      Utils.isArabic
                          ? about.descriptionAr
                          : about.descriptionEn,
                      textStyle:
                          AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
                    ),
                    if (about.secondPicture.isNotEmpty) ...[
                      16.verticalSpace,
                      buildAboutUsImage(about.secondPicture),
                    ],
                  ],
                )),
          ],
        ),
      );
    });
  }

  Widget _buildProjectsCompleted(int projectsCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getCurrency(projectsCompleted),
          style: AppTextStyle.secondaryPrimaryBlack48spTextStyle,
        ),
        8.verticalSpace,
        Text(
          "projectComplete".tr,
          style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
        ),
      ],
    );
  }

  ClipRRect buildAboutUsImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: CachedImage(image: image, height: 300.h, width: Get.width),
    );
  }

  Widget _buildHeader(Project association) {
    return Stack(
      // alignment: AlignmentGeometry.center,
      alignment: AlignmentDirectional.center,
      children: [
        association.associationCoverPhoto != null
            ? CachedImage(
                image: association.associationCoverPhoto!,
                width: Get.width,
                height: 500.h)
            : Image.asset(AppResources.placeholder,
                width: Get.width, height: 500.h, fit: BoxFit.cover),
        Container(
            color: Colors.black.withValues(alpha: 0.4),
            width: Get.width,
            height: 500.h),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAssociationName(association),
              16.verticalSpace,
              _buildAssociationDescription(association),
              16.verticalSpace,
              _buildSocialIcons(association),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child:
                    elevatedButton(text: "exploreProjects", onPressed: () {}),
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'readMore'.tr,
                      style: AppTextStyle.white14spTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackButton(),
        if (userBox.isNotEmpty) _buildNotificationButton(),
      ],
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: Get.back,
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(
              color: Colors.black, offset: Offset(0.0, 4.0), blurRadius: 150.0),
        ]),
        child: SvgPicture.asset(
          Utils.isArabic
              ? AppResources.arrowCircleRightIcon
              : AppResources.arrowCircleLeftIcon,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.notificationScreen),
      child: Container(
        width: 40.w,
        height: 40.h,
        padding: EdgeInsets.all(12.w),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 4.0),
                blurRadius: 150.0),
          ],
        ),
        child: SvgPicture.asset(AppResources.notificationIcon),
      ),
    );
  }

  Widget _buildAssociationAvatar(String? logoUrl) {
    return logoUrl != null
        ? CachedImage(
            image: logoUrl,
            width: 200.w,
            height: 100.h,
            isCover: false,
          )
        : Image.asset(AppResources.placeholder,
            width: 148.w, height: 40.h, fit: BoxFit.cover);
  }

  Widget _buildCategorySlider() {
    return SizedBox(
      height: 72.h,
      child: Obx(() => ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: controller.homeViewModel.categoriesList.length,
            separatorBuilder: (_, __) => 8.horizontalSpace,
            itemBuilder: (context, index) {
              final isSelected = controller.categoryIndex.value == index;
              final category = controller.homeViewModel.categoriesList[index];
              final label = Utils.isArabic ? category.nameAr : category.name;

              return GestureDetector(
                onTap: () => controller.filterProjects(index),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primaryBlackColor : Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: Offset(0, 4),
                          blurRadius: 15),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryBlackColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildColumn(String icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          icon,
          width: 60.w,
          height: 60.h,
        ),
        16.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              style: AppTextStyle.secondaryDarkBrownColor26spTextStyle
                  .copyWith(height: 0),
            ),
            Text(
              title.tr,
              style:
                  AppTextStyle.lightBlackColor20TextStyle.copyWith(height: 0),
            ),
          ],
        ),
      ],
    );
  }
}
