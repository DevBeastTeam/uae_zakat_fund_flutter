import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/campaign_template.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/campaign_templates_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

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

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Templates".tr,
            style: AppTextStyle.secondaryPrimaryBlack24spTextStyle2,
          ),
          16.verticalSpace,
          if (controller.canView) ...[
            Obx(() => buildStatsRow(0, controller.statsList)),
            16.verticalSpace
          ],
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

  Widget _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.fetchTemplates(clear: true);
        }
      },
      onSubmitted: (val) {
        controller.fetchTemplates(clear: true);
      },
      onClear: () {
        controller.searchController.clear();
        controller.fetchTemplates(clear: true);
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

  Widget _buildListView() {
    return Obx(() {
      if (controller.isLoading.value && controller.templates.isEmpty) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: CircularProgressIndicator(),
        ));
      }

      if (controller.templates.isEmpty) {
        return Container(
          padding: EdgeInsets.all(40.h),
          alignment: Alignment.center,
          child: Text("noDataFound".tr,
              style: AppTextStyle.darkGrey114spTextStyle),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.templates.length +
            (controller.hasMoreData.value ? 1 : 0),
        separatorBuilder: (_, int index) => 16.verticalSpace,
        itemBuilder: (_, int index) {
          if (index == controller.templates.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildTemplateItem(controller.templates[index]);
        },
      );
    });
  }

  Widget _buildTemplateItem(CampaignTemplate template) {
    String status =
        template.status ?? (template.isActive ? "Accepted" : "Pending");

    List<DashboardData> templateDetails = [
      DashboardData(title: "pageName", value: template.templateName),
      if (template.templateTitle != null)
        DashboardData(title: "pageTitle", value: template.templateTitle!),
      DashboardData(title: "creationDate", value: template.creationDate ?? "-"),
      DashboardData(
          title: "lastModifiedDate", value: template.lastModifiedDate ?? "-"),
      DashboardData(title: "creatorName", value: template.creatorName ?? "-"),
      DashboardData(title: "category", value: template.category ?? "Email"),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border:
              Border.all(color: AppColors.lightGrey.withValues(alpha: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listViewHeaderPopUpMenu(
              status: status,
              onSelected: (value) => controller.onMenuSelected(value, template),
              menuItems: [
                popupMenuItem(
                    label: "view",
                    icon: AppResources.eyeIcon,
                    textStyle: AppTextStyle.darkBrown14spTextStyle),
                if (controller.canEdit)
                  popupMenuItem(
                    label: "edit",
                    icon: AppResources.editIcon1,
                    textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                  ),
                if (controller.canDelete)
                  popupMenuItem(
                    label: "delete",
                    icon: AppResources.removeIcon,
                    textStyle: AppTextStyle.red14spTextStyle1,
                  ),
              ]),
          12.verticalSpace,
          const Divider(height: 0, color: AppColors.lightGrey),
          12.verticalSpace,
          Column(
            children: templateDetails
                .map((data) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.title.tr,
                              style: AppTextStyle.primaryDarkGrey12spTextStyle
                                  .copyWith(
                                color: AppColors.darkGreyColor
                                    .withValues(alpha: 0.6),
                                fontSize: 13.sp,
                              )),
                          10.horizontalSpace,
                          Flexible(
                            child: Text(data.value,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle
                                    .secondaryPrimaryBlack14spTextStyle1
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                )),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("deactivateActivate".tr,
                    style: AppTextStyle.primaryDarkGrey12spTextStyle.copyWith(
                      color: AppColors.darkGreyColor.withValues(alpha: 0.6),
                      fontSize: 13.sp,
                    )),
                CupertinoSwitchWidget(
                  value: template.isActive,
                  onChanged: (val) => controller.toggleTemplateStatus(template),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
