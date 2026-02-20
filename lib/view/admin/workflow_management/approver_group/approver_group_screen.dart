import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/approver_groups.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/approver_group_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class ApproverGroupScreen extends GetView<ApproverGroupViewModel> {
  const ApproverGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "approverGroup"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          if (controller.canView) ...[
            Obx(() => buildStatsRow(0, controller.stats)),
            10.verticalSpace
          ],
          if (controller.canAdd) ...[
            _buildAddGroupBtn(),
            10.verticalSpace,
          ],
          _buildExportFilterRow(),
          if (controller.canView) ...[
            10.verticalSpace,
            _buildSearchField(),
            16.verticalSpace,
            _buildListView()
          ],
        ],
      ),
    );
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (_) => controller.searchGroups(),
    );
  }

  Widget _buildAddGroupBtn() {
    return addElevatedButton(
        onPressed: () => controller.addNewGroup(), text: "addNewGroup");
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.groups.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => groupsItem(controller.groups[index]),
        ));
  }

  Widget groupsItem(ApproverGroups group) {
    List<DashboardData> projectDetails = [
      DashboardData(
          title: "groupName",
          value: Utils.isArabic ? group.groupNameArabic : group.groupName),
      DashboardData(title: "description", value: group.groupDescription),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.canEdit || controller.canDelete) ...[
            Align(
              alignment:
                  Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: popupMenuButton(
                    onSelected: (value) =>
                        controller.onMenuSelected(value, group),
                    menuItems: [
                      if (controller.canEdit)
                        popupMenuItem(
                            label: "edit",
                            icon: AppResources.editIcon1,
                            textStyle: AppTextStyle
                                .secondaryPrimaryBlack14spTextStyle),
                      if (controller.canDelete)
                        popupMenuItem(
                            label: "delete",
                            icon: AppResources.removeIcon,
                            textStyle: AppTextStyle.red14spTextStyle1),
                    ]),
              ),
            ),
            10.verticalSpace,
            const Divider(height: 0, color: AppColors.lightGrey)
          ],
          10.verticalSpace,
          Column(
            children: projectDetails
                .map((data) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          60.horizontalSpace,
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
          _buildSwitchBtn(group)
        ],
      ),
    );
  }

  Padding _buildSwitchBtn(ApproverGroups group) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("enableDisable".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          CupertinoSwitchWidget(
            value: group.status,
            onChanged: controller.canEdit
                ? (val) {
                    controller.enableDisable(group);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildExportFilterRow() {
    if (!controller.canView && !controller.canExport) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (controller.canExport)
          Expanded(
            child: expandedChip(
              label: 'export',
              icon: AppResources.exportIcon,
              onPressed: () => controller.exportGroups(),
            ),
          ),
        if (controller.canExport && controller.canView) 16.horizontalSpace,
        if (controller.canView)
          Expanded(
            child: expandedChip(
              label: 'filter',
              icon: AppResources.filterIcon,
              onPressed: () => controller.filterBottomSheet(),
            ),
          ),
      ],
    );
  }

}
