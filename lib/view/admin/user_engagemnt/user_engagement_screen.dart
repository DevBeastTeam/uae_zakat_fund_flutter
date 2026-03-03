import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/admin/donor/donor_screen.dart';
import 'package:zakat_fund/view/association/association_dashboard/line_chart.dart';
import 'package:zakat_fund/view/association/association_dashboard/pie_chart.dart';
import 'package:zakat_fund/view_model/user_engagemnt_view_model.dart';
import 'package:zakat_fund/widgets/donation_item.dart';
import 'package:zakat_fund/widgets/donut_summry_widget.dart';
import 'package:zakat_fund/widgets/gender_bar_chart.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class UserEngagementScreen extends GetView<UserEngagementViewModel> {
  const UserEngagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "userEngagementAndInteraction"),
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
          _buildActivityChart(),
          16.verticalSpace,
          _buildLowestActivitySummary(),
          4.verticalSpace,
          _buildTabBar(),
          16.verticalSpace,
          _buildTabView()
        ],
      ),
    );
  }

  Obx _buildTabView() {
    return Obx(() => controller.currentTabIndex.value == 0
        ? preferredLoginTime()
        : controller.currentTabIndex.value == 1
            ? feedbackAndSurveys()
            : ratingReports());
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
        Tab(text: "preferredLoginTime".tr),
        // Tab(text: "emailSMSCampaignPerformance".tr),
        Tab(text: "feedbackAndSurveys".tr),
        Tab(text: "ratingReports".tr),
      ],
    );
  }

  Container _buildLowestActivitySummary() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                List.generate(controller.lowestActivityTime.length, (index) {
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
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle1,
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
          )),
    );
  }

  Obx _buildActivityChart() {
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
            ],
          ),
        ));
  }

  Container _buildSummary() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Obx(() => Column(
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
                        if (index == 0) _buildUserActityOverview(index),
                        if (index == 1) _buildPreferredLoginPeriod(),
                        if (index == 2) _buildPrederredLoginDay(),
                        16.verticalSpace,
                      ],
                    ),
                  ),
                  if (controller.dashboardData.length - 1 != index)
                    10.verticalSpace
                ],
              );
            }).toList(),
          )),
    );
  }

  Column _buildPrederredLoginDay() {
    return Column(
        children: List.generate(
            controller.preferredLoginDay.length,
            (dataIndex) => Column(
                  children: [
                    listTileItem(
                        controller
                            .preferredLoginDay[dataIndex].preferredLoginDay,
                        controller.preferredLoginDay[dataIndex].logins),
                    4.verticalSpace,
                  ],
                )).toList());
  }

  Column _buildPreferredLoginPeriod() {
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

  RichText _buildUserActityOverview(int index) {
    return RichText(
      text: TextSpan(
          text: controller.dashboardData[index].value,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3
              .copyWith(fontFamily: 'Alexandria'),
          children: <TextSpan>[
            TextSpan(
                text: "userActivityOverviewMessage".tr,
                style: AppTextStyle.primaryDarkGrey14spTextStyle
                    .copyWith(fontFamily: 'Alexandria')),
          ]),
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

  Widget ratingReports() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ratingReports".tr,
          style: AppTextStyle.blackColor16spTextStyle,
        ),
        16.verticalSpace,
        _buildRatingsPerCategoryChart(),
        16.verticalSpace,
        _buildRatingPerUserTypeChart(),
      ],
    );
  }

  Container _buildRatingPerUserTypeChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ratingPerUserType".tr,
            style: AppTextStyle.primaryDarkBlack16spTextStyle,
          ),
          16.verticalSpace,
          Obx(() => GenderBarChart(
                bottomBarData: controller.userTypes.value,
                leftBarData: controller.userTypesRatings.value,
                ratings: true,
              )),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLegendItem(AppColors.lightBrownColor2, "yesRating"),
              20.horizontalSpace,
              buildLegendItem(AppColors.lightYellowColor1, "noRating"),
            ],
          )
        ],
      ),
    );
  }

  Container _buildRatingsPerCategoryChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ratingsPerCategory".tr,
            style: AppTextStyle.primaryDarkBlack16spTextStyle,
          ),
          16.verticalSpace,
          Obx(() => GenderBarChart(
                bottomBarData: controller.categories.value,
                leftBarData: controller.categoryRatings.value,
                ratings: true,
                onBarClick: (index) => controller.fetchFeedbackDetails(index),
              )),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLegendItem(AppColors.lightBrownColor2, "yesRating"),
              20.horizontalSpace,
              buildLegendItem(AppColors.lightYellowColor1, "noRating"),
            ],
          )
        ],
      ),
    );
  }

  Widget feedbackAndSurveys() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeedbacksChart(),
        16.verticalSpace,
        _buildSurveysChart(),
      ],
    );
  }

  Obx _buildSurveysChart() {
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
                  "surveys".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
                ),
              ),
              25.verticalSpace,
              Stack(
                alignment: Alignment.center,
                children: [
                  DonutChart(
                    data: controller.surveysChartData.value,
                    centerSpaceRadius: 60,
                    radius: 25,
                  ),
                  totalDonutSummaryText(
                      title: 'responseRate',
                      value: "${controller.responseRate.value}%"),
                ],
              ),
              16.verticalSpace,
              Wrap(
                runSpacing: 8,
                spacing: 8,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: List.generate(
                    controller.surveysChartData.length,
                    (index) => Indicator(
                        color: controller.surveysChartData[index].backColor!,
                        text: controller.surveysChartData[index].title,
                        percentage: controller.surveysChartData[index].value)),
              ),
              16.verticalSpace,
            ],
          ),
        ));
  }

  Obx _buildFeedbacksChart() {
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
                  "feedbacks".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
                ),
              ),
              25.verticalSpace,
              DonutChart(data: controller.feedbacksChartData.value),
              16.verticalSpace,
              Wrap(
                runSpacing: 8,
                spacing: 8,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(
                    controller.feedbacksChartData.length,
                    (index) => Indicator(
                        color: controller.feedbacksChartData[index].backColor!,
                        text: controller.feedbacksChartData[index].title,
                        percentage:
                            controller.feedbacksChartData[index].value)),
              ),
              16.verticalSpace,
            ],
          ),
        ));
  }

  Widget emailCampaignPerformance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "emailSMSCampaignPerformance".tr,
          style: AppTextStyle.blackColor16spTextStyle,
        ),
        8.verticalSpace,
        ListView.separated(
          itemCount: 10,
          padding: EdgeInsets.only(top: 8.h),
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (BuildContext context, int index) {
            List data = [
              {"key": "campaign", "value": "Campaign 1"},
              {"key": "type", "value": "Email"},
              {"key": "openRate", "value": "45%"},
              {"key": "clickThroughRate", "value": "10%"},
              {"key": "conversionRate", "value": "3%"},
            ];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.lightGrey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listItemWidget(data),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget preferredLoginTime() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "preferredLoginTime".tr,
            style: AppTextStyle.blackColor16spTextStyle,
          ),
          16.verticalSpace,
          Obx(() => controller.months.isNotEmpty && controller.spots.isNotEmpty
              ? LineChartWidget(
                  isTime: true,
                  monthsList: controller.months.value,
                  spots: controller.spots.value,
                )
              : SizedBox.shrink()),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLegendItem(AppColors.lightBlueColor3, "numberOfLogin"),
            ],
          ),
        ],
      ),
    );
  }

  Column activityProgressWidget(
      {required String label,
      required String value,
      required TextStyle style,
      required Color color,
      Color backColor = AppColors.progressBarBackgroundColor}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.tr,
              style: AppTextStyle.secondaryBlack12spTextStyle2,
            ),
            Text(
              value,
              style: style,
            ),
          ],
        ),
        10.verticalSpace,
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(70.r)),
            child: LinearProgressIndicator(
              minHeight: 8.h,
              color: color,
              backgroundColor: backColor,
              value: 0.3,
            )),
      ],
    );
  }
}
