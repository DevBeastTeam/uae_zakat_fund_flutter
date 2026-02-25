import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/notification_management_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class NotificationManagementScreen
    extends GetView<NotificationManagementViewModel> {
  const NotificationManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "notificationsManagement"),
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
            10.verticalSpace,
            Obx(() => buildStatsRow(3, controller.stats)),
            16.verticalSpace
          ],
          _buildAddNotificationBtn(),
          if (controller.canAdd) 10.verticalSpace,
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

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.pageSize = 10;
          controller.fetchNotifications(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.pageSize = 10;
        controller.fetchNotifications(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.pageSize = 10;
          controller.fetchNotifications(clear: true);
        }
      },
    );
  }

  Widget _buildAddNotificationBtn() {
    if (!controller.canAdd) {
      return SizedBox.shrink();
    }
    return addElevatedButton(
        onPressed: () => controller.addNewNotification(),
        text: "addNewNotification");
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) =>
              newsItem(controller.notifications[index]),
        ));
  }

  Container newsItem(Notifications notification) {
    String status = Utils.statusIntoString(notification.requestStatus);
    List<DashboardData> projectDetails = [
      DashboardData(title: "id", value: notification.id.toString()),
      DashboardData(
          title: "title",
          value: Utils.isArabic ? notification.titleAr : notification.titleEn),
      DashboardData(
          title: "type",
          value:
              notification.iconName == "3" ? "warning".tr : "notification".tr),
      DashboardData(title: "recipients", value: notification.recipients),
      DashboardData(
          title: "creationDate",
          value: Utils.dateFormat1.format(notification.createdDate)),
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
              onSelected: (value) =>
                  controller.onMenuSelected(value, notification),
              menuItems: controller.canView || controller.canEdit
                  ? [
                      popupMenuItem(
                          label: "preview",
                          icon: AppResources.eyeIcon,
                          textStyle: AppTextStyle.darkBrown14spTextStyle),
                      if (controller.canEdit)
                        popupMenuItem(
                            label: "edit",
                            icon: AppResources.editIcon1,
                            textStyle: AppTextStyle
                                .secondaryPrimaryBlack14spTextStyle),
                    ]
                  : []),
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
              onPressed: () => controller.exportNotifications(),
            ),
          ),
        if (controller.canView && controller.canExport) 16.horizontalSpace,
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
