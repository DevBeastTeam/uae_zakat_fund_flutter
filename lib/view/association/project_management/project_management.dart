import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/project_management_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/statistics_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class ProjectManagementScreen extends GetView<ProjectManagementViewModel> {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: myAppBar(title: "projectManagement"),
        body: _buildBody(),
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummary(),
              if (controller.canView) 16.verticalSpace,
              if (controller.isAdmin.value && controller.canView) ...[
                Obx(() => buildStatsRow(0,controller.stats)),
                10.verticalSpace,
                Obx(() => buildStatsRow(3,controller.stats)),
                16.verticalSpace,
              ],
              _buildAddProjectBtn(),
              if (!controller.isAdmin.value && controller.canAdd)
                10.verticalSpace,
              _buildExportFilterRow(),
              if (controller.canView) ...[
                10.verticalSpace,
                _buildSearchField(),
                16.verticalSpace,
                _buildListView(),
              ],
            ],
          )),
    );
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.pageSize = 10;
          controller.fetchProjects(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.pageSize = 10;
        controller.fetchProjects(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.pageSize = 10;
          controller.fetchProjects(clear: true);
        }
      },
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
              onPressed: () => controller.exportProjects(),
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

  Widget _buildAddProjectBtn() {
    if (!controller.isAdmin.value && controller.canAdd) {
      return addElevatedButton(
          onPressed: () =>
              Get.toNamed(AppRoutes.createProjectScreen)!.then((val) {
                if (val != null && val) {
                  if (controller.canView) {
                    controller.pageSize = 10;
                    controller.fetchProjects(clear: true);
                  }
                }
              }),
          text: "createProject");
    }
    return SizedBox.shrink();
  }


  Widget _buildSummary() {
    if (!controller.canView) {
      return SizedBox.shrink();
    }
    return FittedBox(
      child: Row(
        children: [
          statisticsContainer(controller.dashboardData[0]),
          8.horizontalSpace,
          statisticsContainer(controller.dashboardData[1]),
          8.horizontalSpace,
          statisticsContainer(controller.dashboardData[2]),
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.projects.length,
      separatorBuilder: (_, int index) => 16.verticalSpace,
      itemBuilder: (_, int index) => projectItem(controller.projects[index]),
    );
  }

  Container projectItem(ProjectElements project) {
    String status = Utils.statusIntoString(project.requestStatus);
    String startDate = "", endDate = "";
    if (project.endDate != null) {
      endDate = Utils.dateFormat1.format(project.endDate!);
    }
    if (project.startDate != null) {
      startDate = Utils.dateFormat1.format(project.startDate!);
    }
    List<DashboardData> projectDetails = [
      DashboardData(
          title: "projectName",
          value:
              Utils.isArabic ? project.projectNameArabic : project.projectName),
      if (controller.isAdmin.value)
        DashboardData(
            title: "association",
            value:
                "${Utils.isArabic ? project.associationNameArabic : project.associationName}"),
      DashboardData(title: "startDate", value: startDate),
      DashboardData(title: "endDate", value: endDate),
      DashboardData(
          title: "totalDonations",
          value:
              "${"currency".tr} ${project.totalDonations != null ? project.totalDonations!.toInt() : 0}"),
      DashboardData(
          title: "goal",
          value: project.projectAmountObjective != ""
              ? "${"currency".tr} ${project.projectAmountObjective.toInt()}"
              : ""),
      DashboardData(title: "noOfDonors", value: "${project.totalDonors ?? 0}"),
      DashboardData(
          title: "completion",
          value:
              "${project.percentOfCompletion != null ? project.percentOfCompletion.toInt() : 0}%"),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listViewHeaderPopUpMenu(
            status: status,
            onSelected: (item) => controller.onPopUpMenuSelected(item, project),
            menuItems: controller.canView || controller.canEdit
                ? [
                    popupMenuItem(
                        label: "view",
                        icon: AppResources.eyeIcon,
                        textStyle: AppTextStyle.darkBrown14spTextStyle),
                    if (controller.canEdit && !controller.isAdmin.value)
                      popupMenuItem(
                          label: "edit",
                          icon: AppResources.editIcon1,
                          textStyle:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                  ]
                : [],
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
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          16.horizontalSpace,
                          if (data.title != "completion")
                            Flexible(
                              child: Text(data.value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle
                                      .secondaryPrimaryBlack12spTextStyle1),
                            ),
                          if (data.title == "completion")
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  data.value,
                                  style: AppTextStyle
                                      .secondaryPrimaryBlack8spTextStyle,
                                ),
                                CircularProgressIndicator(
                                  value: project.percentOfCompletion != null
                                      ? project.percentOfCompletion / 100
                                      : 0,
                                  color: AppColors.secondaryBtnBackgroundColor,
                                  backgroundColor: AppColors.progressBack,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          4.verticalSpace,
          _buildSwitchBtn(project)
        ],
      ),
    );
  }

  Widget _buildSwitchBtn(ProjectElements project) {
    if (!controller.isAdmin.value) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("enableDisable".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          CupertinoSwitchWidget(
            value: project.isPublished,
            onChanged: controller.canEdit && project.requestStatus == 2
                ? (val) {
                    controller.enableDisable(project);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
