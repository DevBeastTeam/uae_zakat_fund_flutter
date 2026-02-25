import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/notification_view_model.dart';
import 'package:zakat_fund/widgets/notification_details_dialog.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class NotificationScreen extends GetView<NotificationViewModel> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.verticalSpace,
          _buildTopRow(context),
          16.verticalSpace,
          _buildNotificationList()
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.appBarColor,
      title: Text(
        "notificationsSettings".tr,
        style: AppTextStyle.darkBlack18spTextStyle,
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        tabBarWidget(
          controller.tabController,
          ["all", "read", "unread"],
          0,
          newTab: true,
        ),
        _buildOptionsMenu()
      ],
    );
  }

  Widget _buildOptionsMenu() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      onSelected: (String item) async {
        if (item == "mark") {
          await controller.readNotification(null);
        } else {
          controller.deleteAllNotification();
        }
      },
      child: const Icon(Icons.more_horiz, color: AppColors.darkerGreyColor),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem("mark", AppResources.tickMarkIcon, 'markAsRead'.tr,
            AppTextStyle.secondaryPrimaryBlack14spTextStyle),
        _buildMenuItem("delete", AppResources.removeIcon, 'deleteAll1'.tr,
            AppTextStyle.red14spTextStyle1),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, String icon, String text, TextStyle style) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 16.w, height: 16.h),
          10.horizontalSpace,
          Text(text, style: style),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return Expanded(
      child: Obx(() => GroupedListView(
        padding: EdgeInsets.only(bottom: 16.h),
        elements: controller.notifications.value,
        groupBy: (e) => e.date.toString(),
        groupComparator: (a, b) => b.compareTo(a),
        itemComparator: (a, b) => a.date.compareTo(b.date),
        order: GroupedListOrder.ASC,
        groupSeparatorBuilder: _buildGroupSeparator,
        itemBuilder: (context, item) => _buildNotificationTile(item),
      )),
    );
  }

  Widget _buildGroupSeparator(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    final label = date != null ? Utils.getDateAgo(date) : '';
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment:
        Utils.isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 13.h, top: 18.h),
            child: Text(label, style: AppTextStyle.black13spTextStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Notifications item) {
    return Column(
      children: [
        const Divider(color: AppColors.lightGrey1, height: 0),
        ListTile(
          onTap: () async {
            if (!item.isMark) await controller.readNotification(item.id);
            notificationDetailsDialog(item);
          },
          contentPadding: EdgeInsets.zero,
          selected: !item.isMark,
          selectedTileColor:
          !item.isMark ? AppColors.appBarColor : Colors.white,
          visualDensity: VisualDensity.compact,
          leading: _buildLeadingIcons(item),
          title: Text(
            Utils.isArabic ? item.titleAr : item.titleEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.secondaryPrimaryBlack13spTextStyle,
          ),
          subtitle: Text(
            Utils.timeAgo(item.createdDate),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.secondaryPrimaryBlack13spTextStyle1,
          ),
        ),
        const Divider(color: AppColors.lightGrey1, height: 0),
      ],
    );
  }

  Widget _buildLeadingIcons(Notifications item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        10.horizontalSpace,
        if (!item.isMark)
          CircleAvatar(
            radius: 3.r,
            backgroundColor: AppColors.secondaryBtnBackgroundColor,
          ),
        if (!item.isMark) 8.horizontalSpace,
        CircleAvatar(
          backgroundColor: AppColors.circleBgColor,
          child: SvgPicture.asset(
            item.iconName == "3"
                ? AppResources.warningIcon1
                : AppResources.notificationIcon,
            color: AppColors.darkBrownColor,
            width: 16.w,
            height: 16.h,
          ),
        )
      ],
    );
  }
}

