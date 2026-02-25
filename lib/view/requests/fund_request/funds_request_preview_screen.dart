import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/funds_request_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class FundsRequestPreviewScreen extends GetView<FundsRequestPreviewViewModel> {
  const FundsRequestPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "fundRequestPreview"),
      bottomNavigationBar:_buildBottomActions(),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            LabelTextField(
              controller: controller.donorName,
              label: "association",
              readOnly: true,
            ),
            10.verticalSpace,
            LabelTextField(
              controller: controller.availableAmount,
              label: "availableAmount",
              readOnly: true,
            ),
            10.verticalSpace,
            LabelTextField(
              controller: controller.requestedAmount,
              label: "requestedAmount",
              readOnly: true,
            ),
            10.verticalSpace,
            if (controller.user.isAdmin)
              Obx(() =>
                  IgnorePointer(
                    ignoring: controller.request?.status != 1,
                    child: LabelDropDown(
                      items: controller.banks.value,
                      isRequired: true,
                      selectedValue: controller.selectedBank.value,
                      onChanged: (value) =>
                      controller.selectedBank.value = value,
                      label: 'bankName',
                      hint: 'chooseAnOption',
                    ),
                  )),
          ],
        ),
      ),
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
            if (!controller.formKey.currentState!.validate()) {
              return;
            }
            Utils.showLoadingDialog();
            int accountId = controller.sahemBanks
                .firstWhere((bank) =>
            bank.bankName == controller.selectedBank.value)
                .id;
            Get.find<RequestsViewModel>().approveRejectRequest(
                request: controller.request!,
                message: "fundAccepted",
                accountId: accountId);
          }
              : null,
          onReturn: controller.showReturn
              ? () =>
              Utils.openRejectionScreen(
                title: "fundReturn",
                request: controller.request!,
              )
              : null,
          onReject: controller.showReject
              ? () =>
              Utils.openRejectionScreen(
                  title: "fundRejection",
                  request: controller.request!,
                  isRejected: true)
              : null,
        ),
      );
    });
  }

}
