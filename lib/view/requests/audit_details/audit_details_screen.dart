import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/audit_details_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/table_widget.dart';

class AuditDetailsScreen extends GetView<AuditDetailsViewModel> {
  const AuditDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "updateApproval"),
      bottomNavigationBar: _buildBottomActions(),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => controller.auditLogs.value != null
          ? Column(
              children: [
                _buildHeader(),
                16.verticalSpace,
                TableWidget(
                    auditDetails: controller.auditLogs.value!.auditLogDetails),
              ],
            )
          : SizedBox.shrink()),
    );
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
          Utils.isArabic
              ? controller.request!.requestTypeAr
              : controller.request!.requestType,
          style: AppTextStyle.secondaryBlack16spTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.w, color: AppColors.lightBrownColor2),
          ),
          onPressed: () => controller.openPreviewScreen(),
          label: Text(
            "actualValues".tr,
            maxLines: 1,
            style: AppTextStyle.lightBrown16spTextStyle,
          ),
          icon: const Icon(
            Icons.visibility_rounded,
            color: AppColors.lightBrownColor2,
          ),
        )
      ],
    );
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if(!controller.isAdmin.value){
        return SizedBox.shrink();
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, -4.0),
              blurRadius: 100.0,
            ),
          ],
        ),
        child: acceptRejectBottomBar(
            onAccept: controller.showAccept
                ? () {
                    Utils.showLoadingDialog();
                    int? accountId;
                    if (controller.auditLogs.value?.entityTypeEn ==
                            "Association" ||
                        controller.auditLogs.value?.entityTypeEn == "Company") {
                      accountId = controller.request?.accountID;
                    }
                    Get.find<RequestsViewModel>().approveRejectRequest(
                        accountId: accountId,
                        request: controller.request!,
                        message: "requestAccepted");
                  }
                : null,
            onReturn: controller.showReturn
                ? () => Utils.openRejectionScreen(
                      title: "return",
                      request: controller.request!,
                    )
                : null,
            onReject: controller.showReject
                ? () => Utils.openRejectionScreen(
                    title: "rejection",
                    request: controller.request!,
                    isRejected: true)
                : null,
          ),
      );
    });
  }
}
