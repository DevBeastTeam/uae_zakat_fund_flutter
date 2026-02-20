import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/all_companies_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class AllCompanyScreen extends GetView<AllCompaniesViewModel> {
  const AllCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: myAppBar(title: controller.getTitle()),
        body: _buildBody(),
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          if (controller.user.isAdmin && controller.canView) ...[
            Obx(() => buildStatsRow(0, controller.stats)),
            10.verticalSpace,
            Obx(() => buildStatsRow(3, controller.stats)),
          ],
          _buildAddButton(),
          if (controller.user.isAdmin && controller.canView ||
              controller.user.isAdmin && controller.canExport ||
              !controller.user.isAdmin && controller.canAdd)
            13.verticalSpace,
          _buildExportFilterRow(),
          if (controller.canView) ...[
            10.verticalSpace,
            _buildSearchField(),
            16.verticalSpace,
            _buildListView(),
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
              onPressed: () => controller.exportAssociationCompany(),
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

  Widget _buildAddButton() {
    if (!controller.user.isAdmin && controller.canAdd) {
      return addElevatedButton(
        onPressed: () => controller.addNewAssociationCompany(),
        text: controller.isAssociation
            ? "addNewAssociation".tr
            : "addNewCompany".tr,
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.searchData();
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.searchData();
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.searchData();
        }
      },
    );
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: !controller.user.isAdmin
              ? controller.associationCompanyData.length
              : controller.isAssociation
                  ? controller.associations.length
                  : controller.companies.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => _buildItem(index),
        ));
  }

  Widget _buildItem(int index) {
    final data = controller.extractItemData(index);
    final details = [
      DashboardData(title: "id", value: data.id),
      DashboardData(
          title: "name", value: Utils.isArabic ? data.nameAr : data.name),
      DashboardData(title: "email", value: data.email),
      DashboardData(title: "mobile", value: data.mobile),
      if (controller.user.isAdmin)
        DashboardData(
          title: "status",
          value: Utils.statusIntoString(data.status).tr,
        ),
      if (!controller.user.isAdmin) ...[
        if(data.status!=0)DashboardData(
          title: "employeeStatus",
          value: Utils.employeeStatusIntoString(data.status).tr,
        ),
        if(data.status==0)DashboardData(
          title: "status",
          value: Utils.statusIntoString(data.requestStatus!).tr,
        )
      ],
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data,index),
          10.verticalSpace,
          const Divider(height: 0, color: AppColors.lightGrey),
          10.verticalSpace,
          _buildDetails(details),
          _buildWebsite(data.website),
          4.verticalSpace,
          if (controller.user.isAdmin) _buildEnableSwitch(data, index)
        ],
      ),
    );
  }

  Padding _buildEnableSwitch(CompanyItemData data, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("enableDisable".tr,
              style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          CupertinoSwitchWidget(
            value: data.isActive,
            onChanged: controller.canEdit && data.status == 2
                ? (val) => controller.enableDisable(index)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildWebsite(String website) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("website".tr, style: AppTextStyle.primaryDarkGrey12spTextStyle1),
          if (website.isNotEmpty)
            GestureDetector(
              onTap: () => Utils.openUrl(website),
              child: Text(
                "visit".tr,
                style: AppTextStyle.lightBlue12spTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.lightBlueColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetails(List<DashboardData> details) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: details.map((data) {
          final isRtlSensitive =
              ["mobile", "fax", "email"].contains(data.title);
          final content = Utils.isArabic && isRtlSensitive
              ? Directionality(
                  textDirection: TextDirection.ltr,
                  child: valueTextWidget(data.value),
                )
              : valueTextWidget(data.value);

          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.title.tr,
                    style: AppTextStyle.primaryDarkGrey12spTextStyle1),
                data.title == "name" ? 70.horizontalSpace : 16.horizontalSpace,
                Flexible(child: content),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Padding _buildHeader(CompanyItemData data,int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedNetworkImage(
            imageUrl: "${FlavorConfig.storageUrl}${data.logo}",
            placeholder: (context, url) => Image.asset(
              AppResources.placeholder,
              fit: BoxFit.cover,
            ),
            height: 40.h,
            errorWidget: (context, url, error) => Image.asset(
              AppResources.placeholder,
              fit: BoxFit.cover,
            ),
          ),
          if (controller.user.isAdmin)
            popupMenuButton(
                onSelected: (String item) => controller.onPopupMenuSelected(item, data,),
                menuItems: [
                  popupMenuItem(
                      label: "view",
                      icon: AppResources.eyeIcon,
                      textStyle: AppTextStyle.darkBrown14spTextStyle),
                ]),
          if (!controller.user.isAdmin&&data.requestStatus==8)
            popupMenuButton(
                onSelected: (String item) => controller.onPopupMenuSelected(item, data),
                menuItems: [
                  popupMenuItem(
                      label: "edit",
                      icon: AppResources.editIcon1,
                      textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                ]),
          if (data.status == 3 &&
              data.info?.userId != controller.user.id &&
              !controller.user.isAdmin)
            popupMenuButton(
                onSelected: (String item) =>
                    controller.onPopupMenuSelected(item, data),
                menuItems: [
                  popupMenuItem(
                      label: "accept",
                      icon: AppResources.tickMarkIcon,
                      iconColor: AppColors.darkGreenColor,
                      textStyle: AppTextStyle.darkGreen14spTextStyle),
                  popupMenuItem(
                      label: "reject",
                      icon: AppResources.closeCircleIcon,
                      textStyle: AppTextStyle.darkRed14spTextStyle),
                ]),
        ],
      ),
    );
  }

  Text valueTextWidget(String value) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
    );
  }
}
