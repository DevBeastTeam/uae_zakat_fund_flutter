import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/recipients_campaign.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/recipients_campaign_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class RecipientsCampaignScreen extends GetView<RecipientsCampaignViewModel> {
  const RecipientsCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "recipients"),
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
            16.verticalSpace
          ],
          _buildCreateGroupBtn(),
          if (controller.canAdd) 10.verticalSpace,
          _buildExportFilterRow(),
          if (controller.canExport || controller.canView) 10.verticalSpace,
          if (controller.canView) ...[
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
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.pageSize = 10;
          controller.fetchRecipients(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.pageSize = 10;
        controller.fetchRecipients(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.pageSize = 10;
          controller.fetchRecipients(clear: true);
        }
      },
    );
  }

  Widget _buildCreateGroupBtn() {
    if (!controller.canAdd) {
      return SizedBox.shrink();
    }
    return addElevatedButton(
        onPressed: () => controller.addNewGroup(), text: "createGroup");
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recipients.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => newsItem(controller.recipients[index]),
        ));
  }

  Container newsItem(RecipientsCampaign recipients) {
    List<DashboardData> projectDetails = [
      DashboardData(title: "groupName", value: recipients.groupName),
      DashboardData(
          title: "groupType",
          value: recipients.groupType == 1 ? "fixed".tr : "dynamic".tr),
      DashboardData(
          title: "userType",
          value: Utils.groupsTypesString(recipients.userType).tr),
      DashboardData(
          title: "creationDate",
          value: Utils.dateFormat1.format(recipients.createdDate)),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
                Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: popupMenuButton(
                  onSelected: (value) =>
                      controller.onMenuSelected(value, recipients),
                  menuItems: controller.canView || controller.canEdit
                      ? [
                          popupMenuItem(
                              label: "details",
                              icon: AppResources.eyeIcon,
                              textStyle: AppTextStyle.darkBrown14spTextStyle),
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
                        ]
                      : []),
            ),
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
