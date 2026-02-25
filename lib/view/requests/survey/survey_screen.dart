import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/view_model/survey_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/html_to_string_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class SurveyScreen extends GetView<SurveyViewModel> {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "surveyPagePreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          LabelTextField(
            controller: controller.surveyName,
            readOnly: true,
            label: "surveyName",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.pageLink,
            readOnly: true,
            label: "pageLink",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.responseLimit,
            readOnly: true,
            label: "responseLimit",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.language,
            readOnly: true,
            label: "language",
          ),
          10.verticalSpace,
          Obx(() => controller.survey.value != null
              ? Column(
                  children: [
                    textFieldLabel(label: "description"),
                    6.verticalSpace,
                    buildHtmlContainer(controller.survey.value!.description),
                    10.verticalSpace,
                    textFieldLabel(label: "instructions"),
                    6.verticalSpace,
                    buildHtmlContainer(controller.survey.value!.instructions),
                    10.verticalSpace,
                  ],
                )
              : const SizedBox.shrink()),
          8.verticalSpace,
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (controller.isAdmin.value) {
        return SizedBox.shrink();
      }
      return acceptRejectBottomBar(
        onAccept: controller.showAccept
            ? () {
                Utils.showLoadingDialog();
                Get.find<RequestsViewModel>().approveRejectRequest(
                    request: controller.request!, message: "surveyPageAccepted");
              }
            : null,
        onReturn: controller.showReturn
            ? () => Utils.openRejectionScreen(
                  title: "surveyPageReturn",
                  request: controller.request!,
                )
            : null,
        onReject: controller.showReject
            ? () => Utils.openRejectionScreen(
                title: "surveyPageRejection",
                request: controller.request!,
                isRejected: true)
            : null,
        // onPreview: () {
        //         // if (Platform.isAndroid) {
        //         Get.toNamed(AppRoutes.webViewScreen, arguments: {
        //           "title": controller.survey.value?.surveyName,
        //           "url":
        //               '${FlavorConfig.webSiteUrl}fill-survey/${controller.survey.value?.pageLink}&lang=${Utils.isArabic ? "ar" : "en"}'
        //         });
        //         // } else {
        //         //   Utils.openUrl(
        //         //       '${FlavorConfig.webSiteUrl}fill-survey/${controller.survey.value?.pageLink}');
        //         // }
        //       }
      );
    });
  }
}
