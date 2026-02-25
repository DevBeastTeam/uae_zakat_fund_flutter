import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/group_details.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/group_details_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/list_view_heaader_menu.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class RecipientDetailsScreen extends GetView<RecipientDetailsViewModel> {
  const RecipientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "recipientsDetails"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          Text(
            controller.group.groupName,
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          _buildSearchField(),
          16.verticalSpace,
          _buildListView(),
        ],
      ),
    );
  }

  CupertinoSearchField _buildSearchField() {
    return CupertinoSearchField(
      controller: controller.searchController,
      onChanged: (val) {
        if (val.trim().isEmpty) {
          controller.clearAllRecipients();
        } else {
          controller.filterRecipientByEmail();
        }
      },
      onClear: () {
        controller.searchController.clear();
        controller.clearAllRecipients();
      },
      onSubmitted: (val) {
        if (val.trim().isNotEmpty) {
          controller.filterRecipientByEmail();
        }
      },
    );
  }

  Widget _buildListView() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recipients.length,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) => newsItem(controller.recipients[index]),
        ));
  }

  Container newsItem(GroupDetails details) {
    List<DashboardData> projectDetails = [
      DashboardData(title: "name", value: details.userName),
      DashboardData(title: "email", value: details.email),
      DashboardData(title: "phoneNumber", value: details.mobile),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        children: [
          if (controller.canDelete) ...[
            Align(
              alignment:
                  Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: popupMenuButton(
                    onSelected: (value) => controller.deleteRecipient(details),
                    menuItems: [
                      popupMenuItem(
                          label: "delete",
                          icon: AppResources.removeIcon,
                          textStyle: AppTextStyle.red14spTextStyle1),
                    ]),
              ),
            ),
            10.verticalSpace,
            const Divider(height: 0, color: AppColors.lightGrey),
            10.verticalSpace
          ],
          Column(
            children: projectDetails
                .map((data) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data.title.tr,
                              style:
                                  AppTextStyle.primaryDarkGrey12spTextStyle1),
                          65.horizontalSpace,
                          Flexible(
                            child: Text(data.value,
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle
                                    .secondaryPrimaryBlack12spTextStyle1),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
