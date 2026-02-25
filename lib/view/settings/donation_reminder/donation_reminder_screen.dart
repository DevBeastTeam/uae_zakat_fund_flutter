import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/donation_reminders.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/donation_reminder_view_model.dart';
import 'package:zakat_fund/widgets/add_elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class DonationReminderScreen extends GetView<DonationReminderViewModel> {
  const DonationReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "donationReminder"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildAddReninderBtn(),
          16.verticalSpace,
          buildListView(),
        ],
      ),
    );
  }

  Widget _buildAddReninderBtn() {
    return addElevatedButton(
      onPressed: () => Get.toNamed(AppRoutes.addDonationReminderScreen)?.then((val) {
        if (val != null && val) {
          controller.fetchReminders();
        }
      }),
      text: "addReminder",
    );
  }

  Widget buildListView() {
    return Obx(() => ListView.separated(
          itemCount: controller.reminders.length,
          shrinkWrap: true,
          separatorBuilder: (_, int index) => 16.verticalSpace,
          itemBuilder: (_, int index) =>
              _buildReminderCard(controller.reminders[index]),
        ));
  }

  Widget _buildReminderCard(DonationReminder reminder) {
    final List<String> notificationMethods = [
      "email",
      "sms",
      "mobileAppNotifications"
    ];

    final List<int> indices =
    List<int>.from(jsonDecode(reminder.notificationMethods));
    final List<String> localizedMethods =
    indices.map((i) => notificationMethods[i - 1].tr).toList();

    final reminderText = _buildReminderText(reminder, localizedMethods);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.secondaryLightGreyColor),
      ),
      child: Column(
        children: [
          _buildCardHeader(reminder),
          10.verticalSpace,
          reminderText,
        ],
      ),
    );
  }

  Widget _buildCardHeader(DonationReminder reminder) {
    final textDirection = Utils.containsArabic(reminder.reminderName)
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            reminder.reminderName,
            textDirection: textDirection,
            style: AppTextStyle.lightBrown14spTextStyle4,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        16.horizontalSpace,
        _buildIconButton(AppResources.editIcon, () async {
          final result = await Get.toNamed(
            AppRoutes.addDonationReminderScreen,
            arguments: {"donationReminder": reminder},
          );
          if (result == true) controller.fetchReminders();
        }),
        8.horizontalSpace,
        _buildIconButton(AppResources.deleteIcon, () {
          controller.deleteReminder(reminder);
        }),
      ],
    );
  }

  Widget _buildIconButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        width: 16.w,
        height: 16.h,
        color: assetPath == AppResources.editIcon
            ? AppColors.darkerGreyColor
            : null,
      ),
    );
  }

  Widget _buildReminderText(DonationReminder reminder, List<String> methods) {
    final projectName = Utils.isArabic
        ? reminder.projectNameAr.trim()
        : reminder.projectNameEn.trim();

    final dateText = reminder.reminderDateMonthly != 0
        ? controller.monthsList[reminder.reminderDateMonthly - 1]
        : Utils.dateFormat1.format(reminder.reminderDate!);

    return RichText(
      text: TextSpan(
        text: 'remindsToDonate'.tr,
        style: AppTextStyle.primaryDarkGrey14spTextStyle1
            .copyWith(fontFamily: 'Alexandria'),
        children: [
          TextSpan(
            text: " ${reminder.donationAmount.toInt()} ${"currency".tr}",
            style: AppTextStyle.primaryDarkGrey14spTextStyle2
                .copyWith(fontFamily: 'Alexandria'),
          ),
          TextSpan(
            text: ' ${"to".tr} "$projectName" ${"on".tr} $dateText ${"via".tr} ',
            style: AppTextStyle.primaryDarkGrey14spTextStyle1
                .copyWith(fontFamily: 'Alexandria'),
          ),
          TextSpan(
            text: methods.join(', '),
            style: AppTextStyle.primaryDarkGrey14spTextStyle2
                .copyWith(fontFamily: 'Alexandria'),
          ),
        ],
      ),
    );
  }
}
