import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/pdf_helper.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/payment_method_view_model.dart';
import 'package:zakat_fund/view_model/payment_receipt_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/please_note_container.dart';
import 'package:zakat_fund/widgets/receipt_project_widgets.dart';

class PaymentReceiptScreen extends GetView<PaymentReceiptViewModel> {
  const PaymentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "paymentReceipt"),
      body: SingleChildScrollView(
        child: controller.transactionDetails?.requestStatus == 2
            ? _buildReceiptBody()
            : paymentFailed(),
      ),
    );
  }

  Widget paymentFailed(
          {String? title,
          String? message,
          bool success = false,
          bool isNew = false}) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: AppColors.warningBackColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border(
            left: Utils.isArabic
                ? BorderSide.none
                : BorderSide(
                    color: success
                        ? AppColors.darkerGreenColor
                        : AppColors.lightBrownColor,
                    width: 2.w),
            right: Utils.isArabic
                ? BorderSide(
                    color: success
                        ? AppColors.darkerGreenColor
                        : AppColors.lightBrownColor,
                    width: 2.w)
                : BorderSide.none,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          isThreeLine: title != null && message != null && !isNew,
          dense: title != null && message != null && !isNew,
          titleTextStyle: success
              ? AppTextStyle.darkerGreen14spTextStyle
              : message == null
                  ? AppTextStyle.secondaryPrimaryBlack14spTextStyle
                  : AppTextStyle.darkBrown16spTextStyle,
          subtitleTextStyle: AppTextStyle.secondaryPrimaryBlack12spTextStyle,
          title: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              "paymentFailed".tr,
              style: AppTextStyle.red14spTextStyle,
            ),
          ),
        ),
      );

  Widget _buildReceiptBody() {
    switch (controller.type) {
      case 0:
        return _cashReceipt();
      case 1:
        return _chequeReceipt();
      case 2:
        return _depositReceipt();
      default:
        return _genericReceipt();
    }
  }

  Widget _receiptContainer({
    required String titleKey,
    required List<DashboardData> data,
    bool showQr = false,
    bool showCollectionPoint = false,
    String? collectionPoint,
    bool showChequeImage = false,
    String? chequeImage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(titleKey.tr,
                      style: AppTextStyle.secondaryPrimaryBlack20spTextStyle2)),
              if (showQr) ...[
                16.horizontalSpace,
                _qrCodeWidget(),
              ]
            ],
          ),
          16.verticalSpace,
          ..._buildDetailsList(data),
          if (showCollectionPoint && collectionPoint != null) ...[
            8.verticalSpace,
            Text("collectionPoint".tr,
                style: AppTextStyle.secondaryBlack14spTextStyle3),
            8.verticalSpace,
            Text(collectionPoint,
                style: AppTextStyle.secondaryBlack14spTextStyle1),
          ],
          if (showChequeImage && chequeImage != null) ...[
            8.verticalSpace,
            Text("chequePhoto".tr,
                style: AppTextStyle.secondaryBlack16spTextStyle3),
            8.verticalSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child:
                  CachedImage(image: chequeImage, width: 275.w, height: 158.h),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildDetailsList(List<DashboardData> details) {
    return List.generate(details.length, (index) {
      final data = details[index];
      return Column(
        children: [
          _buildReceiptDetailsLabel(data.title, data.value),
          if (index != details.length - 1) 8.verticalSpace,
        ],
      );
    });
  }

  Widget _genericReceipt() {
    final details = controller.transactionDetails!;
    final receiptDetails = [
      DashboardData(
          title: "transactionId", value: details.transactionId.toString()),
      DashboardData(
          title: "paymentDate",
          value: Utils.dateFormat1.format(details.createdDate)),
      DashboardData(
          title: "paymentAmount",
          value: "${details.totalAmount} ${"currency".tr}"),
    ];
    return Column(
      children: [
        pleaseNoteContainer(
            title: "paymentSuccessTitle",
            message: "paymentSuccessMessage",
            success: true),
        _receiptContainer(titleKey: "transactionDetails", data: receiptDetails),
        buildProjectContainear(details),
        _downloadButton(),
        130.verticalSpace,
      ],
    );
  }

  Widget _cashReceipt() {
    final details = controller.transactionDetails!;
    final receiptDetails = [
      DashboardData(
          title: "transactionId", value: details.transactionId.toString()),
      DashboardData(
          title: "paymentAmount",
          value: "${details.totalAmount} ${"currency".tr}"),
      DashboardData(
          title: "collectionDate",
          value: Utils.dateFormat1.format(details.collectionDate)),
      DashboardData(title: "collectionTiming", value: details.collectionTime),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pleaseNoteContainer(
            title: "cashCollectionSuccessTitle",
            message: "cashCollectionSuccessMessage",
            success: true),
        _receiptContainer(
          titleKey: "cashCollectionDetails",
          data: receiptDetails,
          showQr: true,
          showCollectionPoint: true,
          collectionPoint: details.collectionPoint,
        ),
        buildProjectContainear(details),
        _downloadButton(),
        130.verticalSpace,
      ],
    );
  }

  Widget _chequeReceipt() {
    final details = controller.transactionDetails!;
    LookupData bank =
        Get.find<PaymentMethodViewModel>().selectedBankCheck.value!;
    final bankName = Utils.isArabic ? bank.nameAr : bank.name;
    final receiptDetails = [
      DashboardData(
          title: "transactionId", value: details.transactionId.toString()),
      DashboardData(title: "bankName", value: bankName),
      DashboardData(title: "chequeNumber", value: details.chequeNo),
      DashboardData(
          title: "chequeAmount",
          value: "${details.totalAmount} ${"currency".tr}"),
      DashboardData(
          title: "chequeDate",
          value: Utils.dateFormat1.format(details.chequeDate)),
      DashboardData(
          title: "collectionDate",
          value: Utils.dateFormat1.format(details.collectionDate)),
      DashboardData(title: "collectionTiming", value: details.collectionTime),
    ];
    return Column(
      children: [
        pleaseNoteContainer(
            title: "chequeCollectionSuccessTitle",
            message: "chequeCollectionSuccessMessage",
            success: true),
        _receiptContainer(
          titleKey: "chequeCollectionDetails",
          data: receiptDetails,
          showQr: true,
          showCollectionPoint: true,
          collectionPoint: details.collectionPoint,
          showChequeImage: true,
          chequeImage: details.chequePhoto,
        ),
        buildProjectContainear(details),
        _downloadButton(),
        130.verticalSpace,
      ],
    );
  }

  Widget _depositReceipt() {
    final details = controller.transactionDetails!;
    final bankName = Get.find<PaymentMethodViewModel>()
        .selectedBankTransfer
        .value
        .toString();
    final receiptDetails = [
      DashboardData(
          title: "transactionId", value: details.transactionId.toString()),
      DashboardData(title: "bankName", value: bankName),
      DashboardData(title: "receiptNumber", value: details.chequeNo),
      DashboardData(
          title: "paymentAmount",
          value: "${details.totalAmount} ${"currency".tr}"),
      DashboardData(
          title: "paymentDate",
          value: Utils.dateFormat1.format(details.chequeDate)),
      DashboardData(title: "email", value: details.email),
      DashboardData(title: "phoneNumber", value: details.phoneNumber),
      DashboardData(title: "payersName", value: details.payersName),
    ];
    return Column(
      children: [
        pleaseNoteContainer(
            title: "depositCollectionSuccessTitle",
            message: "depositCollectionSuccessMessage",
            success: true),
        _receiptContainer(
            titleKey: "depositDetails", data: receiptDetails, showQr: true),
        buildProjectContainear(details),
        _downloadButton(),
        130.verticalSpace,
      ],
    );
  }

  Row _buildReceiptDetailsLabel(String key, String value) {
    final textWidget = Text(
      value,
      style: AppTextStyle.secondaryBlack14spTextStyle1,
      textAlign: TextAlign.end,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key.tr, style: AppTextStyle.secondaryBlack14spTextStyle),
        60.horizontalSpace,
        Flexible(
          child: (Utils.isArabic &&
                  (key == "phoneNumber" || key == "collectionTiming"))
              ? Directionality(
                  textDirection: TextDirection.ltr, child: textWidget)
              : textWidget,
        ),
      ],
    );
  }

  Widget _qrCodeWidget() {
    final transactionId = controller.transactionDetails?.transactionId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CachedImage(
          image:
              "${FlavorConfig.baseUrl.replaceAll("api/", "")}/TransactionsQR/$transactionId.png",
          width: 85.w,
          height: 85.h,
          showPlaceHolder: true,
          profile: true,
        ),
        Text(
          controller.transactionDetails!.uniqueCode,
          style: AppTextStyle.secondaryBlack14spTextStyle1,
        ),
      ],
    );
  }

  Widget _downloadButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.w, color: AppColors.darkBrownColor),
          minimumSize: Size(Get.width, 45.h),
        ),
        onPressed: () {
          Utils.showLoadingDialog();
          final details = controller.transactionDetails!;
          bool isCompany =
              userBox.isNotEmpty && userBox.getAt(0).roles[0] == "Companies";
          PDFHelper.generateDonationReceiptPdf(details, isCompany);
        },
        icon: SvgPicture.asset(AppResources.downloadIcon,
            width: 20.w, height: 20.h, color: AppColors.darkBrownColor),
        label: Text(
          "download".tr,
          style: AppTextStyle.primaryDarkBrown16spTextStyle1,
        ),
      ),
    );
  }
}
