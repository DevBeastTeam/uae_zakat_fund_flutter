import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/faq_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/tabbar_widget_v2.dart';

class FaqScreen extends GetView<FaqViewModel> {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentGrey,
      appBar: myAppBar(title: controller.isPreview ? "preview" : "faq"),
      bottomNavigationBar: controller.isPreview ? _buildBottomBar() : null,
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    final hasData = controller.faqs.isNotEmpty || controller.allFaqs.isNotEmpty;
    if (!hasData) return const SizedBox.shrink();
    return WillPopScope(
      onWillPop: () => controller.handlePopScope(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!controller.isPreview) _buildSearchField(),
          if (controller.isPreview) 16.verticalSpace,
          Obx(() => TabBarWidgetV2(
                tabs: controller.tabs,
                currentIndex: controller.currentTabIndex.value,
                onTabChanged: (index) =>
                    controller.tabController.animateTo(index),
              )),
          16.verticalSpace,
          if (controller.subFaqs.isNotEmpty) _buildExpansionPanelList()
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: CupertinoSearchField(
        controller: controller.searchController,
        onChanged: (_) => controller.filterFAQ(),
      ),
    );
  }

  Widget _buildExpansionPanelList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 16.h),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.accentGrey,
            border: Border.all(
              color: AppColors.secondaryLightGreyColor,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: ExpansionPanelList(
            elevation: 0,
            dividerColor: AppColors.lightGrey,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: controller.onExpansionCallback,
            children: controller.subFaqs.map(_buildExpansionItem).toList(),
          ),
        ),
      ),
    );
  }

  ExpansionPanel _buildExpansionItem(FaQs faq) {
    final question = Utils.isArabic ? faq.questionArabic : faq.question;
    final answer = Utils.isArabic ? faq.answerArabic : faq.answer;

    return ExpansionPanel(
      canTapOnHeader: true,
      backgroundColor: AppColors.accentGrey,
      isExpanded: faq.isExpanded,
      headerBuilder: (context, _) => ListTile(
        contentPadding: EdgeInsets.only(
          right: Utils.isArabic ? 16.w : 0,
          left: Utils.isArabic ? 0 : 16.w,
        ),
        title: Text(
          question,
          style: AppTextStyle.black16spTextStyle2,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answer,
              style: AppTextStyle.darkGrey16spTextStyle,
            ),
            4.verticalSpace,
            const Divider(color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageToggleButton(),
          10.verticalSpace,
          elevatedButton(
            text: "back",
            onPressed: () => controller.goToBack(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggleButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
        minimumSize: Size(Get.width, 45.h),
      ),
      onPressed: () => controller.toggleLanguage(),
      label: Text(
        Utils.isArabic ? "previewInEnglish".tr : "previewInArabic".tr,
        maxLines: 1,
        style: AppTextStyle.primaryDarkBrown16spTextStyle1,
      ),
      icon: const Icon(
        Icons.visibility_rounded,
        color: AppColors.primaryDarkBrownColor,
      ),
    );
  }
}
