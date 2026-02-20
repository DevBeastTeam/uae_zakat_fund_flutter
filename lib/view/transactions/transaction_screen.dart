import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/transactions.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/transaction_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/statistics_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class TransactionScreen extends GetView<TransactionViewModel> {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      body: _buildBody(),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
      child: SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummary(),
                16.verticalSpace,
                if (controller.user.userName.toLowerCase() ==
                    "dev@gmail.com") ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => controller.addDummyTransaction(),
                      icon: const Icon(Icons.add_circle_outline,
                          color: AppColors.darkBrownColor, size: 30),
                      tooltip: "Add Dummy Receipt",
                    ),
                  ),
                  8.verticalSpace,
                ],
                if (controller.user.isAdmin) ...[
                  Obx(() => buildStatsRow(0, controller.stats)),
                  10.verticalSpace,
                  Obx(() => buildStatsRow(3, controller.stats)),
                  10.verticalSpace,
                  Obx(() => buildStatsRow(6, controller.stats)),
                  16.verticalSpace,
                ],
                _buildTaxCertificateBtn(),
                if (!controller.user.isAdmin) 16.verticalSpace,
                _buildExportFilterRow(),
                if (controller.canView) ...[
                  10.verticalSpace,
                  _buildSearchField(),
                  16.verticalSpace,
                  _buildListView(),
                ],
              ],
            )),
      ),
    );
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.fetchTransactions(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.fetchTransactions(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.fetchTransactions(clear: true);
        }
      },
    );
  }

  Widget _buildExportFilterRow() {
    if (!controller.canView && !controller.canExport) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (controller.canExport)
          Expanded(
            child: expandedChip(
              label: 'export',
              icon: AppResources.exportIcon,
              onPressed: () => controller.exportDonations(),
            ),
          ),
        if (controller.canExport && controller.canView) 16.horizontalSpace,
        if (controller.canView)
          Expanded(
            child: expandedChip(
              label: 'filter',
              icon: AppResources.filterIcon,
              onPressed: () => controller.filterBottomSheet(),
            ),
          ),
      ],
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.transactions.length,
      separatorBuilder: (_, int index) => 16.verticalSpace,
      itemBuilder: (_, int index) {
        Transactions transaction = controller.transactions[index];
        return _buildItem(transaction);
      },
    );
  }

  Container _buildItem(Transactions transaction) {
    final bool isOfflinePayment = transaction.paymentType == 1;
    final bool isRefundEligible = isOfflinePayment &&
        !controller.user.isAdmin &&
        (!transaction.isRefundApplied ||
            (transaction.isRefundApplied && transaction.requestStatus == 7));

    final String status = Utils.statusIntoString(
      isOfflinePayment ? 2 : transaction.requestStatus,
    );

    final List<DashboardData> details = [
      DashboardData(title: 'transactionId', value: transaction.zfTransactionId),
      DashboardData(
        title: 'date',
        value: Utils.dateFormat1.format(transaction.createdDate),
      ),
      DashboardData(
        title: 'amount',
        value: "${"currency".tr} ${transaction.totalAmount}",
      ),
      DashboardData(title: 'method', value: "${transaction.paymentType}"),
    ];

    final List<PopupMenuItem<String>> menuItems = [
      popupMenuItem(
        label: "view",
        icon: AppResources.eyeIcon,
        textStyle: AppTextStyle.darkBrown14spTextStyle,
      ),
      popupMenuItem(
        label: "receipt",
        icon: AppResources.documentIcon,
        textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle2,
      ),
      if (controller.user.userName.toLowerCase() == "dev@gmail.com")
        popupMenuItem(
          label: "View in PDF",
          icon: AppResources.documentIcon,
          textStyle: AppTextStyle.darkBrown14spTextStyle,
        ),
      if (isRefundEligible)
        popupMenuItem(
          label: "refund",
          icon: AppResources.refundIcon,
          textStyle: AppTextStyle.greyDark14spTextStyle,
        ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          listViewHeaderPopUpMenu(
            status: status,
            onSelected: (item) {
              if (item == "View in PDF") {
                controller.fetchTransactionDetails(transaction,
                    isReceipt: true, isPreview: true);
              } else {
                controller.onPopupMenuSelected(item, transaction);
              }
            },
            menuItems: menuItems,
          ),
          10.verticalSpace,
          const Divider(height: 0, color: AppColors.lightGrey),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: details.map((data) {
                final isRtlSensitive = Utils.isArabic && data.title == "date";
                final isMethod = data.title == "method";

                Widget valueWidget;
                if (isMethod) {
                  valueWidget = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        Utils.getPaymentIcon(transaction.paymentType),
                        width: 16.w,
                        height: 16.h,
                      ),
                      4.horizontalSpace,
                      Text(Utils.getPaymentType(transaction.paymentType).tr),
                    ],
                  );
                } else if (isRtlSensitive) {
                  valueWidget = Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      data.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                    ),
                  );
                } else {
                  valueWidget = Flexible(
                    child: Text(
                      data.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.title.tr,
                        style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                      ),
                      16.horizontalSpace,
                      valueWidget,
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxCertificateBtn() {
    if (controller.user.isAdmin) {
      return SizedBox.shrink();
    }
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        backgroundColor: themeViewModel.color,
        minimumSize: Size(Get.width, 45.h),
      ),
      onPressed: () => controller.taxCertificateDialog(),
      label: Text(
        "taxCertificate".tr,
        style: AppTextStyle.white16spTextStyle,
      ),
      icon: SvgPicture.asset(
        AppResources.trackIcon,
        color: Colors.white,
      ),
    );
  }

  FittedBox _buildSummary() {
    return FittedBox(
      child: Obx(() => Row(
            children: [
              statisticsContainer(controller.dashboardData[0]),
              8.horizontalSpace,
              statisticsContainer(controller.dashboardData[1]),
              8.horizontalSpace,
              statisticsContainer(controller.dashboardData[2]),
            ],
          )),
    );
  }
}
