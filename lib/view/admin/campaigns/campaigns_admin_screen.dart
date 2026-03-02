import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/campaign.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/campaigns_admin_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class CampaignsAdminScreen extends GetView<CampaignsAdminViewModel> {
  const CampaignsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: myAppBar(
        title: "campaigns",
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.campaigns.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchCampaigns(isRefresh: true),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "campaigns".tr,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                20.verticalSpace,
                _buildStatsRow(),
                20.verticalSpace,
                _buildActionsBar(),
                20.verticalSpace,
                _buildCampaignsList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.statsList.map<Widget>((stat) {
          return Container(
            width: 160.w,
            margin: EdgeInsets.only(right: 15.w),
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: stat.backColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
                10.verticalSpace,
                Text(
                  stat.value,
                  style: stat.style ??
                      TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionsBar() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearch,
                  decoration: InputDecoration(
                    hintText: "searchByName".tr,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                ),
              ),
              10.horizontalSpace,
              _buildIconButton(
                  AppResources.filterIcon, controller.filterBottomSheet),
              10.horizontalSpace,
              _buildIconButton(
                  AppResources.exportIcon, controller.exportCampaigns),
            ],
          ),
          15.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.createCampaign,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text("createCampaign".tr,
                  style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8B6E2F),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: SvgPicture.asset(icon, width: 20.w, height: 20.w),
      ),
    );
  }

  Widget _buildCampaignsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.campaigns.length,
      separatorBuilder: (context, index) => 15.verticalSpace,
      itemBuilder: (context, index) {
        final campaign = controller.campaigns[index];
        return _buildCampaignItem(campaign);
      },
    );
  }

  Widget _buildCampaignItem(Campaign campaign) {
    final List<DashboardData> details = [
      DashboardData(title: "id", value: campaign.id.toString()),
      DashboardData(title: "campaignName", value: campaign.campaignName),
      DashboardData(title: "language", value: campaign.language ?? "English"),
      DashboardData(title: "category", value: campaign.category ?? "Email"),
      DashboardData(title: "startDate", value: campaign.startDate ?? "-"),
      if (campaign.createdByName != null)
        DashboardData(title: "createdByName", value: campaign.createdByName!),
      if (campaign.createdDate != null)
        DashboardData(title: "createdDate", value: campaign.createdDate!),
      if (campaign.lastModifiedByName != null)
        DashboardData(
            title: "lastModifiedByName", value: campaign.lastModifiedByName!),
      if (campaign.lastModifiedDate != null)
        DashboardData(
            title: "lastModifiedDate", value: campaign.lastModifiedDate!),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.chipBackgroundColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    (campaign.status ?? 'accepted').tr,
                    style: TextStyle(
                      color: AppColors.darkBrownColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey[400]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              children: [
                ...details.map<Widget>((detail) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${detail.title.tr}:",
                              style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              detail.value,
                              style: AppTextStyle
                                  .secondaryPrimaryBlack12spTextStyle1,
                            ),
                          ),
                        ],
                      ),
                    )),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "status".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: campaign.isActive ?? true,
                      onChanged: (val) {},
                      activeColor: const Color(0xff8B6E2F),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
