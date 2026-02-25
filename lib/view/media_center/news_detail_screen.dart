import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/news_detail_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/content_helpful_widget.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class NewsDetailScreen extends StatelessWidget {
  NewsDetailScreen({super.key});

  final controller = Get.find<NewsDetailViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: controller.isPreview ? _buildPreviewBottom() : null,
      appBar: myAppBar(title: "newsDetails"),
      body: _buildBody(),
    );
  }

  WillPopScope _buildBody() {
    return WillPopScope(
      onWillPop: () => controller.onWillPopScope(),
      child: SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Obx(() => controller.loading.value
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  8.verticalSpace,
                  if (controller.news.value.publishDate != null) ...[
                    _buildDateText(),
                    16.verticalSpace
                  ],
                  _buildShortDesc(),
                  16.verticalSpace,
                  _buildFirstImage(),
                  20.verticalSpace,
                  _buildLogDesc(),
                  if (controller.news.value.requestStatus == 2) ...[
                    20.verticalSpace,
                    _buildFavShareRow()
                  ],
                  16.verticalSpace,
                  const Divider(color: AppColors.lightGrey1),
                  16.verticalSpace,
                  if (controller.isAllNews) ...[
                    Text(
                      "recentPressReleases".tr,
                      style: AppTextStyle.secondaryPrimaryBlack26spTextStyle1,
                    ),
                    16.verticalSpace,
                    _buildRecentnewsListView()
                  ],
                  16.verticalSpace,
                  if (controller.news.value.requestStatus == 2 ||
                      !controller.isPreview)
                    ContentHelpfulWidget(
                      id: controller.news.value.id,
                      type: "News",
                    ),
                ],
              )),
      ),
    );
  }

  Column _buildRecentnewsListView() {
    return Column(
      children: List.generate(
          controller.newsViewModel.allNews.length > 3
              ? 4
              : controller.newsViewModel.allNews.length, (index) {
        News news = controller.newsViewModel.allNews[index];
        return Column(
          children: [
            GestureDetector(
              onTap: () => controller.viewRecentPressRelease(index, news.id),
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: news.thumbNail != ""
                          ? CachedImage(
                              image: news.thumbNail,
                              width: 110.w,
                              height: 90.h,
                            )
                          : Image.asset(
                              AppResources.placeholder,
                              width: 110.w,
                              height: 90.h,
                              fit: BoxFit.cover,
                            ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              DateFormat(
                                      'dd MMMM yyyy', Get.locale?.languageCode)
                                  .format(news.createdDate),
                              style: AppTextStyle.darkGreyOne14spTextStyle4),
                          8.verticalSpace,
                          Text(
                            Utils.isArabic ? news.titleAr : news.titleEn,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle
                                .secondaryPrimaryBlack16spTextStyle2
                                .copyWith(height: 0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            16.verticalSpace
          ],
        );
      }),
    );
  }

  Row _buildFavShareRow() {
    return Row(
      children: [
        if (userBox.isNotEmpty)
          buildIconButton(
            color: controller.news.value.isFavorite
                ? AppColors.lightBrownColor1
                : AppColors.secondaryPrimaryBlackColor,
            icon: controller.news.value.isFavorite
                ? AppResources.starFillIcon
                : AppResources.starIcon,
            onPressed: () => controller.addToFavorite(),
          ),
        buildIconButton(
          icon: AppResources.shareColorIcon,
          color: AppColors.secondaryPrimaryBlackColor,
          onPressed: () {
            Utils.logEvent(name: EventConstant.shareNewsClick);
            Utils.sharePlainText(
                "${FlavorConfig.webSiteUrl}news/${controller.newsId}");
          },
        ),
      ],
    );
  }

  ClipRRect _buildSecondImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: CachedImage(
          image: controller.news.value.secondPicture,
          width: Get.width,
          height: 350.h,
        ));
  }

  HtmlWidget _buildLogDesc() {
    return HtmlWidget(
      Utils.isArabic
          ? controller.news.value.descriptionAr
          : controller.news.value.descriptionEn,
      renderMode: RenderMode.column,
      textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
    );
  }

  ClipRRect _buildFirstImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: controller.news.value.firstPicture != ""
          ? CachedImage(
              image: controller.news.value.firstPicture,
              width: Get.width,
              height: 350.h,
            )
          : Image.asset(
              AppResources.placeholder,
              width: Get.width,
              fit: BoxFit.cover,
              height: 350.h,
            ),
    );
  }

  HtmlWidget _buildShortDesc() {
    return HtmlWidget(
      Utils.isArabic
          ? controller.news.value.descriptionShortAR
          : controller.news.value.descriptionShortEN,
      renderMode: RenderMode.column,
      textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
    );
  }

  Text _buildDateText() {
    return Text(
      DateFormat('dd MMMM yyyy', Get.locale?.languageCode)
          .format(controller.news.value.publishDate!),
      style: AppTextStyle.darkGreyOne16spTextStyle2,
    );
  }

  Text _buildTitle() {
    return Text(
      Utils.isArabic
          ? controller.news.value.titleAr
          : controller.news.value.titleEn,
      style:
          AppTextStyle.secondaryPrimaryBlack26spTextStyle1.copyWith(height: 0),
    );
  }

  Widget _buildPreviewBottom() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            text: Utils.isArabic ? "previewInEnglish".tr : "previewInArabic".tr,
            onPressed: () =>
                Get.updateLocale(Locale(Utils.isArabic ? "en" : "ar")),
            buttonType: ButtonType.preview,
          ),
          10.verticalSpace,
          CustomButton(
            onPressed: () => controller.showPreview(),
            buttonType: ButtonType.back,
          ),
        ],
      ),
    );
  }
}
