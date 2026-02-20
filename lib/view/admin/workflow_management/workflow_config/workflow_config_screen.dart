import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/workflows.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/workflow_config_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class WorkflowConfigScreen extends GetView<WorkflowConfigViewModel> {
  const WorkflowConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "workflowConfiguration"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          if (controller.canView) ...[
            Obx(() => buildStatsRow(0, controller.stats)),
            10.verticalSpace
          ],
          if (controller.canAdd) ...[
            _buildAddWorkflowBtn(),
            10.verticalSpace,
          ],
          _buildExportFilterRow(),
          if (controller.canView || controller.canExport) 10.verticalSpace,
          if (controller.canView) ...[
            _buildSearchField(),
            16.verticalSpace,
            _buildListView()
          ],
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
              onPressed: () => controller.exportWorkflowConfig(),
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

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.fetchWorkflows(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.fetchWorkflows(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.fetchWorkflows(clear: true);
        }
      },
    );
  }

  Widget _buildAddWorkflowBtn() {
    return addElevatedButton(
        onPressed: () => controller.addNewWorkflow(), text: "addNewWorkflow");
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.workflows.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) =>
              workflowItem(controller.workflows[index]),
        ));
  }

  Widget workflowItem(Workflows workflow) {
    List<DashboardData> projectDetails = [
      DashboardData(
          title: "workflowName",
          value: Utils.isArabic
              ? workflow.workflowNameArabic
              : workflow.workflowName),
      DashboardData(
          title: "workflowType",
          value: Utils.toCamelCase(workflow.requestType).tr),
      DashboardData(
          title: "levels", value: workflow.workflowLevels.length.toString()),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.canView || controller.canDelete || controller.canEdit)
            listViewHeaderPopUpMenu(
                status: workflow.isActive ? "active" : "inactive",
                onSelected: (value) =>
                    controller.onMenuSelected(value, workflow),
                menuItems: [
                  popupMenuItem(
                      label: "view",
                      icon: AppResources.eyeIcon,
                      textStyle: AppTextStyle.darkBrown14spTextStyle),
                  if (controller.canEdit)
                    popupMenuItem(
                        label: "edit",
                        icon: AppResources.editIcon1,
                        textStyle:
                            AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                  if (controller.canDelete)
                    popupMenuItem(
                        label: "delete",
                        icon: AppResources.removeIcon,
                        textStyle: AppTextStyle.red14spTextStyle1),
                ]),
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
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          65.horizontalSpace,
                          Flexible(
                            child: Text(data.value,
                                maxLines: 1,
                                textDirection: Utils.isArabic
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
          _buildSwitchBtn(workflow)
        ],
      ),
    );
  }

  Padding _buildSwitchBtn(Workflows workflow) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("enableDisable".tr,
                  style: AppTextStyle.primaryDarkGrey12spTextStyle1),
              CupertinoSwitchWidget(
                value: workflow.isActive,
                onChanged: controller.canEdit
                    ? (val) {
                        controller.enableDisable(workflow);
                      }
                    : null,
              ),
            ],
          ),
        );
  }
}
