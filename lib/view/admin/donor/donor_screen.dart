import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/top_donors.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/donor_view_model.dart';
import 'package:zakat_fund/widgets/gender_bar_chart.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class DonorScreen extends GetView<DonorViewModel> {
  const DonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "donors"),
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
        ? donorDemographics()
        : topDonors());
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
        Tab(text: "donorDemographics".tr),
        Tab(text: "topDonors".tr),
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
                    10.verticalSpace
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

  Widget topDonors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "topDonors".tr,
          style: AppTextStyle.blackColor16spTextStyle,
        ),
        8.verticalSpace,
        _buildTopDonorListView()
      ],
    );
  }

  ListView _buildTopDonorListView() {
    return ListView.separated(
      itemCount: controller.topDonors.length,
      padding: EdgeInsets.only(top: 8.h),
      shrinkWrap: true,
      primary: false,
      separatorBuilder: (_, int index) => 16.verticalSpace,
      itemBuilder: (BuildContext context, int index) {
        TopDonors topDonor = controller.topDonors[index];
        List<DashboardData> details = [
          DashboardData(
            title: "donor",
            value: Utils.isArabic
                ? "${topDonor.firstNameArabic} ${topDonor.lastNameArabic}"
                : "${topDonor.firstName} ${topDonor.lastName}",
          ),
          DashboardData(title: "email", value: topDonor.email),
          DashboardData(title: "phoneNumber", value: topDonor.mobile),
          DashboardData(
              title: "totalContribution",
              value: "${"currency".tr} ${topDonor.totalContributions.toInt()}")
        ];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: listItem(details),
        );
      },
    );
  }

  Widget donorDemographics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "donorDemographics".tr,
          style: AppTextStyle.blackColor16spTextStyle,
        ),
        8.verticalSpace,
        Container(
          padding: EdgeInsets.fromLTRB(8.w, 16.h, 10.w, 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.lightGrey)),
          child: Column(
            children: [
              Obx(() => GenderBarChart(
                    bottomBarData: controller.months.value,
                    leftBarData: controller.donorDemographics.value,
                    onBarClick: (index) =>
                        controller.donorBarchartDetails(index),
                  )),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLegendItem(AppColors.maleColor, "male"),
                  20.horizontalSpace,
                  buildLegendItem(AppColors.femaleColor, "female"),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

Widget buildLegendItem(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 8.w,
        height: 8.h,
        color: color,
      ),
      4.horizontalSpace,
      Text(
        label.tr,
        style: AppTextStyle.blackColor10spTextStyle,
      ),
    ],
  );
}

Widget listItem(List<DashboardData> details) {
  return Column(
    children: details
        .map((data) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data.title.tr,
                      style: AppTextStyle.primaryDarkGrey12spTextStyle1),
                  50.horizontalSpace,
                  Flexible(
                    child: Text(data.value,
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppTextStyle.secondaryPrimaryBlack12spTextStyle1),
                  ),
                ],
              ),
            ))
        .toList(),
  );
}
