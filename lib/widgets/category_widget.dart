import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/utils.dart';

class CategoryListView extends StatelessWidget {
  final dynamic viewModel;
  final void Function(int index) onTap;

  const CategoryListView({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Utils.isArabic;

    return SizedBox(
      height: 70.h,
      child: Obx(() {
        final selectedIndex = viewModel.categoryIndex.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: viewModel.categoriesList.length,
          separatorBuilder: (_, __) => 8.horizontalSpace,
          itemBuilder: (context, index) {
            final category = viewModel.categoriesList[index];
            final isSelected = selectedIndex == index;
            final categoryName = isArabic ? category.nameAr : category.name;

            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: 70.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlackColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(50.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 4),
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.primaryBlackColor,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
