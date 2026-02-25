import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/faq_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class FaqPreviewScreen extends GetView<FaqPreviewViewModel> {
  const FaqPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "faqPreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          LabelTextField(
            controller: controller.title,
            label: "title",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.titleArabic,
            label: "titleArabic",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.category,
            label: "category",
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.answer,
            label: "answer",
            maxLines: 5,
            readOnly: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.answerArabic,
            label: "answerArabic",
            maxLines: 5,
            readOnly: true,
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
                    request: controller.request!, message: "faqAccepted");
              }
            : null,
        onReturn: controller.showReturn
            ? () => Utils.openRejectionScreen(
                  title: "faqReturn",
                  request: controller.request!,
                )
            : null,
        onReject: controller.showReject
            ? () => Utils.openRejectionScreen(
                title: "faqRejection",
                request: controller.request!,
                isRejected: true)
            : null,
      );
    });
  }
}
