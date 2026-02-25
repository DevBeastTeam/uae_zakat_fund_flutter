import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/about_us_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/file_view_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AboutUsScreen extends GetView<AboutUsViewModel> {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "aboutAssociationPreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => Column(
            children: [
              LabelTextField(
                controller: controller.titleEnglish,
                label: "titleInEnglish",
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.titleArabic,
                label: "titleInArabic",
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.descriptionEnglish,
                label: "descriptionInEnglish",
                readOnly: true,
                maxLines: 4,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.descriptionArabic,
                label: "descriptionInArabic",
                readOnly: true,
                maxLines: 4,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.beneficiaries,
                label: "beneficiaries",
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.amountRaised,
                label: "amountRaised",
                readOnly: true,
              ),
              10.verticalSpace,
              LabelTextField(
                controller: controller.projectCompleted,
                label: "projectCompleted",
                readOnly: true,
              ),
              if (controller.association.value != null) ...[
                10.verticalSpace,
                textFieldLabel(label: "firstImage"),
                4.verticalSpace,
                fileViewWidget(
                    isImage: true,
                    value: controller.association.value!.firstPicture),
                10.verticalSpace,
                textFieldLabel(label: "secondImage"),
                4.verticalSpace,
                fileViewWidget(
                    isImage: true,
                    value: controller.association.value!.secondPicture),
                20.verticalSpace,
                _buildBottomActions(),
              ]
            ],
          )),
    );
  }

  _buildBottomActions() {
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
                    message: "aboutAssociationAccepted");
              }
            : null,
        onReturn: controller.showReturn
            ? () => Utils.openRejectionScreen(
                  title: "aboutAssociationReturn",
                  request: controller.request!,
                )
            : null,
        onReject: controller.showReject
            ? () => Utils.openRejectionScreen(
                title: "aboutAssociationRejection",
                request: controller.request!,
                isRejected: true)
            : null,
      );
    });
  }
}
