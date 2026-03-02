import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/campaign_template.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/campaign_templates_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';

class CampaignTemplatesScreen extends GetView<CampaignTemplatesViewModel> {
  const CampaignTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "campaignTemplates"),
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
            Obx(() => _buildStatsWidget()),
            16.verticalSpace
          ],
          _buildCreateTemplateBtn(),
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

  Widget _buildStatsWidget() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("Total", controller.stats.value.total.toString()),
          _statItem("Accepted", controller.stats.value.accepted.toString()),
          _statItem("Pending", controller.stats.value.pending.toString()),
          _statItem("Rejected", controller.stats.value.rejected.toString()),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyle.secondaryPrimaryBlack14spTextStyle),
        4.verticalSpace,
        Text(label, style: AppTextStyle.primaryDarkGrey12spTextStyle1),
      ],
    );
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.pageSize.value = 10;
          controller.fetchTemplates(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.pageSize.value = 10;
        controller.fetchTemplates(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.pageSize.value = 10;
          controller.fetchTemplates(clear: true);
        }
      },
    );
  }

  Widget _buildCreateTemplateBtn() {
    if (!controller.canAdd) {
      return SizedBox.shrink();
    }
    return addElevatedButton(
        onPressed: () {
          Utils.showGlobalSnackBar(message: "Create template coming soon");
        },
        text: "createTemplate");
  }

  Widget _buildListView() {
    return Obx(() {
      if (controller.isLoading.value && controller.templates.isEmpty) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.templates.isEmpty) {
        return Center(
          child: Text("noDataFound".tr),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            controller.templates.length + (controller.isLoading.value ? 1 : 0),
        separatorBuilder: (_, int index) => 16.verticalSpace,
        itemBuilder: (_, int index) {
          if (index == controller.templates.length) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _templateItem(controller.templates[index]);
        },
      );
    });
  }

  Container _templateItem(CampaignTemplate template) {
    List<DashboardData> templateDetails = [
      DashboardData(title: "templateName", value: template.templateName),
      DashboardData(
          title: "status",
          value: template.isActive ? "active".tr : "inactive".tr),
      DashboardData(
          title: "category", value: template.category?.toString() ?? "N/A"),
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
                      controller.onMenuSelected(value, template),
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
            children: templateDetails
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
              onPressed: () => controller.exportTemplates(),
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
