import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/ads.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/ads_management_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class AdsManagementScreen extends GetView<AdsManagementViewModel> {
  const AdsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "adsManagement"),
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
          _buildAddAdsBtn(),
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

  Obx _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.ads.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => adsItem(controller.ads[index]),
        ));
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.pageSize = 10;
          controller.fetchAds(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.pageSize = 10;
        controller.fetchAds(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.pageSize = 10;
          controller.fetchAds(clear: true);
        }
      },
    );
  }

  Widget _buildAddAdsBtn() {
    if (!controller.canAdd) {
      return SizedBox.shrink();
    }
    return addElevatedButton(
        onPressed: () => controller.addNewAds(), text: "addNewAd");
  }

  Widget adsItem(Ads ad) {
    String status = Utils.statusIntoString(ad.requestStatus);
    List<DashboardData> projectDetails = [
      DashboardData(
          title: "title",
          value: ad.adLanguage == 2 ? ad.adTitleAr : ad.adTitleEn),
      DashboardData(
          title: "adType", value: ad.adType == 1 ? "banner".tr : "popUp".tr),
      DashboardData(
          title: "language",
          value: ad.adLanguage == 1 ? "english".tr : "arabic".tr),
      DashboardData(
          title: "expiryDate",
          value: ad.expiryDate != null
              ? Utils.dateFormat1.format(ad.expiryDate!)
              : ""),
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
              onSelected: (value) => controller.onMenuSelected(value, ad),
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
              ] : []),
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
                                textDirection: ad.adLanguage == 2
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
          _buildSwitchBtn(ad)
        ],
      ),
    );
  }

  Padding _buildSwitchBtn(Ads ad) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("enableDisable".tr,
                  style: AppTextStyle.primaryDarkGrey12spTextStyle1),
              CupertinoSwitchWidget(
                value: ad.isActive,
                onChanged: controller.canEdit && ad.requestStatus == 2
                    ? (val) {
                        controller.enableDisable(ad);
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
              onPressed: () => controller.exportAds(),
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
