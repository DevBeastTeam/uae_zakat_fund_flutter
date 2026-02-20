import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/recipients.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/campaign_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class CampaignScreen extends GetView<CampaignViewModel> {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "campaignPreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          LabelTextField(
            controller: controller.campaignName,
            readOnly: true,
            label: "campaignName",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.language,
            readOnly: true,
            label: "language",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.startDate,
            readOnly: true,
            label: "startDate",
            isArabicDirection: true,
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.endDate,
            readOnly: true,
            isArabicDirection: true,
            label: "endDate",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.category,
            readOnly: true,
            label: "category",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.senderName,
            readOnly: true,
            label: "senderName",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.subject,
            readOnly: true,
            label: "subject",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.detailsController,
            readOnly: true,
            label: "description",
            maxLines: 4,
          ),
          10.verticalSpace,
          textFieldLabel(label: "recipients"),
          6.verticalSpace,
          _buildListView(),
          10.verticalSpace,
          _buildBottomActions()
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          itemCount: controller.recipients.length,
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            Recipients recipient = controller.recipients[index];
            List<DashboardData> details = [
              DashboardData(title: "sentTo", value: recipient.userName),
              DashboardData(
                  title: recipient.toAddress.contains("@")
                      ? "email"
                      : "phoneNumber",
                  value: recipient.toAddress),
              DashboardData(
                  title: "language",
                  value: recipient.language.toLowerCase().tr),
            ];

            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.lightGrey)),
              child: Column(
                children: List.generate(
                    details.length,
                    (dataIndex) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  details[dataIndex].title.tr,
                                  style: AppTextStyle
                                      .primaryDarkGrey12spTextStyle1,
                                ),
                                Utils.isArabic &&
                                        details[dataIndex].title ==
                                            "phoneNumber"
                                    ? Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          details[dataIndex].value,
                                          style: AppTextStyle
                                              .secondaryPrimaryBlack12spTextStyle1,
                                        ),
                                      )
                                    : Text(
                                        details[dataIndex].value,
                                        style: AppTextStyle
                                            .secondaryPrimaryBlack12spTextStyle1,
                                      ),
                              ],
                            ),
                            4.verticalSpace,
                          ],
                        )).toList(),
              ),
            );
          },
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
                    request: controller.request!,
                    message: controller.campaign.category == 1
                        ? "emailCampaignAccepted"
                        : "smsCampaignAccepted");
              }
            : null,
        onReturn: controller.showReturn
            ? () => Utils.openRejectionScreen(
                  title: controller.campaign.category == 1
                      ? "emailCampaignReturn"
                      : "smsCampaignReturn",
                  request: controller.request!,
                )
            : null,
        onReject: controller.showReject
            ? () => Utils.openRejectionScreen(
                title: controller.campaign.category == 1
                    ? "emailCampaignRejection"
                    : "smsCampaignRejection",
                request: controller.request!,
                isRejected: true)
            : null,
      );
    });
  }
}
