import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/notifications_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class NotificationsPreviewScreen extends GetView<NotificationsPreviewViewModel> {
  const NotificationsPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "notificationPreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTextField(
            controller: controller.titleInEnglish,
            label: "titleInEnglish",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.titleInArabic,
            label: "titleInArabic",
            readOnly: true,
          ),
          10.verticalSpace,
          Obx(() => controller.notification.value != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.notification.value!.imageName!.isNotEmpty)
                      textFieldLabel(label: 'image'),
                    if (controller.notification.value!.imageName!.isNotEmpty)
                      4.verticalSpace,
                    if (controller.notification.value!.imageName!.isNotEmpty)
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.photoViewScreen,
                            arguments:
                                controller.notification.value!.imageName ?? ""),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedImage(
                            image: controller.notification.value!.imageName!,
                            width: Get.width,
                            height: 200.h,
                          ),
                        ),
                      ),
                    if (controller.notification.value!.imageName!.isNotEmpty)
                      10.verticalSpace,
                    textFieldLabel(label: 'icon'),
                    4.verticalSpace,
                    SvgPicture.asset(
                      controller.notification.value?.iconName == "3"
                          ? AppResources.warningIcon1
                          : AppResources.notificationIcon,
                      width: 48.w,
                      height: 48.h,
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.publishScheduleTime,
                      label: "publishScheduleTime",
                      readOnly: true,
                    ),
                    10.verticalSpace,
                  ],
                )
              : SizedBox.shrink()),
          LabelTextField(
            controller: controller.descInEnglish,
            label: "descriptionInEnglish",
            readOnly: true,
            maxLines: 4,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.descInArabic,
            label: "descriptionInArabic",
            readOnly: true,
            maxLines: 4,
          ),
          20.verticalSpace,
          _buildBottomActions()
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if(!controller.isAdmin.value){
        return SizedBox.shrink();
      }
      return acceptRejectBottomBar(
          onAccept: controller.showAccept
              ? () {
                  Utils.showLoadingDialog();
                  Get.find<RequestsViewModel>().approveRejectRequest(
                      request: controller.request!,
                      message: "notificationAccepted");
                }
              : null,
          onReturn: controller.showReturn
              ? () => Utils.openRejectionScreen(
                    title: "notificationReturn",
                    request: controller.request!,
                  )
              : null,
          onReject: controller.showReject
              ? () => Utils.openRejectionScreen(
                  title: "notificationRejection",
                  request: controller.request!,
                  isRejected: true)
              : null,
          onPreview: () => controller
              .notificationDetailsDialog(controller.notification.value!));
    });
  }
}
