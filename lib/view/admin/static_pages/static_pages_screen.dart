import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/static_page.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cms_static_page_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class StaticPagesScreen extends GetView<CMSStaticPageViewModel> {
  const StaticPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "staticPage"),
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
          controller.fetchStaticPages(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.fetchStaticPages(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.fetchStaticPages(clear: true);
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
              onPressed: () => controller.exportStaticPages(),
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

  Obx _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.staticPages.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => staticPageItem(controller.staticPages[index]),
        ));
  }

  Container staticPageItem(StaticPage page) {
    String status = Utils.statusIntoString(page.requestStatus ?? 2);
    String section = page.pageSection == 1 ? "header".tr : "footer".tr;
    String parentPage = page.pageSection == 1
        ? Utils.headerParentPageIntoString(page.parentPage ?? 0)
        : Utils.footerParentPageIntoString(page.parentPage ?? 0);

    List<DashboardData> pageDetails = [
      DashboardData(
          title: "pageName",
          value: page.pageNameEN ?? ""),
      DashboardData(
          title: "pageTitle",
          value: Utils.isArabic ? (page.pageTitleAR ?? "") : (page.pageTitleEN ?? "")),
      DashboardData(title: "pageSection", value: section),
      DashboardData(title: "parentPage", value: parentPage),
      DashboardData(
          title: "pageOrder",
          value: page.pageOrder?.toString() ?? ""),
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
              onSelected: (value) => controller.onMenuSelected(value, page),
              menuItems: controller.canView
                  ? [
                      popupMenuItem(
                          label: "view",
                          icon: AppResources.eyeIcon,
                          textStyle: AppTextStyle.darkBrown14spTextStyle),
                    ]
                  : []),
          10.verticalSpace,
          const Divider(height: 0, color: AppColors.lightGrey),
          10.verticalSpace,
          Column(
            children: pageDetails
                .map((data) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          50.horizontalSpace,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("enableDisable".tr,
                    style: AppTextStyle.primaryDarkGrey12spTextStyle1),
                CupertinoSwitchWidget(
                  value: page.isPageActive,
                  onChanged: null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
