import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/association/association_dashboard/pie_chart.dart';
import 'package:zakat_fund/view_model/donor_dashboard_view_model.dart';
import 'package:zakat_fund/widgets/donut_summry_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class DonorDashboardScreen extends GetView<DonorDashboardViewModel> {
  const DonorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "dashboard"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildDateTextField(),
          16.verticalSpace,
          _buildDashboardSummary(),
          _buildLatestDonationHistory(),
          _buildRefundHistory(),
        ],
      ),
    );
  }

  Obx _buildRefundHistory() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "refundHistory".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
              ),
              25.verticalSpace,
              Stack(
                alignment: Alignment.center,
                children: [
                  DonutChart(
                    data: controller.refundHistoryChart.value,
                    centerSpaceRadius: 60,
                    radius: 25,
                  ),
                  totalDonutSummaryText(
                      title: 'refundAmount',
                      value: controller.totalRefund.value),
                ],
              ),
              16.verticalSpace,
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: List.generate(
                      controller.refundHistoryChart.length,
                      (index) => Indicator(
                          color:
                              controller.refundHistoryChart[index].backColor!,
                          text: controller.refundHistoryChart[index].title,
                          percentage:
                              controller.refundHistoryChart[index].value)),
                ),
              ),
            ],
          ),
        ));
  }

  Obx _buildLatestDonationHistory() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          margin: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "latestDonationHistory".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
              ),
              25.verticalSpace,
              Stack(
                alignment: Alignment.center,
                children: [
                  DonutChart(
                    data: controller.donationHistoryChart.value,
                    centerSpaceRadius: 60,
                    radius: 25,
                  ),
                  totalDonutSummaryText(
                      title: 'totalAmount',
                      value: controller.totalAmount.value),
                ],
              ),
              16.verticalSpace,
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: List.generate(
                      controller.donationHistoryChart.length,
                      (index) => Indicator(
                          color:
                              controller.donationHistoryChart[index].backColor!,
                          text: controller.donationHistoryChart[index].title,
                          percentage:
                              controller.donationHistoryChart[index].value)),
                ),
              ),
            ],
          ),
        ));
  }

  Obx _buildDashboardSummary() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: Column(
            children: List.generate(controller.dashboardData.length, (index) {
              DashboardData data = controller.dashboardData[index];
              return Column(
                children: [
                  ListTile(
                    selected: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    selectedTileColor: data.backColor,
                    leading:
                        SvgPicture.asset(data.icon!, width: 24.w, height: 24.h),
                    title: Text(data.title.tr, style: data.style),
                    trailing: Text(
                      data.value,
                      style: AppTextStyle.secondaryBlack14spTextStyle3,
                    ),
                  ),
                  10.verticalSpace,
                ],
              );
            }).toList(),
          ),
        ));
  }

  SizedBox _buildDateTextField() {
    return SizedBox(
      width: 290,
      child: LabelTextField(
        controller: controller.dateRange,
        label: "date",
        hint: "${"startDate".tr} - ${"endDate".tr}",
        showLabel: false,
        isBackWhite: true,
        isNewDate: true,
        isArabicDirection: Utils.isArabic,
        readOnly: true,
        onTap: () => controller.datePicker(),
      ),
    );
  }
}
