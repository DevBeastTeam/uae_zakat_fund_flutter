import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/search_results.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/search_result_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class SearchResultScreen extends GetView<SearchResultViewModel> {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "searchResult"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchSummary(),
          8.verticalSpace,
          tabBarWidget(
              controller.tabController, AppConstant.searchResultTabs, 0,
              newTab: true),
          8.verticalSpace,
          _buildResultsList(),
        ],
      ),
    );
  }

  Widget _buildSearchSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: Text(
          '${"youSearchedFor".tr} "${controller.searchText}"',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.grey12spTextStyle,
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Obx(() {
      final results = controller.searchResults;
      return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => Divider(
          color: AppColors.dividerColor,
          height: 16.h,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) => _buildResultItem(results[index]),
      );
    });
  }

  Widget _buildResultItem(SearchResults data) {
    final isArabic = Utils.isArabic;
    final title = isArabic ? data.headingAr : data.headingEn;
    final description = Utils.htmlToPlainText(
      isArabic ? data.descriptionAr : data.descriptionEn,
    );
    return GestureDetector(
      onTap: () => controller.openDetails(data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle3,
          ),
          8.verticalSpace,
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.darkGrey16spTextStyle,
          ),
          8.verticalSpace,
          Text(
            controller.dateFormat.format(data.createdDate),
            style: AppTextStyle.darkGreyOne14spTextStyle2,
          ),
        ],
      ),
    );
  }
}
