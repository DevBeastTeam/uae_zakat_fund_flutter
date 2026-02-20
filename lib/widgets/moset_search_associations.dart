import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/row_header.dart';

class MostSearchedAssociations extends GetView<HomeViewModel> {
  const MostSearchedAssociations({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.associations.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(
            title: 'mostSearchedAssociations',
            onPressed: () => Get.toNamed(AppRoutes.allAssociationsScreen),
          ),
          SizedBox(
            height: 187.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.associations.length>10?10:controller.associations.length,
              separatorBuilder: (_, __) => 16.horizontalSpace,
              itemBuilder: (_, index) {
                final association = controller.associations[index];
                return _buildAssociationCard(association);
              },
            ),
          ),
          10.verticalSpace,
        ],
      );
    });
  }

  Widget _buildAssociationCard(Project association) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.associationDetailsScreen,
        arguments: association.accountId,
      ),
      child: Container(
        width: 111.w,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildAssociationImage(association),
            20.verticalSpace,
            _buildProjectCountChip(association.projects.length),
            6.verticalSpace,
            _buildAssociationName(association),
          ],
        ),
      ),
    );
  }

  Widget _buildAssociationImage(Project association) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      child: Container(
        height: 64.h,
        width: double.infinity,
        color: AppColors.lightWhiteColor,
        child: association.accountLogo != null
            ? CachedImage(
          image: association.accountLogo!,
          height: 64.h,
          width: double.infinity,
          isCover: false,
        )
            : Image.asset(
          AppResources.placeholder,
          height: 64.h,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProjectCountChip(int count) {
    return Chip(
      label: Text(
        "$count ${"projects".tr}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.darkBrownColor,
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      backgroundColor: AppColors.lightGreyColor,
      visualDensity: VisualDensity.comfortable,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide.none,
    );
  }

  Widget _buildAssociationName(Project association) {
    final name = Utils.isArabic
        ? association.accountNameArabic
        : association.accountName;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        name,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.sp,
          height: 1.5.h,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

}