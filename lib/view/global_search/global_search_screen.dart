import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/global_search_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class GlobalSearchScreen extends GetView<GlobalSearchViewModel> {
  const GlobalSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarColor,
      appBar: myAppBar(title: "search"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            16.verticalSpace,
            _buildPopularSearchText(),
            16.verticalSpace,
            _buildCategoryWrap()
          ],
        ),
      ),
    );
  }

  Wrap _buildCategoryWrap() {
    return Wrap(
      spacing: 8.w,
      children: AppConstant.searchKeywords
          .map((keyword) => RawChip(
                label: Text(keyword.tr),
                onPressed: () => controller.openSearchResultsScreen(keyword),
                labelStyle: AppTextStyle.darkBrown12spTextStyle,
                backgroundColor: AppColors.warningBackColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ))
          .toList(),
    );
  }

  Text _buildPopularSearchText() {
    return Text(
      "popularSearch".tr,
      style: AppTextStyle.btnBackground14spTextStyle,
    );
  }

  CupertinoSearchField _buildSearchBar() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {},
      onSubmitted: (val)=>controller.onSearchQuery(val),
    );
  }
}
