import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/association_donations.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/association/association_dashboard/line_chart.dart';
import 'package:zakat_fund/view/association/association_dashboard/pie_chart.dart';
import 'package:zakat_fund/view_model/association_dashboard_view_model.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AssociationDashboardScreen extends GetView<AssociationDashboardViewModel> {
  const AssociationDashboardScreen({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateAndProjectsRow(),
          _buildDonationTrends(),
          _buildStats(),
          _buildFirstTimeVsReturningDonors(),
          _buildSummary(),
          _buildDonationsListView(),
        ],
      ),
    );
  }

  Obx _buildSummary() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          margin: EdgeInsets.only(bottom: 16.h),
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
                        borderRadius: BorderRadius.circular(8.r)),
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
                  10.verticalSpace,
                ],
              );
            }).toList(),
          ),
        ));
  }

  Obx _buildFirstTimeVsReturningDonors() {
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

  Obx _buildStats() {
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

  Container _buildDonationTrends() {
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
              Obx(() => Expanded(
                  child: controller.months.isNotEmpty &&
                          controller.spots.isNotEmpty
                      ? LineChartWidget(
                          monthsList: controller.months.value,
                          spots: controller.spots.value,
                        )
                      : SizedBox.shrink())),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildDateAndProjectsRow() {
    return Row(
      children: [
        Expanded(
          child: LabelTextField(
            label: "dateRange",
            showLabel: false,
            isDate: true,
            isArabicDirection: Utils.isArabic,
            onTap: () => controller.datePicker(),
            readOnly: true,
            isBackWhite: true,
            controller: controller.dateRangeController,
            hint: "${"startDate".tr} - ${"endDate".tr}",
          ),
        ),
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

  Widget _buildDonationsListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "donationBreakdownProjects".tr,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
        ),
        16.verticalSpace,
        Obx(() => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.donations.length,
              separatorBuilder: (_, int index) => 16.verticalSpace,
              itemBuilder: (_, int index) {
                AssociationDonations donation = controller.donations[index];
                return _buildDonationItem(donation);
              },
            )),
      ],
    );
  }

  GestureDetector _buildDonationItem(AssociationDonations donation) {
    List<DashboardData> projectDetails = [
      DashboardData(
          title: "projectName",
          value: Utils.isArabic
              ? donation.projectNameArabic
              : donation.projectName),
      DashboardData(
          title: "targetedAmount",
          value:
              "${"currency".tr} ${Utils.getCurrency(donation.targetedAmount.toInt())}"),
      DashboardData(
          title: "collectedAmount",
          value:
              "${"currency".tr} ${Utils.getCurrency(donation.collectedAmount.toInt())}"),
    ];
    return GestureDetector(
      onTap: () => controller.openProjectDetails(donation.projectId),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.lightGrey)),
        child: Column(
          children: projectDetails
              .map((data) => Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.title.tr,
                            style: AppTextStyle.primaryDarkGrey12spTextStyle1),
                        50.horizontalSpace,
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
      ),
    );
  }
}
