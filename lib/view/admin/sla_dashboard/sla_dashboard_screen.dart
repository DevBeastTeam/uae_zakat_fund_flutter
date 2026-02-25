import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/donor_demographic.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/sla_dashboard_view_model.dart';
import 'package:zakat_fund/widgets/gender_bar_chart.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/my_container.dart';
import 'package:zakat_fund/widgets/stats_widget.dart';
import 'package:zakat_fund/widgets/status_chip.dart';

class SlaDashboardScreen extends GetView<SLADashboardViewModel> {
  const SlaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "slaCompliance"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildDateTextField(),
          16.verticalSpace,
          Obx(() => _buildStatsRow(0)),
          10.verticalSpace,
          Obx(() => _buildStatsRow(2)),
          16.verticalSpace,
          _buildBarChar("compliancePerWorkflow", controller.workFlowMonths,
              controller.workflowSpots),
          16.verticalSpace,
          _buildBarChar("breakdownByLevel", controller.levelsMonths,
              controller.levelsSpots),
          16.verticalSpace,
          _buildBarChar("slaByApproversGroups", controller.groupsMonths,
              controller.groupsSpots,
              angle: -0.1),
          16.verticalSpace,
          _buildHeadingText("pendingOverdueRequests"),
          16.verticalSpace,
          _buildListView(),
        ],
      ),
    );
  }

  Obx _buildListView() {
    return Obx(() => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.requests.length,
        separatorBuilder: (_, int index) => 16.verticalSpace,
        itemBuilder: (_, int index) =>
            pendingItem(controller.requests[index])));
  }

  Container _buildBarChar(String title, RxList<String> workFlowMonths,
      RxList<DonorDemographic> workflowSpots,
      {double angle = -0.3}) {
    return buildContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeadingText(title),
        8.verticalSpace,
        Obx(() => GenderBarChart(
              bottomBarData: workFlowMonths.value,
              leftBarData: workflowSpots.value,
              angle: angle,
            )),
      ],
    ));
  }

  Text _buildHeadingText(String heading) {
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

  Container pendingItem(Requests request) {
    String status = Utils.statusIntoString(1);
    List<DashboardData> projectDetails = [
      DashboardData(title: "requestId", value: request.id.toString()),
      DashboardData(
          title: "requestType",
          value: Utils.isArabic ? request.requestTypeAr : request.requestType),
      if (request.currentLevel != null)
        DashboardData(
            title: "level", value: "${"level".tr} ${request.currentLevel}"),
      if (request.assignedTo != "")
        DashboardData(title: "approverGroup", value: request.assignedTo),
      if (request.slaDeadline != null)
        DashboardData(
            title: "slaDeadline",
            value: Utils.dateFormat1.format(request.slaDeadline!)),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                statusChip(status),
              ],
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
                          Flexible(
                            child: Text(data.title.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppTextStyle.primaryDarkGrey12spTextStyle1),
                          ),
                          Flexible(
                            child: Text(data.value,
                                maxLines: 1,
                                textDirection: Utils.containsArabic(data.value)
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
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

  Widget _buildStatsRow(int startIndex) {
    return Row(
      children: List.generate(
        2,
        (i) {
          final statIndex = startIndex + i;
          if (statIndex >= controller.stats.length) return const Spacer();
          return Expanded(
            child: Row(
              children: [
                statsContainer(stats: controller.stats[statIndex]),
                if (i < 1) 8.horizontalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
