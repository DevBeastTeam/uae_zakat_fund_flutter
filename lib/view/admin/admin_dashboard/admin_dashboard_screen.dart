import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/admin/campaigns_projects/campaigns_projects_screen.dart';
import 'package:zakat_fund/view/association/association_dashboard/pie_chart.dart';
import 'package:zakat_fund/view_model/admin_dashboard_view_model.dart';
import 'package:zakat_fund/widgets/donut_summry_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/my_container.dart';

class AdminDashboardScreen extends GetView<AdminDashboardViewModel> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "adminDashboard"),
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
          _buildAdminAndOperationsData(),
          16.verticalSpace,
          _buildFinancialData(),
          16.verticalSpace,
          _buildDonationsData(),
          16.verticalSpace,
          _buildCampaignsAndProjectsData(),
          16.verticalSpace,
          _buildDonorsData(),
          16.verticalSpace,
          _buildUserEngagementAndInteractionData(),
        ],
      ),
    );
  }

  Obx _buildUserEngagementAndInteractionData() {
    return Obx(() => buildContainer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadingRow("userEngagementAndInteraction",
                () => Get.toNamed(AppRoutes.userEngagementScreen)),
            8.verticalSpace,
            ...List.generate(controller.userEngagementData.length, (index) {
              DashboardData data = controller.userEngagementData[index];
              return Column(
                children: [
                  ListTile(
                    selected: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                            color: data.labelColor ??
                                data.style?.color ??
                                Colors.transparent,
                            width: 1.w)),
                    selectedTileColor: data.backColor,
                    title: Text(
                      data.title.tr,
                      style: data.style,
                    ),
                    subtitle: index == 0
                        ? _buildPreferredLoginPeriodData()
                        : _buildPreferredLoginDayData(),
                  ),
                  if (controller.userEngagementData.length - 1 != index)
                    10.verticalSpace
                ],
              );
            }),
            16.verticalSpace,
            Align(
              alignment:
                  Utils.isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                "weekdayVsWeekendActivity".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
              ),
            ),
            25.verticalSpace,
            DonutChart(data: controller.activityChartData.value),
            16.verticalSpace,
            Wrap(
              runSpacing: 8,
              spacing: 8,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: List.generate(
                  controller.activityChartData.length,
                  (index) => Indicator(
                      color: controller.activityChartData[index].backColor!,
                      text: controller.activityChartData[index].title,
                      percentage: controller.activityChartData[index].value)),
            ),
            16.verticalSpace,
            _buildLowestActivityTimesData(),
          ],
        )));
  }

  Column _buildLowestActivityTimesData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(controller.lowestActivityTime.length, (index) {
        DashboardData data = controller.lowestActivityTime[index];
        return Column(
          children: [
            ListTile(
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              selectedTileColor: data.backColor,
              title: RichText(
                text: TextSpan(
                    text: "${"lowestActivityTimes".tr} ",
                    style: data.style!.copyWith(fontFamily: 'Alexandria'),
                    children: <TextSpan>[
                      TextSpan(
                          text: " (${data.title.tr})",
                          style: index == 0
                              ? AppTextStyle.darkGreenColor12spTextStyle
                                  .copyWith(fontFamily: 'Alexandria')
                              : AppTextStyle.darkRed12spTextStyle
                                  .copyWith(fontFamily: 'Alexandria')),
                    ]),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      data.value,
                      style: AppTextStyle.greyDark14spTextStyle1,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    data.icon!,
                    style: AppTextStyle.secondaryPrimaryBlack14spTextStyle1,
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(
                    color: data.labelColor ??
                        data.style?.color ??
                        Colors.transparent,
                    width: 1.w),
              ),
            ),
            if (controller.lowestActivityTime.length - 1 != index)
              10.verticalSpace
          ],
        );
      }),
    );
  }

  Column _buildPreferredLoginDayData() {
    return Column(
      children: List.generate(
          controller.preferredLoginDay.length,
          (dataIndex) => Column(
                children: [
                  listTileItem(
                      controller.preferredLoginDay[dataIndex].preferredLoginDay,
                      controller.preferredLoginDay[dataIndex].logins),
                  4.verticalSpace,
                ],
              )).toList(),
    );
  }

  Column _buildPreferredLoginPeriodData() {
    return Column(
      children: List.generate(
          controller.preferredLoginPeriod.length,
          (dataIndex) => Column(
                children: [
                  listTileItem(
                      controller
                          .preferredLoginPeriod[dataIndex].preferredLoginPeriod,
                      controller.preferredLoginPeriod[dataIndex].logins),
                  4.verticalSpace,
                ],
              )).toList(),
    );
  }

  Obx _buildDonorsData() {
    return Obx(() => buildContainer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadingRow(
                "donors", () => Get.toNamed(AppRoutes.donorScreen)),
            8.verticalSpace,
            Column(
              children: List.generate(controller.donorsData.length, (index) {
                DashboardData data = controller.donorsData[index];
                return Column(
                  children: [
                    _buildItemListTile(data),
                    if (controller.donorsData.length - 1 != index)
                      10.verticalSpace
                  ],
                );
              }).toList(),
            )
          ],
        )));
  }

  Obx _buildCampaignsAndProjectsData() {
    return Obx(() => buildContainer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadingRow("campaignsAndProjects",
                () => Get.toNamed(AppRoutes.campaignsProjectsScreen)),
            8.verticalSpace,
            Column(
              children: List.generate(controller.campaignAndProjectsData.length,
                  (index) {
                DashboardData data = controller.campaignAndProjectsData[index];
                return Column(
                  children: [
                    _buildItemListTile(data),
                    if (controller.campaignAndProjectsData.length - 1 != index)
                      10.verticalSpace
                  ],
                );
              }).toList(),
            )
          ],
        )));
  }

  Obx _buildDonationsData() {
    return Obx(() => buildContainer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadingRow(
                "donations", () => Get.toNamed(AppRoutes.donationDataScreen)),
            8.verticalSpace,
            Column(
              children: List.generate(controller.donationsData.length, (index) {
                DashboardData data = controller.donationsData[index];
                return Column(
                  children: [
                    _buildItemListTile(data),
                    if (controller.donationsData.length - 1 != index)
                      10.verticalSpace
                  ],
                );
              }).toList(),
            )
          ],
        )));
  }

  Obx _buildFinancialData() {
    return Obx(() => buildContainer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadingRow(
                "financial", () => Get.toNamed(AppRoutes.financialScreen)),
            8.verticalSpace,
            Column(
              children: List.generate(controller.financialData.length, (index) {
                DashboardData data = controller.financialData[index];
                return Column(
                  children: [
                    _buildItemListTile(data),
                    if (controller.financialData.length - 1 != index)
                      10.verticalSpace
                  ],
                );
              }).toList(),
            )
          ],
        )));
  }

  ListTile _buildItemListTile(DashboardData data) {
    return ListTile(
      selected: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(
              color: data.labelColor ?? data.style?.color ?? Colors.transparent,
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
    );
  }

  Obx _buildAdminAndOperationsData() {
    return Obx(() => buildContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeadingRow(
                "adminAndOperations",
                () => Get.toNamed(AppRoutes.adminAndOperationsScreen),
              ),
              _buildChartSection(
                titleKey: "associationsDetails",
                chartDataRx: controller.associationsChart,
                totalKey: "totalAssociations",
                totalValueRx: controller.totalAssociations,
              ),
              16.verticalSpace,
              _buildChartSection(
                titleKey: "companiesDetails",
                chartDataRx: controller.companiesChart,
                totalKey: "totalCompanies",
                totalValueRx: controller.totalCompanies,
              ),
              16.verticalSpace,
              _buildChartSection(
                titleKey: "projectsDetails",
                chartDataRx: controller.projectsChart,
                totalKey: "totalProjects",
                totalValueRx: controller.totalProjects,
              ),
            ],
          ),
        ));
  }

  Widget _buildChartSection({
    required String titleKey,
    required RxList<DashboardData> chartDataRx,
    required String totalKey,
    required RxString totalValueRx,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeadingText(titleKey),
        12.verticalSpace,
        Stack(
          alignment: Alignment.center,
          children: [
            DonutChart(
              data: chartDataRx.value,
              centerSpaceRadius: 50,
              radius: 20,
            ),
            totalDonutSummaryText(
              title: totalKey,
              value: totalValueRx.value,
            ),
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
              chartDataRx.length,
              (index) {
                final data = chartDataRx[index];
                return Indicator(
                  color: data.backColor ?? Colors.grey,
                  text: data.title,
                  percentage: data.value,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _buildHeadingRow(String title, Function onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: _buildHeadingText(title)),
        viewAllButton(text: "details", onPressed: () => onPressed()),
      ],
    );
  }

  Widget _buildHeadingText(String heading) {
    return Text(
      heading.tr,
      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
    );
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
          isArabicDirection: Utils.isArabic,
          isNewDate: true,
          showLabel: false,
          isBackWhite: true,
          controller: controller.dateRange,
          hint: "${"startDate".tr} - ${"endDate".tr}",
        ),
      ),
    );
  }

  Row listTileItem(String key, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            key,
            style: AppTextStyle.primaryDarkGrey12spTextStyle1,
          ),
        ),
        16.horizontalSpace,
        Text(
          "$value ${"logins".tr}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
        ),
      ],
    );
  }
}
