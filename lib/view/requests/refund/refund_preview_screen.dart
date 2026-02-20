import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/refund_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class RefundPreviewScreen extends GetView<RefundPreviewViewModel> {
  const RefundPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "refundRequestPreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          LabelTextField(
            controller: controller.requestId,
            label: "requestId",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.requestDate,
            label: "requestDate",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.refundType,
            label: "refundType",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.refundAmount,
            label: "refundAmount",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.totalDonation,
            label: "totalDonationAmount",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.donorName,
            label: "donorName",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.transactionId,
            label: "transactionId",
            readOnly: true,
          ),
          10.verticalSpace,
          _buildProjects(),
          16.verticalSpace,
          _buildBottomActions(),
        ],
      ),
    );
  }

  Obx _buildProjects() {
    return Obx(() => Column(
              children: List.generate(
                controller.projects.length,
                (index) {
                  Detail project = controller.projects[index];
                  String name = Utils.isArabic
                      ? project.projectNameArabic
                      : project.projectName;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelTextField(
                        controller: TextEditingController(text: name),
                        label: "projects",
                        maxLines: 2,
                        showLabel: index == 0,
                        readOnly: true,
                      ),
                      8.verticalSpace,
                    ],
                  );
                },
              ),
            ));
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
                    request: controller.request!, message: "refundAccepted");
              }
            : null,
        onReturn: controller.showReturn
            ? () => Utils.openRejectionScreen(
                  title: "refundReturn",
                  request: controller.request!,
                )
            : null,
        onReject: controller.showReject
            ? () => Utils.openRejectionScreen(
                title: "refundRejection",
                request: controller.request!,
                isRejected: true)
            : null,
      );
    });
  }
}
