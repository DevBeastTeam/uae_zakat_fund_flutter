import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/news_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/file_view_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class NewsPreviewScreen extends GetView<NewsPreviewViewModel> {
  const NewsPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "newsPreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => controller.news.value != null
          ? Column(
              children: [
                LabelTextField(
                  controller: controller.title,
                  label: "title",
                  readOnly: true,
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.category,
                  label: "category",
                  readOnly: true,
                ),
                10.verticalSpace,
                textFieldLabel(
                    label: Utils.isArabic
                        ? "briefDescriptionInArabic"
                        : "briefDescriptionInEnglish"),
                4.verticalSpace,
                Container(
                  width: Get.width,
                  constraints: BoxConstraints(maxHeight: 110.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          width: 1.w,
                          color: AppColors.secondaryLightGreyColor)),
                  child: HtmlWidget(
                    "${Utils.isArabic ? controller.news.value?.descriptionShortAR : controller.news.value?.descriptionShortEN}",
                    renderMode: RenderMode.listView,
                    textStyle: AppTextStyle.secondaryBlack14spTextStyle1,
                  ),
                ),
                10.verticalSpace,
                textFieldLabel(label: "description"),
                4.verticalSpace,
                Container(
                  width: Get.width,
                  constraints: BoxConstraints(maxHeight: 110.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          width: 1.w,
                          color: AppColors.secondaryLightGreyColor)),
                  child: HtmlWidget(
                    "${Utils.isArabic ? controller.news.value?.descriptionAr : controller.news.value?.descriptionEn}",
                    renderMode: RenderMode.listView,
                    textStyle: AppTextStyle.secondaryBlack14spTextStyle1,
                  ),
                ),
                10.verticalSpace,
                textFieldLabel(label: "theFirstPicture"),
                4.verticalSpace,
                fileViewWidget(
                    isImage: true,
                    value: "${controller.news.value?.firstPicture}"),
                10.verticalSpace,
                textFieldLabel(label: "theSecondPicture"),
                4.verticalSpace,
                fileViewWidget(
                    isImage: true,
                    value: "${controller.news.value?.secondPicture}"),
                10.verticalSpace,
                textFieldLabel(label: "thumbnail"),
                4.verticalSpace,
                fileViewWidget(
                    isImage: true,
                    value: "${controller.news.value?.thumbNail}"),
                20.verticalSpace,
                _buildBottomActions()
              ],
            )
          : const SizedBox.shrink()),
    );
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (!controller.isAdmin.value) {
        return SizedBox.shrink();
      }
      return acceptRejectBottomBar(
          onAccept: controller.showAccept
              ? () {
                  Utils.showLoadingDialog();
                  Get.find<RequestsViewModel>().approveRejectRequest(
                      request: controller.request!, message: "newsAccepted");
                }
              : null,
          onReturn: controller.showReturn
              ? () => Utils.openRejectionScreen(
                    title: "newsRejection",
                    request: controller.request!,
                  )
              : null,
          onReject: controller.showReject
              ? () => Utils.openRejectionScreen(
                  title: "newsRejection",
                  request: controller.request!,
                  isRejected: true)
              : null,
          onPreview: () {
            Get.toNamed(AppRoutes.newsDetailScreen, arguments: {
              "id": controller.news.value?.id,
              "preview": true,
              "allNews": false
            });
          });
    });
  }
}
