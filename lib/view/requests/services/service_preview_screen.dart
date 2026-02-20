import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/view_model/service_preview_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/html_to_string_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ServicePreviewScreen extends GetView<ServicePreviewViewModel> {
  const ServicePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "servicePreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => controller.service.value != null
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
                textFieldLabel(label: "description"),
                4.verticalSpace,
                buildHtmlContainer(Utils.isArabic
                    ? controller.service.value!.descriptionAr
                    : controller.service.value!.descriptionEn),
                10.verticalSpace,
                textFieldLabel(label: "procedures"),
                4.verticalSpace,
                buildHtmlContainer(Utils.isArabic
                    ? controller.service.value!.procedureAr
                    : controller.service.value!.proceduresEn),
                10.verticalSpace,
                textFieldLabel(label: "termsOfUse"),
                4.verticalSpace,
                buildHtmlContainer(Utils.isArabic
                    ? controller.service.value!.termsOfUseAr
                    : controller.service.value!.termsOfUseEn),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.fees,
                  label: "serviceFees",
                  readOnly: true,
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.duration,
                  label: "duration",
                  readOnly: true,
                ),
                10.verticalSpace,
                textFieldLabel(label: "serviceChannels"),
                4.verticalSpace,
                buildHtmlContainer(Utils.isArabic
                    ? controller.service.value!.serviceChannelsAr
                    : controller.service.value!.serviceChannelsEn),
                10.verticalSpace,
                textFieldLabel(label: "theTargetAudience"),
                4.verticalSpace,
                buildHtmlContainer(Utils.isArabic
                    ? controller.service.value!.targetAudienceAr
                    : controller.service.value!.targetAudienceEn),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.support,
                  label: "support",
                  readOnly: true,
                ),
                10.verticalSpace,
                Text(
                  "frequentlyAskedQuestions".tr,
                  style: AppTextStyle.secondaryPrimaryBlack26spTextStyle,
                ),
                10.verticalSpace,
                faqListView(),
                20.verticalSpace,
                _buildBottomActions()
              ],
            )
          : const SizedBox.shrink()),
    );
  }

  Widget faqListView() {
    return Obx(() => ExpansionPanelList(
          elevation: 0,
          dividerColor: AppColors.lightGrey,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (int index, bool isExpanded) {
            if (controller.preIndex != -1) {
              controller.subFaqs[controller.preIndex].isExpanded = false;
            }
            controller.preIndex = index;
            controller.subFaqs[index].isExpanded = isExpanded;
            controller.subFaqs.refresh();
          },
          children: controller.subFaqs.value.map<ExpansionPanel>((FaQs faq) {
            return ExpansionPanel(
              canTapOnHeader: true,
              backgroundColor: Colors.white,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    Utils.isArabic ? faq.questionArabic : faq.question,
                    style: AppTextStyle.primaryBlack16spTextStyle,
                  ),
                );
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.isArabic ? faq.answerArabic : faq.answer,
                    style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
                  ),
                  const Divider(
                    color: AppColors.lightGrey,
                  ),
                ],
              ),
              isExpanded: faq.isExpanded,
            );
          }).toList(),
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
                    request: controller.request!, message: "serviceAccepted");
              }
            : null,
        onReturn: controller.showReturn
            ? () => Utils.openRejectionScreen(
                  title: "serviceReturn",
                  request: controller.request!,
                )
            : null,
        onReject: controller.showReject
            ? () => Utils.openRejectionScreen(
                title: "serviceRejection",
                request: controller.request!,
                isRejected: true)
            : null,
        onPreview: () {
          Get.toNamed(AppRoutes.serviceDetails, arguments: {
            "service": controller.service.value,
            "showPreview": true
          });
        },
      );
    });
  }
}
