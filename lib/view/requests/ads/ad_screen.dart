import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/ad_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/pop_up.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AdScreen extends GetView<AdViewModel> {
  const AdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTextField(
                controller: controller.adTypeController,
                label: "adType",
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.titleController,
                label: "title",
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.languageController,
                label: "language",
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.expiryDateController,
                label: "popUpExpiry",
                isArabicDirection: true,
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.publishTimeController,
                label: "publishScheduleTime",
                isArabicDirection: true,
                readOnly: true,
              ),
              if (controller.ads.value?.adType == 2) ...[
                10.verticalSpace,
                LabelTextField(
                  controller: controller.durationController,
                  label: "displayDurationInSeconds",
                  readOnly: true,
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.popUpCloseController,
                  label: "popUpCloseButton",
                  readOnly: true,
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.popUpPositionController,
                  label: "popUpPosition",
                  readOnly: true,
                ),
                if (controller.ads.value?.icon != null &&
                    controller.ads.value?.icon != "")
                  ..._buildIcon(),
              ],
              if (controller.ads.value?.adsImage != null &&
                  controller.ads.value?.adsImage != "")
                ..._buildAdImage(),
              if (controller.ads.value?.adType == 1) ..._buildBannerText(),
              10.verticalSpace,
              LabelTextField(
                controller: controller.detailsController,
                label: "description",
                readOnly: true,
                maxLines: 4,
              ),
              20.verticalSpace,
              _buildBottomActions(),
            ],
          )),
    );
  }

  List<Widget> _buildIcon() {
    return [
      10.verticalSpace,
      textFieldLabel(label: "icon"),
      6.verticalSpace,
      CachedImage(
          image: controller.ads.value?.icon,
          width: 52.w,
          isCover: false,
          height: 52.h)
    ];
  }

  List<Widget> _buildAdImage() {
    return [
      10.verticalSpace,
      textFieldLabel(label: "adImage"),
      6.verticalSpace,
      GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.photoViewScreen,
            arguments: controller.ads.value!.adsImage ?? ""),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: CachedImage(
              image: controller.ads.value!.adsImage!,
              width: Get.width,
              height: 200.h),
        ),
      )
    ];
  }

  List<Widget> _buildBannerText() {
    return [
      10.verticalSpace,
      textFieldLabel(label: "bannerTextColor"),
      6.verticalSpace,
      Container(
        width: Get.width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
            color: AppColors.lightGreyColor,
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(
                width: 1.w, color: AppColors.secondaryLightGreyColor)),
        child: CircleAvatar(
          radius: 10.r,
          backgroundColor:
              Utils.hexToColor(controller.ads.value!.bannerTextColor),
        ),
      )
    ];
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
                      request: controller.request!,
                      message: controller.ads.value?.adType == 1
                          ? "bannerAdAccepted"
                          : "popUpAdAccepted");
                }
              : null,
          onReturn: controller.showReturn
              ? () => Utils.openRejectionScreen(
                    title: controller.ads.value?.adType == 1
                        ? "bannerAdReturn"
                        : "popUpAdReturn",
                    request: controller.request!,
                  )
              : null,
          onReject: controller.showReject
              ? () => Utils.openRejectionScreen(
                  title: controller.ads.value?.adType == 1
                      ? "bannerAdRejection"
                      : "popUpAdRejection",
                  request: controller.request!,
                  isRejected: true)
              : null,
          onPreview: () => Navigator.of(
                Get.context!,
              ).push(
                PageRouteBuilder(
                  opaque: false,
                  fullscreenDialog: true,
                  pageBuilder: (_, __, ___) =>
                      PopUpDialog(ads: controller.ads.value!),
                ),
              ));
    });
  }
}
