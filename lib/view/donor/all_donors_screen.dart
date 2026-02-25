import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/all_donors_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/cupertino_switch.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';

class AllDonorsScreen extends GetView<AllDonorsViewModel> {
  const AllDonorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: myAppBar(title: "donorList"),
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
            if (controller.canView) ...[
              Obx(() => buildStatsRow(0, controller.stats)),
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
              onPressed: () => controller.exportDonors(),
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

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.fetchAllDonors(clear: true);
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.fetchAllDonors(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.fetchAllDonors(clear: true);
        }
      },
    );
  }

  Obx _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.donors.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => donorItem(controller.donors[index]),
        ));
  }

  Widget donorItem(Individual donor) {
    String name = Utils.isArabic
        ? "${donor.accountInfo!.firstNameArabic} ${donor.accountInfo!.lastNameArabic}"
        : "${donor.accountInfo!.firstName} ${donor.accountInfo!.lastName}";
    List<DashboardData> donorDetails = [
      DashboardData(
          title: "donorId", value: donor.accountInfo!.userId.toString()),
      DashboardData(title: "donorName", value: name),
      DashboardData(title: "mobile", value: donor.contactInfo!.mobile),
      DashboardData(
          title: "registrationDate",
          value: Utils.dateFormat1.format(donor.accountInfo!.createdDate)),
      DashboardData(
          title: "totalDonations",
          value:
              "${"currency".tr} ${donor.accountInfo!.totalDonation.toInt()}"),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: CachedImage(
                    image: donor.accountInfo?.photo ?? "",
                    width: 40.w,
                    height: 40.h,
                    profile: true,
                  ),
                ),
                popupMenuButton(
                    onSelected: (val) => controller.onMenuSelected(donor),
                    menuItems: [
                      popupMenuItem(
                          label: "view",
                          icon: AppResources.eyeIcon,
                          textStyle: AppTextStyle.darkBrown14spTextStyle)
                    ]),
              ],
            ),
          ),
          10.verticalSpace,
          const Divider(
            height: 0,
            color: AppColors.lightGrey,
          ),
          10.verticalSpace,
          Column(
            children: donorDetails
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
                            child: Utils.isArabic && data.title == "mobile"
                                ? Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: valueTextWidget(data.value),
                                  )
                                : valueTextWidget(data.value),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          4.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("enableDisable".tr,
                    style: AppTextStyle.primaryDarkGrey12spTextStyle1),
                CupertinoSwitchWidget(
                  value: donor.contactInfo!.isActive,
                  onChanged: controller.canEdit
                      ? (val) {
                          controller.enableDisable(donor);
                        }
                      : null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Text valueTextWidget(String value) {
    return Text(value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1);
  }
}
