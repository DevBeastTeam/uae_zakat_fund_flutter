import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:zakat_fund/model/financial_statement.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/financial_statement_view_model.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class FinancialStatementScreen extends GetView<FinancialStatementViewModel> {
  const FinancialStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "financialStatement"),
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Obx(() => Column(
              children: [
                _buildDateAndPeriodRow(),
                ..._buildListView(),
              ],
            )));
  }

  List<Widget> _buildListView() {
    return List.generate(
      controller.financialStatement.length,
      (index) => Column(
        children: [
          buildListTileItem(
            title: controller.financialStatement[index].title,
            value: controller.financialStatement[index].value,
          ),
          if (index == 2 && controller.breakdownProjects.isNotEmpty)
            _buildGroupedListView()
        ],
      ),
    );
  }

  Obx _buildGroupedListView() {
    return Obx(() => GroupedListView(
          elements: controller.breakdownProjects.value,
          shrinkWrap: true,
          groupBy: (element) => controller.selectedPeriod.value == "monthly"
              ? element.monthName
              : element.year,
          groupComparator: (value1, value2) => value2.compareTo(value1),
          itemComparator: (item1, item2) =>
              controller.selectedPeriod.value == "monthly"
                  ? item1.monthName.compareTo(item2.monthName)
                  : item1.year.compareTo(item2.year),
          order: GroupedListOrder.ASC,
          groupSeparatorBuilder: (String value) => _buildGroupSeparator(value),
          itemBuilder: (c, element) => _buildGroupItem(element),
        ));
  }

  Widget _buildGroupItem(FinancialStatementByMonth element) {
    String groupKey = controller.selectedPeriod.value == "monthly"
        ? element.monthName
        : element.year;
    return Obx(() => !(controller.expandedGroups[groupKey] ?? false)
        ? SizedBox.shrink()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    Utils.isArabic
                        ? element.projectNameAr
                        : element.projectName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                  ),
                ),
                16.horizontalSpace,
                Text(
                  "${"currency".tr} ${double.parse(element.totalAmount).toInt()}",
                  style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
                ),
              ],
            ),
          ));
  }

  Directionality _buildGroupSeparator(String value) {
    return Directionality(
      textDirection: Utils.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Obx(() {
        bool isExpanded = controller.expandedGroups[value] ?? false;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: expansionTileHeader(
            title: value,
            isExpanded: isExpanded,
            onTap: () {
              controller.expandedGroups[value] = !isExpanded;
            },
          ),
        );
      }),
    );
  }

  Row _buildDateAndPeriodRow() {
    return Row(
      children: [
        Expanded(
          child: LabelTextField(
            label: "",
            onTap: () => controller.dateRangePicker(),
            readOnly: true,
            isArabicDirection: Utils.isArabic,
            hint: "${"startDate".tr} - ${"endDate".tr}",
            isDate: true,
            showLabel: false,
            controller: controller.dateController,
          ),
        ),
        8.horizontalSpace,
        Obx(() => SizedBox(
              width: 155,
              child: LabelDropDown(
                items: AppConstant.periods,
                selectedValue: controller.selectedPeriod.value,
                hint: "chooseAnOption",
                onChanged: (value) => controller.onChangePeriod(value!),
                showLabel: false,
                label: '',
              ),
            )),
      ],
    );
  }

  Widget buildListTileItem({required String title, required String value}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title.tr,
                  style: AppTextStyle.secondaryBlack16spTextStyle3,
                ),
              ),
              16.horizontalSpace,
              Text(
                "${"currency".tr} $value",
                style: AppTextStyle.lightBrown16spTextStyle,
              ),
            ],
          ),
        ),
        Divider(color: AppColors.grey, thickness: 1.5),
      ],
    );
  }
}
