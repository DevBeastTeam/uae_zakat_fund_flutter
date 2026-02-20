import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/my_wallet.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/my_wallet_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';

class MyWalletScreen extends GetView<MyWalletViewModel> {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "myWallet"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => Column(
            children: [
              _buildAvailableBalance(),
              16.verticalSpace,
              _buildTopUpWalletBtn(),
              16.verticalSpace,
              _buildSearchFilter()
            ],
          )),
    );
  }

  Container _buildSearchFilter() {
    return searchAddContainer(
        noContainer: true,
        controller: controller.searchController,
        onChanged: (_) => controller.filterWalletById(),
        child: _buildListView(),
        onFilterPressed: () => controller.filterBottomSheet());
  }

  ListView _buildListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.myWallet.value.walletTopupDetail.length,
      separatorBuilder: (_, int index) => 16.verticalSpace,
      itemBuilder: (_, int index) {
        WalletTopupDetail transaction =
            controller.myWallet.value.walletTopupDetail[index];
        return _buildItem(transaction);
      },
    );
  }

  Container _buildItem(WalletTopupDetail transaction) {
    List<DashboardData> details = [
      DashboardData(title: "transactionId", value: transaction.transactionId),
      DashboardData(
          title: "date", value: Utils.dateFormat1.format(transaction.date)),
      DashboardData(
          title: "amount",
          value: "${"currency".tr} ${transaction.amount.toInt()}"),
      if (transaction.refundAmount > 0)
        DashboardData(
            title: "refundAmount",
            value: "${"currency".tr} ${transaction.refundAmount.toInt()}"),
      DashboardData(title: "paymentMethod", value: "cardPayment".tr),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: popupMenuButton(
                  onSelected: (String item) => controller.onPopupMenuSelected(
                      item, transaction.transactionId),
                  menuItems: [
                    popupMenuItem(
                        label: "view",
                        icon: AppResources.eyeIcon,
                        textStyle: AppTextStyle.darkBrown14spTextStyle)
                  ]),
            ),
          ),
          10.verticalSpace,
          const Divider(
            height: 0,
            color: AppColors.lightGrey,
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                style:
                                    AppTextStyle.primaryDarkGrey12spTextStyle1,
                              ),
                              Flexible(
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    details[dataIndex].value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle
                                        .secondaryPrimaryBlack12spTextStyle1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          4.verticalSpace,
                        ],
                      )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpWalletBtn() {
    return elevatedButton(
        text: "topUpYourWallet", onPressed: () => controller.topUpWallet());
  }

  Container _buildAvailableBalance() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border:
            Border.all(width: 1.w, color: AppColors.secondaryLightGreyColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: ListTile(
        selected: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        selectedTileColor: controller.availableBalance.backColor,
        leading: SvgPicture.asset(controller.availableBalance.icon!,
            width: 24.w, height: 24.h),
        title: Text(controller.availableBalance.title.tr,
            style: controller.availableBalance.style),
        trailing: Text(
          controller.availableBalance.value,
          style: AppTextStyle.secondaryBlack14spTextStyle3,
        ),
      ),
    );
  }
}
