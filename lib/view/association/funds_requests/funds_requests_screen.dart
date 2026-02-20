import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/association_fund_requests.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/funds_requests_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/status_chip.dart';
import 'package:zakat_fund/widgets/text_field_widget.dart';

class FundsRequestsScreen extends GetView<FundsRequestsViewModel> {
  const FundsRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "fundsRequests"),
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(context, controller.keyboardActionsItem),
        autoScroll: false,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              _buildSummaryGrid(),
              10.verticalSpace,
              _buildAmountTextField(),
              16.verticalSpace,
              _buildSubmitRequestBtn(),
              16.verticalSpace,
              _buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  Obx _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.requests.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) {
            return _buildRequestsItem(index);
          },
        ));
  }

  Container _buildRequestsItem(int index) {
    AssociationFundRequest request = controller.requests[index];
    String status = Utils.statusIntoString(request.fundTransferStatus);
    List<DashboardData> projectDetails = [
      DashboardData(title: "requestId", value: request.id.toString()),
      DashboardData(
          title: "amount", value: "${"currency".tr} ${request.amount.toInt()}"),
      DashboardData(
          title: "date", value: Utils.dateFormat1.format(request.createdDate)),
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
            alignment:
                Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statusChip(status),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          const Divider(height: 0, color: AppColors.lightGrey),
          10.verticalSpace,
          Column(
            children: projectDetails
                .map((data) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          65.horizontalSpace,
                          Flexible(
                            child: Text(data.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle
                                    .secondaryPrimaryBlack12spTextStyle1),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitRequestBtn() {
    return elevatedButton(
        text: "submitTransferRequest",
        onPressed: () {
          controller.transferDialog();
        });
  }

  Form _buildAmountTextField() {
    return Form(
      key: controller.formKey,
      child: TextFieldWidget(
        hint: "100",
        white: true,
        focusNode: controller.amountNode,
        controller: controller.amount,
        amount: true,
        validator: (val) {
          if (val.toString().trim().isEmpty ||
              int.parse(val.toString()) < 100) {
            return "atLeastFundAmount".tr;
          }
          if (int.parse(val.toString()) >
              int.parse(controller.summaryList[3].value)) {
            return "${"amount".tr} ${"isInvalid".tr}";
          }
          return null;
        },
        onChanged: (val) {
          if (!controller.formKey.currentState!.validate()) {
            return;
          }
        },
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return Obx(() => Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: controller.summaryList
          .map((data) => Container(
        width: (Get.width - 42.w) / 2,
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title.tr,
                    style: AppTextStyle
                        .secondaryPrimaryBlack12spTextStyle),
                Text(
                  "${"currency".tr} ${data.value}",
                  style: AppTextStyle.lightBrown16spTextStyle,
                ),
              ],
            ),
          ))
          .toList(),
    ));
  }

}
