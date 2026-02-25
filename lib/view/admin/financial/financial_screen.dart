import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/association/association_dashboard/pie_chart.dart';
import 'package:zakat_fund/view_model/financial_view_model.dart';
import 'package:zakat_fund/widgets/donut_summry_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class FinancialScreen extends GetView<FinancialDashboardViewModel> {
  const FinancialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "financial"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildDateTextField(),
          _buildSummary(),
          _buildPaymentMethodsChart(),
          _buildPendingCollectionsChart(),
        ],
      ),
    );
  }

  Obx _buildPendingCollectionsChart() {
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
                "pendingCollections".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
              ),
              25.verticalSpace,
              Stack(
                alignment: Alignment.center,
                children: [
                  DonutChart(
                    data: controller.pendingCollectionsChart.value,
                    centerSpaceRadius: 60,
                    radius: 25,
                  ),
                  totalDonutSummaryText(
                      title: 'pendingCollections',
                      value:
                          "${"currency".tr} ${controller.pendingCollections.value}"),
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
                      controller.pendingCollectionsChart.length,
                      (index) => Indicator(
                          color: controller
                              .pendingCollectionsChart[index].backColor!,
                          text: controller.pendingCollectionsChart[index].title
                              .toLowerCase(),
                          percentage:
                              "${"currency".tr} ${controller.pendingCollectionsChart[index].value}")),
                ),
              ),
            ],
          ),
        ));
  }

  Obx _buildPaymentMethodsChart() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "paymentMethods".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
              ),
              25.verticalSpace,
              DonutChart(
                data: controller.paymentMethodsChart.value,
                centerSpaceRadius: 60,
                radius: 25,
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
                      controller.paymentMethodsChart.length,
                      (index) => Indicator(
                          color:
                              controller.paymentMethodsChart[index].backColor!,
                          text: controller.paymentMethodsChart[index].title
                              .toLowerCase(),
                          percentage:
                              "${(controller.paymentMethodsChart[index].valueInDouble! * 100).toStringAsFixed(1)}%")),
                ),
              ),
            ],
          ),
        ));
  }

  Obx _buildSummary() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          margin: EdgeInsets.symmetric(vertical: 16.h),
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
                  if (controller.dashboardData.length - 1 != index)
                    10.verticalSpace,
                ],
              );
            }).toList(),
          ),
        ));
  }

  Align _buildDateTextField() {
    return Align(
      alignment: Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
      child: SizedBox(
        width: 290,
        child: LabelTextField(
          label: "",
          onTap: () => controller.datePicker(),
          readOnly: true,
          showLabel: false,
          isNewDate: true,
          isArabicDirection: Utils.isArabic,
          isBackWhite: true,
          controller: controller.dateRange,
          hint: "${"startDate".tr} - ${"endDate".tr}",
        ),
      ),
    );
  }
}
