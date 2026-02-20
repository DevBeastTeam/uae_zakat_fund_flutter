import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

guestRemindMeDialog() {
  final viewModel = Get.find<HomeViewModel>();
  Get.dialog(
    Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Utils.isArabic ? 8.w : 16.w,
                    right: Utils.isArabic ? 16.w : 8.w,top: 10.h),
                child: buildBottomSheetHeader(text: "remindMe"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: viewModel.formKey,
                  child: KeyboardActions(
                    autoScroll: false,
                    config: Utils.buildConfig(Get.context!, [
                      KeyboardActionsItem(displayArrows: false, focusNode: viewModel.phoneFocusNode),
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTextField(
                          controller: viewModel.emailController,
                          label: "email",
                          hint: "enterEmail",
                          isRequired: true,
                          checkValidation: true,
                          validator: (value)=>Validator.validateEmailId(value: value!),
                        ),
                        16.verticalSpace,
                        LabelTextField(
                          controller: viewModel.phoneController,
                          label: "phoneNumber",
                          focusNode: viewModel.phoneFocusNode,
                          keyboardType: TextInputType.number,
                          validator: (value)=>Validator.validatePhoneNumber(value!),
                          hint: "+971xxxxxxxxx",
                          isArabicDirection: true,
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: "+971#########",
                              initialText: "+971",
                              filter: {"#": RegExp(r'[0-9]')},
                            )
                          ],
                          checkValidation: true,
                          isRequired: true,
                        ),
                        16.verticalSpace,
                        Obx(() => LabelDropDown(
                          items: AppConstant.notificationFrequencies,
                          selectedValue:
                          viewModel.selectedNotificationFrequency.value,
                          onChanged: (value) {
                            viewModel.selectedNotificationFrequency.value = value;
                          },
                          isRequired: true,
                          label: 'notificationFrequency',
                          hint: "chooseAnOption",
                        )),
                        16.verticalSpace,
                        textFieldLabel(
                            label: "categoriesOfInterest", isRequired: true),
                        4.verticalSpace,
                        Obx(() => Container(
                          height: 50,
                          alignment: Utils.isArabic
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                              color: AppColors.lightGreyColor,
                              borderRadius: BorderRadius.circular(100.r),
                              border: Border.all(
                                  width: 1.w,
                                  color:
                                  AppColors.secondaryLightGreyColor)),
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: viewModel.selectedCategories.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                            8.horizontalSpace,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return RawChip(
                                onDeleted: () => viewModel.removeCategory(index),
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                label: Text(Utils.isArabic
                                    ? viewModel.selectedCategories[index]
                                    .nameAr
                                    .toString()
                                    .tr
                                    : viewModel.selectedCategories[index]
                                    .name
                                    .toString()
                                    .tr),
                                labelStyle:
                                AppTextStyle.darkBrown14spTextStyle1,
                                deleteIconColor: AppColors.darkBrownColor,
                                side: BorderSide(
                                    color: AppColors.darkBrownColor,
                                    width: 1.w),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(50.r)),
                              );
                            },
                          ),
                        )),
                        Obx(() =>
                        viewModel.isClicked.value && viewModel.selectedCategories.isEmpty
                            ? Padding(
                          padding: EdgeInsets.only(
                              left: 16.w, right: 16.w, top: 8.h),
                          child: Text(
                            "${"categoriesOfInterest".tr} ${"isRequired".tr}",
                            style: TextStyle(
                                color: Get.theme.colorScheme.error,
                                fontSize: 12),
                          ),
                        )
                            : const SizedBox.shrink()),
                        _categoryWrap(viewModel),
                        Obx(() => CheckboxListTile(
                          value: viewModel.isAgree.value,
                          contentPadding: EdgeInsets.zero,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                          onChanged: (val) => viewModel.isAgree.value = val!,
                          controlAffinity:
                          ListTileControlAffinity.leading,
                          title: Text(
                            "agreeToReceiveNotifications".tr,
                            style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                          ),
                        )),
                        16.verticalSpace,
                        elevatedButton(text: "save", onPressed: () => viewModel.addReminder()),
                        16.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _categoryWrap(viewModel) {
  return Obx(() => viewModel.allCategoriesList.isNotEmpty
      ? SizedBox(
    height: 50.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: viewModel.allCategoriesList.length,
      separatorBuilder: (_, int index) => 10.horizontalSpace,
      itemBuilder: (_, int index) {
        LookupData cat = viewModel.allCategoriesList[index];
        return RawChip(
          onDeleted: () => viewModel.addCategory(index),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(Utils.isArabic ? cat.nameAr : cat.name),
          labelStyle: AppTextStyle.white14spTextStyle1,
          deleteIcon: const Icon(CupertinoIcons.add_circled_solid),
          deleteIconColor: Colors.white,
          side: BorderSide(color: AppColors.darkBrownColor, width: 1.w),
          backgroundColor: themeViewModel.color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r)),
        );
      },
    ),
  )
      : SizedBox.shrink());
}