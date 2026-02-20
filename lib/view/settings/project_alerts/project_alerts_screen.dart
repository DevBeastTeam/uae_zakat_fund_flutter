import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/project_alerts_view_model.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ProjectAlertsScreen extends GetView<ProjectAlertsViewModel> {
  const ProjectAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "newProjectAlerts"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationMethods(),
            16.verticalSpace,
            _buildPreferredCategories(),
          ],
        ),
      ),
    );
  }

  Column _buildPreferredCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "preferredCategories".tr,
            style: AppTextStyle.secondaryBlack18spTextStyle3,
          ),
        ),
        16.verticalSpace,
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: textFieldLabel(
                label: "categoriesOfInterest", isRequired: true)),
        4.verticalSpace,
        Obx(() => buildContainer(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedCategories.length,
                separatorBuilder: (BuildContext context, int index) =>
                    8.horizontalSpace,
                itemBuilder: (BuildContext context, int index) {
                  String name = Utils.isArabic
                      ? controller.selectedCategories[index].nameAr
                      : controller.selectedCategories[index].name;
                  return buildCategoryChip(
                      value: name,
                      onDeleted: () => controller.removeCategory(index));
                },
              ),
            )),
        Obx(() => controller.isCategoryClicked.value &&
                controller.selectedCategories.isEmpty
            ? buildErrorMessage("categoriesOfInterest")
            : const SizedBox.shrink()),
        _categoryWrap(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Obx(() => Column(
                    children: List.generate(
                        controller.notificationFrequencies.length,
                        (index) => Column(
                              children: [
                                16.verticalSpace,
                                LabelDropDown(
                                  items: AppConstant.notificationFrequencies,
                                  selectedValue:
                                      controller.notificationFrequencies[index],
                                  onChanged: (value) {
                                    controller.notificationFrequencies[index] =
                                        value!;
                                  },
                                  isRequired: true,
                                  label: Utils.isArabic
                                      ? controller
                                          .selectedCategories[index].nameAr
                                      : controller
                                          .selectedCategories[index].name,
                                  hint: "chooseAnOption",
                                ),
                              ],
                            )),
                  )),
              8.verticalSpace,
              Obx(() => CheckboxListTile(
                    value: controller.isAgree.value,
                    contentPadding: EdgeInsets.zero,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r)),
                    onChanged: (val) {
                      controller.isAgree.value = val!;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "agreeToReceiveNotifications".tr,
                      style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                    ),
                  )),
              16.verticalSpace,
              elevatedButton(
                  text: "save", onPressed: () => controller.saveReminder()),
              16.verticalSpace,
              CustomButton(
                  buttonType: ButtonType.cancel, onPressed: () => Get.back()),
            ],
          ),
        )
      ],
    );
  }

  Column _buildNotificationMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: textFieldLabel(label: "notificationMethods", isRequired: true),
        ),
        4.verticalSpace,
        Obx(() => buildContainer(
                child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.selectedMethods.length,
              separatorBuilder: (BuildContext context, int index) =>
                  8.horizontalSpace,
              itemBuilder: (BuildContext context, int index) {
                return buildCategoryChip(
                    value: controller.selectedMethods[index],
                    onDeleted: () =>
                        controller.removeNotificationMethod(index));
              },
            ))),
        Obx(() => controller.isMethodClicked.value &&
                controller.selectedMethods.isEmpty
            ? buildErrorMessage("notificationMethods")
            : const SizedBox.shrink()),
        _notificationMethodsWrap(),
      ],
    );
  }

  Container buildContainer({required Widget child}) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Utils.isArabic ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: AppColors.lightGreyColor,
          borderRadius: BorderRadius.circular(100.r),
          border:
              Border.all(width: 1.w, color: AppColors.secondaryLightGreyColor)),
      child: child,
    );
  }

  RawChip buildCategoryChip(
      {required String value, required Function()? onDeleted}) {
    return RawChip(
      onDeleted: onDeleted,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(value.tr),
      labelStyle: AppTextStyle.darkBrown14spTextStyle1,
      deleteIconColor: AppColors.darkBrownColor,
      side: BorderSide(color: AppColors.darkBrownColor, width: 1.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
    );
  }

  Padding buildErrorMessage(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
      child: Text(
        "${label.tr} ${"isRequired".tr}",
        style: TextStyle(color: Get.theme.colorScheme.error, fontSize: 12),
      ),
    );
  }

  Widget _categoryWrap() {
    return Obx(() => controller.allCategoriesList.isNotEmpty
        ? SizedBox(
            height: 50.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.allCategoriesList.length,
              separatorBuilder: (_, int index) => 10.horizontalSpace,
              itemBuilder: (_, int index) {
                LookupData cat = controller.allCategoriesList[index];
                return rawChip(
                  value: Utils.isArabic ? cat.nameAr : cat.name,
                  onDeleted: () => controller.addCategory(index),
                );
              },
            ),
          )
        : SizedBox.shrink());
  }

  RawChip rawChip({required String value, required Function()? onDeleted}) {
    return RawChip(
      onDeleted: onDeleted,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(value.tr),
      labelStyle: AppTextStyle.white14spTextStyle1,
      deleteIcon: const Icon(CupertinoIcons.add_circled_solid),
      deleteIconColor: Colors.white,
      side: BorderSide(color: AppColors.darkBrownColor, width: 1.w),
      backgroundColor: themeViewModel.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
    );
  }

  Widget _notificationMethodsWrap() {
    return Obx(() => controller.notificationMethods.isNotEmpty
        ? SizedBox(
            height: 50.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.notificationMethods.length,
              separatorBuilder: (_, int index) => 10.horizontalSpace,
              itemBuilder: (_, int index) {
                return rawChip(
                  value: controller.notificationMethods[index].tr,
                  onDeleted: () => controller.addNotificationMethod(index),
                );
              },
            ),
          )
        : SizedBox.shrink());
  }
}
