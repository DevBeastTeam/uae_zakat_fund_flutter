import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/campaign.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/view_model/campaigns_admin_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class CampaignsAdminScreen extends GetView<CampaignsAdminViewModel> {
  const CampaignsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsRow(),
                24.verticalSpace,
                _buildActionsBar(),
                24.verticalSpace,
                _buildCampaignsList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsRow() {
    return Column(
      children: [
        Row(
          children: [
            _buildStatBox(controller.statsList[0]),
            10.horizontalSpace,
            _buildStatBox(controller.statsList[1]),
            10.horizontalSpace,
            _buildStatBox(controller.statsList[2]),
          ],
        ),
        10.verticalSpace,
        Row(
          children: [
            _buildStatBox(controller.statsList[3]),
            10.horizontalSpace,
            _buildStatBox(controller.statsList[4]),
            // SizedBox(width: 10.w)
            Spacer()
          ],
        ),
      ],
    );
  }

  Widget _buildStatBox(DashboardData stat) {
    return Expanded(
      child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: stat.backColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stat.title.tr,
              style: TextStyle(
                fontSize: 12.sp,
                color: stat.labelColor ?? Colors.grey[700],
              ),
            ),
            Text(
              stat.value,
              style: stat.style ??
                  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsBar() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                "export".tr,
                AppResources.exportIcon,
                controller.exportCampaigns,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildActionButton(
                "filter".tr,
                AppResources.filterIcon,
                controller.filterBottomSheet,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 24),
              10.horizontalSpace,
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearch,
                  decoration: InputDecoration(
                    hintText: "search".tr,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon,
                width: 20.w,
                height: 20.w,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
            10.horizontalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.campaigns.length,
      separatorBuilder: (context, index) => 10.verticalSpace,
      itemBuilder: (context, index) {
        final campaign = controller.campaigns[index];
        return _buildCampaignItem(campaign);
      },
    );
  }

  Widget _buildCampaignItem(Campaign campaign) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(campaign.campaignName.tr.length > 35
                    ? '${campaign.campaignName.tr.substring(0, 35)}...'
                    : campaign.campaignName.tr),
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    color: Color(0xffFFF9E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_horiz,
                      color: Color(0xffD69E2E), size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xffF0F0F0)),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildDataRow("requestorName", "Admin User"),
                12.verticalSpace,
                _buildDataRow("requestDate", campaign.startDate ?? "-"),
                12.verticalSpace,
                _buildDataRow("requestType", campaign.status ?? 'accepted'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor = const Color(0xffF6F9F4);
    Color textColor = const Color(0xff2E7D32);

    if (status.toLowerCase() == 'pending') {
      bgColor = const Color(0xffFEF9F0);
      textColor = const Color(0xffA17111);
    } else if (status.toLowerCase() == 'rejected' ||
        status.toLowerCase() == 'returned') {
      bgColor = const Color(0xffFFF4F4);
      textColor = const Color(0xffD32F2F);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        status.tr,
        style: TextStyle(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuIcon() {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: const BoxDecoration(
        color: Color(0xffF5F5F5),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.more_vert, size: 18.w, color: Colors.grey[600]),
    );
  }
}
