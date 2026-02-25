import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/statics_view_model.dart';

class StatisticsScreen extends GetView<StaticsViewModel> {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final statics = controller.statistics.value;
      return statics != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('usersInsights'),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'totalRegisteredUsers',
                        value: statics.totalRegisteredUsers.toString(),
                        icon: AppResources.registeredUsers),
                    InsightCard(
                        title: 'activeUsers',
                        value: statics.activeUsers.toString(),
                        icon: AppResources.activeUsers),
                  ),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'growthRate',
                        value: '${statics.growthRate}%',
                        badgeText: '+20%',
                        icon: AppResources.growthRate),
                    InsightCard(
                        title: 'userRetentionRate',
                        value: '${statics.donorRetentionRate}%',
                        badgeText: '+20%',
                        icon: AppResources.retentionRate),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('projectsInsights'),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'totalActiveProjects',
                        value: statics.activeUsers.toString(),
                        icon: AppResources.activeProjects),
                    InsightCard(
                        title: 'completedProjects',
                        value: statics.completedProjects.toString(),
                        icon: AppResources.completedProject),
                  ),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'urgentNeedProjects',
                        value: statics.urgentNeedProjects.toString(),
                        icon: AppResources.urgentProjects),
                    Opacity(
                      opacity: 0.0,
                      child: InsightCard(
                          title: 'completedProjects',
                          value: statics.completedProjects.toString(),
                          icon: AppResources.completedProject),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('associationsInsights'),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'totalAssociationRegistered',
                        value: statics.totalAssociationsRegistered.toString(),
                        icon: AppResources.totalAssociations),
                    InsightCard(
                        title: 'activeAssociations',
                        value: statics.approvedAssociations.toString(),
                        icon: AppResources.activeAssociations),
                  ),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'associationContributions',
                        value:
                            '${"currency".tr} ${statics.associationsContributions}',
                        icon: AppResources.associationContributions),
                    InsightCard(
                        title: 'newAssociationsThisMonth',
                        value: statics.newAssociations.toString(),
                        icon: AppResources.newAssociations),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('donorsInsights'),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'donorsCount',
                        value: statics.totalDonors.toString(),
                        icon: AppResources.donorsCount),
                    InsightCard(
                        title: 'uniqueDonors',
                        value: statics.uniqueDonors.toString(),
                        icon: AppResources.uniqueDonors),
                  ),
                  const SizedBox(height: 12),
                  _buildGridRow(
                    InsightCard(
                        title: 'averageDonationAmount',
                        value:
                            '${"currency".tr} ${statics.averageDonationAmount}',
                        icon: AppResources.averageDonationAmount),
                    InsightCard(
                        title: 'topDonationCategory',
                        value: Utils.isArabic
                            ? statics.topDonationCategoryAr
                            : statics.topDonationCategoryEn,
                        icon: AppResources.topDonorCat),
                  ),
                  110.verticalSpace,
                ],
              ),
            )
          : SizedBox.shrink();
    });
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.tr,
      style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1,
    );
  }

  Widget _buildGridRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}


class InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final String? badgeText;

  const InsightCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            width: 32.w,
            height: 32.h,
          ),
          const SizedBox(height: 16),
          Text(
            title.tr,
            style: AppTextStyle.lightBlackColor12TextStyle2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyle.bottomBarTextColor18spTextStyle,
              ),
              // if (badgeText != null) ...[
              //   const SizedBox(width: 6),
              //   Container(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF5D4037),
              //       borderRadius: BorderRadius.circular(4),
              //     ),
              //     child: Text(
              //       badgeText!,
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 10,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ],
      ),
    );
  }
}
