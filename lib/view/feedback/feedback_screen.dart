import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/feedbacks.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/feedback_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/search_add_container.dart';
import 'package:zakat_fund/widgets/stats_row_widget.dart';
import 'package:zakat_fund/widgets/status_chip.dart';

class FeedbackScreen extends GetView<FeedbackViewModel> {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: myAppBar(title: "feedbackViewList"),
        backgroundColor: Colors.white,
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
            Obx(() => buildStatsRow(0,controller.stats)),
            10.verticalSpace,
            Obx(() => buildStatsRow(3,controller.stats)),
            10.verticalSpace,
          ],
          _buildAddButton(),
          _buildAdminActions(),
          _buildExportFilterRow(),
          if (controller.canView) ...[
            10.verticalSpace,
            _buildSearchField(),
            16.verticalSpace,
            buildListView(),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    if (!controller.user.isAdmin && controller.canAdd) {
      return Column(
        children: [
          addElevatedButton(
            onPressed: () => controller.addNewFeedbackScreen(),
            text: "addFeedback",
          ),
          10.verticalSpace,
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAdminActions() {
    if (!controller.user.isAdmin) return const SizedBox.shrink();
    return Column(
      children: [
        OutlinedButton.icon(
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size(Get.width, 40.h)),
            elevation: const WidgetStatePropertyAll(0),
          ),
          onPressed: () => controller.assignDialog(),
          label:
              Text("assignBulk".tr, style: AppTextStyle.btnText14spTextStyle2),
          icon: SvgPicture.asset(AppResources.docUploadIcon),
        ),
        10.verticalSpace,
      ],
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
              onPressed: () => controller.exportFeedbacks(),
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

  Widget _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) controller.fetchAllFeedbacks(clear: true);
      },
      onClear: () {
        controller.searchController.clear();
        controller.fetchAllFeedbacks(clear: true);
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) controller.fetchAllFeedbacks(clear: true);
      },
    );
  }



  Widget buildListView() => Obx(() => ListView.separated(
        itemCount: controller.feedback.length,
        shrinkWrap: true,
        primary: false,
        separatorBuilder: (_, int index) => 16.verticalSpace,
        itemBuilder: (BuildContext context, int index) {
          Feedbacks feedback = controller.feedback[index];
          return _buildFeedbackItem(feedback, index);
        },
      ));

  Container _buildFeedbackItem(Feedbacks feedback, int index) {
    String status = Utils.statusIntoString(feedback.requestStatus);
    List<DashboardData> details = [
      DashboardData(title: "title", value: feedback.titleEn),
      if (controller.user.isAdmin)
        DashboardData(
            title: "name",
            value: Utils.isArabic ? feedback.nameAr : feedback.nameEn),
      DashboardData(title: "email", value: feedback.email),
      DashboardData(title: "phoneNumber", value: feedback.mobile),
      if (controller.user.isAdmin)
        DashboardData(
            title: "userType",
            value: Utils.feedbackUserTypeIntoString(feedback.feedbackUserType)),
      DashboardData(
          title: "feedbackType",
          value: Utils.feedbackTypeIntoString(feedback.feedbackType)),
      DashboardData(
          title: "status", value: feedback.isClosed ? "closed".tr : status.tr),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.user.isAdmin && feedback.requestStatus == 1)
                  Checkbox(
                    value: feedback.selected,
                    onChanged: (val) =>
                        controller.oncCheckboxChanged(val!, feedback),
                    side: const BorderSide(color: AppColors.darkBlackColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  ),
                if (!controller.user.isAdmin) statusChip(status),
                Spacer(),
                Align(
                  child: popupMenuButton(
                      onSelected: (String item) =>
                          controller.onPopupMenuSelected(item, feedback.id),
                      menuItems: [
                        popupMenuItem(
                            label: "view",
                            icon: AppResources.eyeIcon,
                            textStyle: AppTextStyle.darkBrown14spTextStyle),
                        if (controller.user.isAdmin &&
                            feedback.requestStatus == 1)
                          popupMenuItem(
                              label: "assign",
                              icon: AppResources.docUploadIcon,
                              textStyle: AppTextStyle.darkBrown14spTextStyle),
                      ]),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          const Divider(
            height: 0,
            color: AppColors.lightGrey,
          ),
          10.verticalSpace,
          _buildDetails(details)
        ],
      ),
    );
  }

  Padding _buildDetails(List<DashboardData> details) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: List.generate(
            details.length,
            (dataIndex) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          details[dataIndex].title.tr,
                          style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                        ),
                        50.horizontalSpace,
                        Flexible(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              details[dataIndex].value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle
                                  .secondaryPrimaryBlack12spTextStyle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                  ],
                )).toList(),
      ),
    );
  }
}
