import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/campaign_funding_gap.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/projects_reaching_end.dart';
import 'package:zakat_fund/model/top_performing_projects.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/module_codes.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/campaigns_projects_view_model.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class CampaignsProjectsScreen extends GetView<CampaignsAndProjectsViewModel> {
  const CampaignsProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "campaignsAndProjects"),
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
          _buildSummary(),
          4.verticalSpace,
          _buildTabBar(),
          10.verticalSpace,
          _buildTabView(),
        ],
      ),
    );
  }

  Obx _buildTabView() {
    return Obx(() => controller.currentTabIndex.value == 0
        ? topPerformingProjects()
        : controller.currentTabIndex.value == 1
            ? campaignFundingGap()
            : projectReachingEndSoon());
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: controller.tabController,
      isScrollable: true,
      dividerColor: AppColors.lightGrey,
      indicatorColor: AppColors.lightBrownColor,
      tabAlignment: TabAlignment.start,
      labelStyle: AppTextStyle.lightBrownColor12spTextStyle,
      unselectedLabelStyle: AppTextStyle.secondaryBlack12spTextStyle2,
      tabs: [
        Tab(text: "topPerformingProjects".tr),
        Tab(text: "campaignFundingGap".tr),
        Tab(text: "projectReachingEndSoonText".tr),
      ],
    );
  }

  Obx _buildSummary() {
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
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                            color: data.labelColor ??
                                data.style?.color ??
                                Colors.transparent,
                            width: 1.w)),
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
        onTap: () {
          controller.datePicker();
        },
      ),
    );
  }

  Widget topPerformingProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "topPerformingProjects".tr,
              style: AppTextStyle.blackColor16spTextStyle,
            ),
            if (controller.topPerformingProjects.isNotEmpty)
              viewAllButton(
                  onPressed: () => Get.toNamed(
                          AppRoutes.projectManagementScreen,
                          arguments: {
                            "code": ModuleCodes.adminProjectManagementCode
                          }))
          ],
        ),
        8.verticalSpace,
        _buildTopProjectsListView()
      ],
    );
  }

  Obx _buildTopProjectsListView() {
    return Obx(() => ListView.separated(
          itemCount: controller.topPerformingProjects.length,
          padding: EdgeInsets.only(top: 8.h),
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            TopPerformingProjects project =
                controller.topPerformingProjects[index];
            List<DashboardData> details = [
              DashboardData(
                  title: "projectName",
                  value: Utils.isArabic
                      ? project.projectNameArabic
                      : project.projectName),
              DashboardData(
                  title: "raisedAmount",
                  value:
                      "${"currency".tr} ${Utils.getCurrency(project.raisedAmount.toInt())}"),
              DashboardData(
                  title: "targetedAmount",
                  value:
                      "${"currency".tr} ${Utils.getCurrency(project.targetedAmount.toInt())}"),
              DashboardData(
                  title: "success", value: "${project.successPercentage}%"),
            ];
            return itemWidget(details: details, projectId: project.projectId);
          },
        ));
  }

  Widget campaignFundingGap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "campaignFundingGap".tr,
              style: AppTextStyle.blackColor16spTextStyle,
            ),
            if (controller.campaignFundingGap.isNotEmpty)
              viewAllButton(
                  onPressed: () => Get.toNamed(
                          AppRoutes.projectManagementScreen,
                          arguments: {
                            "code": ModuleCodes.adminProjectManagementCode
                          }))
          ],
        ),
        8.verticalSpace,
        _buildFundingGapListView()
      ],
    );
  }

  Obx _buildFundingGapListView() {
    return Obx(() => ListView.separated(
          itemCount: controller.campaignFundingGap.length,
          padding: EdgeInsets.only(top: 8.h),
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            CampaignFundingGap fundingGap =
                controller.campaignFundingGap[index];
            List<DashboardData> details = [
              DashboardData(
                  title: "projectName",
                  value: Utils.isArabic
                      ? fundingGap.projectNameArabic
                      : fundingGap.projectName),
              DashboardData(
                  title: "targetedAmount",
                  value:
                      "${"currency".tr} ${Utils.getCurrency(fundingGap.targetedAmount.toInt())}"),
              DashboardData(
                  title: "collectedAmount",
                  value:
                      "${"currency".tr} ${Utils.getCurrency(fundingGap.collectedAmount.toInt())}"),
              DashboardData(
                  title: "fundingGap",
                  value:
                      "${"currency".tr} ${Utils.getCurrency(fundingGap.fundingGap.toInt())}"),
            ];
            return itemWidget(
                details: details, projectId: fundingGap.projectId);
          },
        ));
  }

  Row buildRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.tr,
          style: AppTextStyle.greyDark14spTextStyle1,
        ),
        Text(
          value,
          style: AppTextStyle.secondaryPrimaryBlack14spTextStyle1,
        ),
      ],
    );
  }

  Widget projectReachingEndSoon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "projectReachingEndSoon".tr,
                style: AppTextStyle.blackColor16spTextStyle,
              ),
            ),
            if (controller.projectsReachingEnd.isNotEmpty)
              viewAllButton(
                  onPressed: () => Get.toNamed(
                          AppRoutes.projectManagementScreen,
                          arguments: {
                            "code": ModuleCodes.adminProjectManagementCode
                          }))
          ],
        ),
        8.verticalSpace,
        _buildReachingSoonListView()
      ],
    );
  }

  Obx _buildReachingSoonListView() {
    return Obx(() => ListView.separated(
          itemCount: controller.projectsReachingEnd.length,
          padding: EdgeInsets.only(top: 8.h),
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            ProjectsReachingEnd project = controller.projectsReachingEnd[index];
            List<DashboardData> details = [
              DashboardData(
                  title: "projectName",
                  value: Utils.isArabic
                      ? project.projectNameArabic
                      : project.projectName),
              DashboardData(
                  title: "endDate",
                  value: Utils.dateFormat1.format(project.endDate)),
              DashboardData(
                  title: "targetedAmount",
                  value:
                      "${"currency".tr} ${Utils.getCurrency(project.targetedAmount.toInt())}"),
              DashboardData(
                  title: "collectedAmount",
                  value:
                      "${"currency".tr} ${Utils.getCurrency(project.collectedAmount.toInt())}"),
              DashboardData(
                  title: "remainingTime",
                  value: Utils.getRemainingTime(project.endDate)),
            ];
            return itemWidget(details: details, projectId: project.projectId);
          },
        ));
  }

  Widget itemWidget(
      {required List<DashboardData> details, required int projectId}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.projectDetailsScreen,
          arguments: {"projectId": projectId, "isPreview": false},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.lightGrey)),
        child: Column(
          children: details
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

ElevatedButton viewAllButton(
    {String text = "viewAll", required void Function() onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        elevation: 0, backgroundColor: AppColors.btnBackgroundColor),
    child: Text(
      text.tr,
      style: AppTextStyle.btnText14spTextStyle1,
    ),
  );
}
