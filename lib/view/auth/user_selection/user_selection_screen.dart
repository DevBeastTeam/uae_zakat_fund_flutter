import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/user_selection_type.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/user_selection_view_model.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';

class UserSelectionScreen extends GetView<UserSelectionViewModel> {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeading(),
            20.verticalSpace,
            _buildUserTypeListView(),
            20.verticalSpace,
            _buildNextBtn(),
            16.verticalSpace,
            _buildPreviousBtn(),
          ],
        ),
      ),
    );
  }

  Obx _buildPreviousBtn() {
    return Obx(() => elevatedIconButton(
          text: controller.donorSelected.value ? "previous" : "back",
          next: false,
          backgroundColor: AppColors.lightGreyColor,
          onPressed: () => controller.onPreviousPressed(),
        ));
  }

  Widget _buildNextBtn() {
    return elevatedIconButton(
        text: "next", onPressed: () => controller.onNextPressed());
  }

  Obx _buildUserTypeListView() {
    return Obx(() => buildRoleListView(
        controller.donorSelected.value
            ? controller.donorSubTypes
            : controller.userTypes,
        controller.donorSelected.value
            ? controller.selectedSubType.value
            : controller.selectedUserType.value));
  }

  Align _buildHeading() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "register".tr,
        style: AppTextStyle.secondaryDarkBrown36spTextStyle,
      ),
    );
  }

  ListView buildRoleListView(
      List<UserSelectionType> userType, int selectedIndex) {
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemCount: userType.length,
      separatorBuilder: (_, int index) => 16.verticalSpace,
      itemBuilder: (_, int index) {
        UserSelectionType type = userType[index];
        return _buildCheckboxListTile(selectedIndex, index, type);
      },
    );
  }

  CheckboxListTile _buildCheckboxListTile(
      int selectedIndex, int index, UserSelectionType type) {
    return CheckboxListTile(
      value: selectedIndex == index,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: AppColors.darkBrownColor, width: 2.w)),
      selectedTileColor: AppColors.chipBackgroundColor,
      selected: selectedIndex == index,
      secondary: Image.asset(
        type.icon,
        width: 64.w,
        height: 64.h,
      ),
      title: Text(type.title.tr, style: AppTextStyle.darkBrown20spTextStyle1),
      subtitle: Text(
        controller.userTypes[index].subTitle.tr,
        style: AppTextStyle.darkBrown12spTextStyle1,
      ),
      onChanged: (_) => controller.onChangeUserType(index),
      activeColor: AppColors.darkBrownColor,
      side: const BorderSide(color: AppColors.darkBrownColor),
      checkboxShape: const CircleBorder(),
    );
  }
}
