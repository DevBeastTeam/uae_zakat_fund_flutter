import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/audit_logs.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/audit_log_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';

class AuditLogScreen extends GetView<AuditLogViewModel> {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "auditLog"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildExportFilterRow(),
          if (controller.canView || controller.canExport) 10.verticalSpace,
          if (controller.canView) ...[
            _buildSearchField(),
            16.verticalSpace,
            _buildListView()
          ]
        ],
      ),
    );
  }

  Obx _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.auditLogs.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) =>
              auditLogsItem(controller.auditLogs[index]),
        ));
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.fetchAuditLogs(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.fetchAuditLogs(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.fetchAuditLogs(clear: true);
        }
      },
    );
  }

  Container auditLogsItem(AuditLogs log) {
    List<DashboardData> projectDetails = [
      DashboardData(
          title: "name", value: Utils.isArabic ? log.nameAr : log.nameEn),
      DashboardData(
          title: "action", value: Utils.isArabic ? log.actionAr : log.actionEn),
      DashboardData(title: "role", value: log.userRole.toLowerCase().tr),
      DashboardData(
          title: "entityType",
          value: Utils.isArabic ? log.entityTypeAr : log.entityTypeEn),
      DashboardData(title: "entityId", value: log.entityId.toString()),
      DashboardData(
          title: "timestamp",
          value: Utils.dateTimeFormat.format(log.createdDate)),
      DashboardData(title: "ipAddress", value: log.ipAddress),
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
              status: log.status.toLowerCase(),
              onSelected: (value) => controller.onMenuSelected(log),
              menuItems: [
                popupMenuItem(
                    label: "view",
                    icon: AppResources.eyeIcon,
                    textStyle: AppTextStyle.darkBrown14spTextStyle),
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
                          16.horizontalSpace,
                          Flexible(
                            child: Text(data.value,
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
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
              onPressed: () => controller.exportAuditLogs(),
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
