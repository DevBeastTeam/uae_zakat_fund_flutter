import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/view_model/transaction_request_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class TransactionRequestScreen extends GetView<TransactionRequestViewModel> {
  const TransactionRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "transactionRequest"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            if (controller.request?.requestType == "Bank Cheque")
              _buildChequeTransactionInformation(),
            if (controller.request?.requestType == "Deposit")
              _buildDepositTransactionInformation(),
            if (controller.request?.requestType == "Cash")
              _buildCashTransactionInformation(),
            if (controller.request?.requestType != "Deposit")
              _buildCollectionInformation(
                  isCheque: controller.request?.requestType == "Bank Cheque"),
            20.verticalSpace,
            _buildBottomActions()
          ],
        ),
      ),
    );
  }

  Widget _buildDepositTransactionInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "depositBankAccountInformation",
              isExpanded: controller.showTransactionInfo.value,
              onTap: () => controller.onTapDepositTransactionInformation(),
            ),
            if (controller.showTransactionInfo.value)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.bankName,
                    readOnly: true,
                    label: "bankName",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.chequeNumber,
                    readOnly: true,
                    label: "receiptNumber",
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: LabelTextField(
                          controller: controller.paymentDate,
                          readOnly: true,
                          label: "paymentDate",
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: LabelTextField(
                          controller: controller.paymentAmount,
                          readOnly: true,
                          amountOnly: true,
                          label: "paymentAmount",
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.email,
                    readOnly: true,
                    label: "email",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.phoneNumber,
                    readOnly: true,
                    isArabicDirection: true,
                    label: "phoneNumber",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.payersName,
                    readOnly: true,
                    label: "payersName",
                  ),
                  10.verticalSpace,
                  textFieldLabel(label: "depositReceipt"),
                  8.verticalSpace,
                  Obx(() => GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.photoViewScreen,
                            arguments: controller.photo.value ?? ""),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedImage(
                            image: controller.photo.value ?? "",
                            width: 200.w,
                            height: 140.h,
                          ),
                        ),
                      ))
                ],
              )
          ],
        ));
  }

  Widget _buildChequeTransactionInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "bankChequeInformation",
              isExpanded: controller.showTransactionInfo.value,
              onTap: () => controller.onTapDepositTransactionInformation(),
            ),
            if (controller.showTransactionInfo.value)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.bankName,
                    readOnly: true,
                    label: "bankName",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.chequeNumber,
                    readOnly: true,
                    label: "chequeNumber",
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: LabelTextField(
                          controller: controller.chequeDate,
                          readOnly: true,
                          label: "chequeDate",
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: LabelTextField(
                          controller: controller.paymentAmount,
                          readOnly: true,
                          amountOnly: true,
                          label: "amount",
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  textFieldLabel(label: "chequePhoto"),
                  8.verticalSpace,
                  Obx(() => GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.photoViewScreen,
                            arguments: controller.photo.value ?? ""),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedImage(
                            image: controller.photo.value ?? "",
                            width: 200.w,
                            height: 140.h,
                          ),
                        ),
                      ))
                ],
              )
          ],
        ));
  }

  Widget _buildCashTransactionInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "cashTransactionInformation",
              isExpanded: controller.showTransactionInfo.value,
              onTap: () => controller.onTapDepositTransactionInformation(),
            ),
            if (controller.showTransactionInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: LabelTextField(
                          controller: controller.requestId,
                          readOnly: true,
                          label: "requestId",
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: LabelTextField(
                          controller: controller.requestDate,
                          readOnly: true,
                          label: "requestDate",
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.requestName,
                    readOnly: true,
                    label: "requestorName",
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: LabelTextField(
                          controller: controller.requestTypeController,
                          readOnly: true,
                          label: "requestType",
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: LabelTextField(
                          controller: controller.paymentAmount,
                          readOnly: true,
                          amountOnly: true,
                          label: "paymentAmount",
                        ),
                      ),
                    ],
                  ),
                ],
              )
          ],
        ));
  }

  Widget _buildCollectionInformation({bool isCheque = false}) {
    return Obx(() => Column(
          children: [
            16.verticalSpace,
            expansionTileHeader(
              title: isCheque
                  ? "bankChequePointInformation"
                  : "cashCollectionPointInformation",
              isExpanded: controller.showCollectionInfo.value,
              onTap: () => controller.onTapCollectionPointInformation(),
            ),
            if (controller.showCollectionInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.address,
                    readOnly: true,
                    maxLines: 2,
                    label: "address",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.collectionDate,
                    readOnly: true,
                    label: "collectionDate",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.collectionTime,
                    readOnly: true,
                    isArabicDirection: true,
                    label: "collectionTime",
                  ),
                ],
              )
          ],
        ));
  }

  Widget depositAccountInformation() {
    return Obx(() => Column(
          children: [
            16.verticalSpace,
            expansionTileHeader(
              title: "depositBankAccountInformation",
              isExpanded: controller.showCollectionInfo.value,
              onTap: () => controller.onTapCollectionPointInformation(),
            ),
            if (controller.showCollectionInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.bankAccount,
                    readOnly: true,
                    label: "bankAccountDetails",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.ibanNumber,
                    readOnly: true,
                    label: "ibanNumber",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.branchType,
                    readOnly: true,
                    label: "branchType",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.branchCode,
                    readOnly: true,
                    label: "branchCode",
                  ),
                ],
              )
          ],
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
                  if (controller.request?.requestType == "Deposit" ||
                      controller.request?.status == 9) {
                    Utils.showLoadingDialog();
                    Get.find<RequestsViewModel>().approveRejectRequest(
                        request: controller.request!,
                        message: controller.request?.requestType == "Cash"
                            ? "cashAccepted"
                            : controller.request?.requestType == "Deposit"
                                ? "depositAccepted"
                                : "bankChequeCollectionAccepted");
                  } else {
                    controller.assignDialog();
                  }
                }
              : null,
          onReturn: controller.showReject
              ? () => Utils.openRejectionScreen(
                    title: "depositReturn",
                    request: controller.request!,
                  )
              : null,
          onReject: controller.showReject
              ? () => Utils.openRejectionScreen(
                  title: "depositRejection",
                  request: controller.request!,
                  isRejected: true)
              : null,
          btnText: controller.request?.requestType == "Deposit" ||
                  controller.request?.status == 9
              ? null
              : "acceptAndAssign");
    });
  }
}
