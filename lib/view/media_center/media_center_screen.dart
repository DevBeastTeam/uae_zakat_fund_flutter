import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/media_center_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';

class MediaCenterScreen extends GetView<MediaCenterViewModel> {
  const MediaCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: myAppBar(title: "mediaCenter"),
        body: _buildBody());
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildLatestNews(), _buildArchiveNews()],
      ),
    );
  }

  Obx _buildArchiveNews() {
    return Obx(() => !controller.haveArchiveNews.value
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ourNewsArchive".tr,
                style: AppTextStyle.secondaryPrimaryBlack18spTextStyle,
              ),
              16.verticalSpace,
              searchAddContainer(
                  noContainer: true,
                  child: Column(
                    children: [
                      10.verticalSpace,
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 16.h),
                        itemCount: controller.archiveNews.length,
                        separatorBuilder: (BuildContext context, _) =>
                            16.verticalSpace,
                        itemBuilder: (BuildContext context, int index) {
                          News news = controller.archiveNews[index];
                          return newsItem(news, showDesc: false);
                        },
                      ),
                    ],
                  ),
                  controller: controller.archiveSearchController,
                  onClear: () {
                    controller.archiveSearchController.clear();
                    controller.searchArchiveNews();
                  },
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      controller.searchArchiveNews();
                    }
                  },
                  onFilterPressed: () => controller.filterBottomSheet(),
                  onChanged: (_) {})
            ],
          ));
  }

  Obx _buildLatestNews() {
    return Obx(() => controller.latestNews.isEmpty && controller.allNews.isEmpty
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "latestMediaRelease".tr,
                style: AppTextStyle.secondaryPrimaryBlack18spTextStyle2,
              ),
              16.verticalSpace,
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 16.h),
                itemCount: controller.latestNews.length,
                separatorBuilder: (BuildContext context, _) => 16.verticalSpace,
                itemBuilder: (BuildContext context, int index) {
                  News news = controller.latestNews[index];
                  return newsItem(news);
                },
              ),
            ],
          ));
  }

  GestureDetector newsItem(News news, {bool showDesc = true}) {
    return GestureDetector(
      onTap: () => controller.openNewsDetailsScreen(news.id, !showDesc),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.r),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                child: news.thumbNail != ""
                    ? CachedImage(
                        image: news.thumbNail,
                        width: Get.width,
                        height: 160.h,
                      )
                    : Image.asset(
                        AppResources.placeholder,
                        width: Get.width,
                        height: 160.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      controller.dateFormat.format(news.createdDate),
                      style: AppTextStyle.darkGreyOne14spTextStyle,
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          Utils.isArabic ? news.titleAr : news.titleEn,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextStyle.secondaryPrimaryBlack16spTextStyle2,
                        ),
                      ),
                      8.horizontalSpace,
                      if (userBox.isNotEmpty)
                        GestureDetector(
                            onTap: () =>
                                controller.addToFavorite(news, !showDesc),
                            child: Icon(
                              news.isFavorite
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: AppColors.secondaryDarkBrownColor,
                            )),
                      4.horizontalSpace,
                      Icon(Icons.share_outlined)
                    ],
                  ),
                  if (showDesc) ...[
                    4.verticalSpace,
                    Text(
                      Utils.isArabic
                          ? Utils.htmlToPlainText(news.descriptionShortAR)
                          : Utils.htmlToPlainText(news.descriptionShortEN),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.secondaryBlack14spTextStyle1,
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Text(
                          "viewDetails".tr,
                          style: AppTextStyle
                              .secondaryDarkBrownColor16spTextStyle1,
                        ),
                        8.horizontalSpace,
                        GestureDetector(
                            onTap: () {
                              Utils.logEvent(
                                  name: EventConstant.shareNewsClick);
                              Utils.sharePlainText(
                                  "${FlavorConfig.webSiteUrl}news/${news.id}");
                            },
                            child: Icon(Icons.arrow_forward, size: 16.r))
                      ],
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
