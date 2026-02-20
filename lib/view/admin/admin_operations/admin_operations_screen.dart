import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/association/association_dashboard/pie_chart.dart';
import 'package:zakat_fund/view_model/admin_operations_view_model.dart';
import 'package:zakat_fund/widgets/donut_summry_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/my_container.dart';

class AdminAndOperationsScreen extends GetView<AdminAndOperationsViewModel> {
  const AdminAndOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "adminAndOperations"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildDatePickerField(),
          16.verticalSpace,
          _buildChartSection("associationsDetails", controller.associationsChart,
              controller.totalAssociations, 'totalAssociations'),
          16.verticalSpace,
          _buildChartSection("requestsDetails", controller.requestsChart,
              controller.totalRequests, 'totalRequests'),
          16.verticalSpace,
          _buildChartSection("companiesDetails", controller.companiesChart,
              controller.totalCompanies, 'totalCompanies'),
          16.verticalSpace,
          _buildChartSection("projectsDetails", controller.projectsChart,
              controller.totalProjects, 'totalProjects'),
          16.verticalSpace,
          _buildChartSection("employeesDetails", controller.employeesChart,
              controller.totalEmployees, 'totalEmployees'),
        ],
      ),
    );
  }
  Widget _buildChartSection(
      String titleKey,
      RxList<DashboardData> chartDataRx,
      RxString totalCountRx,
      String totalTitleKey,
      ) {
    return Obx(() => buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading(titleKey),
          25.verticalSpace,
          Stack(
            alignment: Alignment.center,
            children: [
              DonutChart(
                data: chartDataRx.value,
                centerSpaceRadius: 60,
                radius: 25,
              ),
              totalDonutSummaryText(
                title: totalTitleKey,
                value: totalCountRx.value,
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
      ),
    ));
  }

  Widget _buildHeading(String textKey) {
    return Text(
      textKey.tr,
      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
    );
  }

  Widget _buildDatePickerField() {
    return Align(
      alignment: Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
      child: SizedBox(
        width: 290,
        child: LabelTextField(
          label: "",
          isArabicDirection: Utils.isArabic,
          onTap: controller.datePicker,
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
}
