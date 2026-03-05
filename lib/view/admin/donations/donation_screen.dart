import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/association/association_dashboard/line_chart.dart';
import 'package:zakat_fund/view/association/association_dashboard/pie_chart.dart';
import 'package:zakat_fund/view_model/donation_data_view_model.dart';
import 'package:zakat_fund/widgets/donut_summry_widget.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class DonationDataScreen extends GetView<DonationDataViewModel> {
  const DonationDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "donations"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildDateTextField(),
          16.verticalSpace,
          _buildAssociationProjectsRow(),
          _buildDonationTrendChart(),
          _buildDonationStats(),
          _buildReturningDonorChart(),
          _buildDonorsBreakdownChart(),
          16.verticalSpace,
          _buildDonationSummary(),
        ],
      ),
    );
  }

  Container _buildDonationSummary() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        children: List.generate(controller.dashboardData.length, (index) {
          DashboardData data = controller.dashboardData[index];
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                          color: data.labelColor ??
                              data.style?.color ??
                              Colors.transparent,
                          width: 1.w)),
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                          color: data.labelColor ??
                              data.style?.color ??
                              Colors.transparent,
                          width: 1.w)),
                  collapsedBackgroundColor: data.backColor,
                  backgroundColor: data.backColor,
                  title: ListTile(
                    selected: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                          color: data.labelColor ??
                              data.style?.color ??
                              Colors.transparent,
                          width: 1.w),
                    ),
                    selectedTileColor: data.backColor,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(
                      data.title.tr,
                      style: data.style,
                    ),
                    minVerticalPadding: 0,
                  ),
                  expandedAlignment: Alignment.topLeft,
                  children: [
                    if (index == 0) donationsWidget(),
                    if (index == 1) Obx(() => listItem(controller.topProjects)),
                    if (index == 2)
                      Obx(() => listItem(controller.topAssociations)),
                    16.verticalSpace,
                  ],
                ),
              ),
              if (controller.dashboardData.length - 1 != index) 10.verticalSpace
            ],
          );
        }).toList(),
      ),
    );
  }

  Obx _buildDonorsBreakdownChart() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: Column(
            children: [
              Align(
                alignment: Utils.isArabic
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  "donorsBreakdown".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
                ),
              ),
              25.verticalSpace,
              Stack(
                alignment: Alignment.center,
                children: [
                  DonutChart(
                    data: controller.donorsBreakdownChart.value,
                    centerSpaceRadius: 60,
                    radius: 25,
                  ),
                  totalDonutSummaryText(
                      title: 'totalDonors',
                      value: controller.totalDonors.value),
                ],
              ),
              16.verticalSpace,
              Wrap(
                runSpacing: 8,
                spacing: 8,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(
                    controller.donorsBreakdownChart.length,
                    (index) => Indicator(
                        color:
                            controller.donorsBreakdownChart[index].backColor!,
                        text: controller.donorsBreakdownChart[index].title,
                        percentage:
                            controller.donorsBreakdownChart[index].value)),
              ),
              16.verticalSpace,
            ],
          ),
        ));
  }

  Obx _buildReturningDonorChart() {
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
                "firstTimeVsReturningDonors".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
              ),
              25.verticalSpace,
              DonutChart(data: controller.pieChartData.value),
              16.verticalSpace,
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: List.generate(
                    controller.pieChartData.length,
                    (index) => Indicator(
                        color: controller.pieChartData[index].backColor!,
                        text: controller.pieChartData[index].title,
                        percentage:
                            '${controller.pieChartData[index].valueInDouble!.toInt()}%')),
              ),
              16.verticalSpace,
            ],
          ),
        ));
  }

  Obx _buildDonationStats() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: Column(
            children: List.generate(controller.summaryData.length, (index) {
              DashboardData data = controller.summaryData[index];
              return Column(
                children: [
                  ListTile(
                    selected: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                            color: data.labelColor ??
                                data.style?.color ??
                                Colors.transparent,
                            width: 1.w)),
                    selectedTileColor: data.backColor,
                    title: Text(data.title.tr, style: data.style),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: RichText(
                        text: TextSpan(
                            text: data.icon,
                            style: AppTextStyle.secondaryBlack16spTextStyle1
                                .copyWith(fontFamily: 'Alexandria'),
                            children: <TextSpan>[
                              TextSpan(
                                  text: data.value,
                                  style: AppTextStyle.greyDark14spTextStyle1
                                      .copyWith(fontFamily: 'Alexandria'))
                            ]),
                      ),
                    ),
                  ),
                  if (controller.summaryData.length - 1 != index)
                    10.verticalSpace
                ],
              );
            }).toList(),
          ),
        ));
  }

  Container _buildDonationTrendChart() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 16.w, 16.h),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "donationTrendsOverTime".tr,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.lightBrownColor2,
                radius: 4.r,
              ),
              8.horizontalSpace,
              Text(
                "${"donationOverTime".tr} (${"currency".tr})",
                style: AppTextStyle.secondaryGrey12spTextStyle,
              )
            ],
          ),
          16.verticalSpace,
          Row(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'trends'.tr,
                  style: AppTextStyle.secondaryGrey10spTextStyle1,
                ),
              ),
              4.horizontalSpace,
              Obx(() =>
                  controller.months.isNotEmpty && controller.spots.isNotEmpty
                      ? Expanded(
                          child: LineChartWidget(
                          monthsList: controller.months.value,
                          spots: controller.spots.value,
                        ))
                      : SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildAssociationProjectsRow() {
    return Row(
      children: [
        Obx(() => Expanded(
              child: LabelDropDown(
                items: controller.associationList.value,
                showSearch: true,
                isBackWhite: true,
                showLabel: false,
                selectedValue: controller.selectedAssociation.value,
                onChanged: (value) => controller.onAssociationSelected(value!),
                isRequired: true,
                label: '',
                hint: 'chooseAnOption',
              ),
            )),
        8.horizontalSpace,
        Obx(() => Expanded(
              child: LabelDropDown(
                items: controller.projectList.value,
                showSearch: true,
                isBackWhite: true,
                showLabel: false,
                selectedValue: controller.selectedProject.value,
                onChanged: (value) => controller.onProjectSelected(value!),
                isRequired: true,
                label: '',
                hint: 'chooseAnOption',
              ),
            )),
      ],
    );
  }

  Align _buildDateTextField() {
    return Align(
      alignment: Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
      child: SizedBox(
        width: 290,
        child: LabelTextField(
          label: "",
          isArabicDirection: Utils.isArabic,
          onTap: () => controller.datePicker(),
          readOnly: true,
          showLabel: false,
          isNewDate: true,
          isBackWhite: true,
          controller: controller.dateRange,
          hint: "${"startDate".tr} - ${"endDate".tr}",
        ),
      ),
    );
  }

  Widget donationsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => listItem([
              {
                "key": "totalDonations",
                "value":
                    "${"currency".tr} ${Utils.getCurrency(controller.totalDonations.value)}"
              }
            ])),
        Text(
          "donationBreakdownProjects".tr,
          style: AppTextStyle.secondaryBlack14spTextStyle3,
        ),
        4.verticalSpace,
        Obx(() => listItem(controller.donationProjects)),
      ],
    );
  }

  Column listItem(var data) {
    return Column(
      children: List.generate(
          data.length,
          (dataIndex) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          data[dataIndex]["key"].toString().tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                        ),
                      ),
                      16.horizontalSpace,
                      Flexible(
                        child: Text(
                          data[dataIndex]["value"],
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                        ),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                ],
              )).toList(),
    );
  }
}
