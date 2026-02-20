import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/service_new_fields.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/add_service_view_model.dart';
import 'package:zakat_fund/widgets/html_editor_widget.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class NewFieldsDrawer extends GetView<AddServiceViewModel> {
  const NewFieldsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Utils.isArabic ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: Utils.isArabic
                  ? BorderSide.none
                  : BorderSide(
                      color: AppColors.btnBackgroundColor, // Border color
                      width: 2.w, // Border width
                    ),
              right: Utils.isArabic
                  ? BorderSide(
                      color: AppColors.btnBackgroundColor, // Border color
                      width: 2.w, // Border width
                    )
                  : BorderSide.none,
            ),
          ),
          width: Get.width - 70.w,
          height: Get.height,
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: KeyboardDismissOnTap(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Utils.isArabic
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              // fixedSize: WidgetStatePropertyAll(Size(Get.width, 40.h)),
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColors.warningBackColor),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)))),
                              elevation: const WidgetStatePropertyAll(0),
                            ),
                            onPressed: () => controller.newFieldsDialog(),
                            label: Text(
                              "newField".tr,
                              style: AppTextStyle.lightBrownColor12spTextStyle1,
                            ),
                            icon: SvgPicture.asset(
                              AppResources.addIcon,
                              color: AppColors.lightBrownColor2,
                            ),
                          ),
                        ),
                        16.verticalSpace,
                        Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 16.h),
                          margin: EdgeInsets.only(bottom: 16.h),
                          decoration: BoxDecoration(
                              color: AppColors.grayColor,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: AppColors.secondaryLightGreyColor,
                                  width: 1.w)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel("faqs"),
                              10.verticalSpace,
                              Obx(() => LabelDropDown(
                                    items: controller.faqs,
                                    selectedValue: controller.selectedFAQ.value,
                                    hint: "chooseAnOption",
                                    showLabel: false,
                                    onChanged: (value) =>
                                        controller.onSelectFAQ(value!),
                                    label: 'faqs',
                                  )),
                              16.verticalSpace,
                              textFieldLabel(label: "addedFAQs"),
                              8.verticalSpace,
                              Obx(() => controller.selectedFAQs.isNotEmpty
                                  ? Column(
                                      children: [
                                        Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .secondaryLightGreyColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                  color: Color(0xffD1D0D1),
                                                  width: 1.w)),
                                          child: Column(
                                            children: List.generate(
                                                controller.selectedFAQs.length,
                                                (index) => Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(Utils
                                                                        .isArabic
                                                                    ? controller
                                                                        .selectedFAQs[
                                                                            index]
                                                                        .questionArabic
                                                                    : controller
                                                                        .selectedFAQs[
                                                                            index]
                                                                        .question)),
                                                            6.horizontalSpace,
                                                            GestureDetector(
                                                              onTap: () => controller
                                                                  .selectedFAQs
                                                                  .remove(controller
                                                                          .selectedFAQs[
                                                                      index]),
                                                              child:
                                                                  Image.asset(
                                                                AppResources
                                                                    .deleteIcon,
                                                                width: 12.w,
                                                                height: 12.h,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (controller
                                                                    .selectedFAQs
                                                                    .length -
                                                                1 !=
                                                            index)
                                                          Divider(
                                                              color: Color(
                                                                  0xffD1D0D1))
                                                      ],
                                                    )),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink())
                            ],
                          ),
                        ),
                        addImage(),
                        addText(),
                        addDescription(),
                        addVideo(),
                        addLink(),
                        addAmount(),
                        addButton(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: Utils.isArabic ? -20 : 0,
                  left: Utils.isArabic ? 0 : -20,
                  child: Align(
                    alignment:
                        Utils.isArabic ? Alignment.topRight : Alignment.topLeft,
                    child: FloatingActionButton(
                      heroTag: "newField",
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: AppColors.btnBackgroundColor,
                      mini: true,
                      shape: const CircleBorder(),
                      onPressed: () => Get.back(),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text buildLabel(String label) => Text(
        label.tr,
        style: AppTextStyle.secondaryBlack12spTextStyle2,
      );

  Widget addImage() {
    return Obx(() => controller.picturesList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.picturesList.length,
                (topIndex) => Container(
                      width: Get.width,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 16.h),
                      decoration: BoxDecoration(
                          color: AppColors.grayColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.secondaryLightGreyColor,
                              width: 1.w)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              buildLabel("addImage"),
                              16.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.picturesList.removeAt(topIndex);
                                  controller.picturesList.refresh();
                                },
                                child: Image.asset(
                                  AppResources.deleteIcon,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          ...List.generate(
                              controller.picturesList[topIndex].length,
                              (index) => Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            LabelTextField(
                                              label: 'image',
                                              readOnly: true,
                                              onAddFile: () => controller
                                                  .pickImage(controller
                                                      .picturesList[topIndex]
                                                          [index]
                                                      .controller1),
                                              controller: controller
                                                  .picturesList[topIndex][index]
                                                  .controller1,
                                            ),
                                            if (controller.picturesList.length -
                                                    1 !=
                                                index)
                                              8.verticalSpace,
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.picturesList[topIndex]
                                              .removeAt(index);
                                          if (controller
                                              .picturesList[topIndex].isEmpty) {
                                            controller.picturesList
                                                .removeAt(topIndex);
                                          }
                                          controller.picturesList.refresh();
                                        },
                                        child: Image.asset(
                                          AppResources.deleteIcon,
                                          width: 12.w,
                                          height: 12.h,
                                        ),
                                      ),
                                    ],
                                  )),
                          16.verticalSpace,
                          Align(
                            alignment: Alignment.center,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.w,
                                      color: AppColors.darkBrownColor),
                                  backgroundColor: AppColors.warningBackColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.r))),
                              onPressed: () {
                                controller.picturesList[topIndex]
                                    .add(ServiceNewFields());
                                controller.picturesList.refresh();
                              },
                              child: Text(
                                "addAnotherImage".tr,
                                maxLines: 1,
                                style:
                                    AppTextStyle.primaryDarkBrown16spTextStyle1,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
          )
        : SizedBox.shrink());
  }

  Widget addText() {
    return Obx(() => controller.textList.isNotEmpty
        ? Column(
            children: List.generate(
                controller.textList.length,
                (index) => Container(
                      width: Get.width,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 16.h),
                      decoration: BoxDecoration(
                          color: AppColors.grayColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.secondaryLightGreyColor,
                              width: 1.w)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              buildLabel("addText"),
                              16.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.textList.removeAt(index);
                                  controller.textList.refresh();
                                },
                                child: Image.asset(
                                  AppResources.deleteIcon,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.textList[index].controller1,
                            label: 'titleInEnglish',
                            inputFormatters:
                                InputFormatters.englishNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.textList[index].controller2,
                            label: 'titleInArabic',
                            inputFormatters:
                                InputFormatters.arabicNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.textList[index].controller3,
                            label: 'textInEnglish',
                            inputFormatters:
                                InputFormatters.englishNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.textList[index].controller4,
                            label: 'textInArabic',
                            inputFormatters:
                                InputFormatters.arabicNameFormatter,
                          ),
                        ],
                      ),
                    )),
          )
        : SizedBox.shrink());
  }

  Widget addDescription() {
    return Obx(() => controller.descList.isNotEmpty
        ? Container(
            width: Get.width,
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
            decoration: BoxDecoration(
                color: AppColors.grayColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: AppColors.secondaryLightGreyColor, width: 1.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    buildLabel("addDescription"),
                    16.horizontalSpace,
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppResources.deleteIcon,
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                ...List.generate(
                    controller.descList.length,
                    (index) => Column(
                          children: [
                            LabelTextField(
                              controller:
                                  controller.descList[index].controller1,
                              label: 'titleInEnglish',
                              inputFormatters:
                                  InputFormatters.englishNameFormatter,
                            ),
                            10.verticalSpace,
                            LabelTextField(
                              controller:
                                  controller.descList[index].controller2,
                              label: 'titleInArabic',
                              inputFormatters:
                                  InputFormatters.arabicNameFormatter,
                            ),
                            10.verticalSpace,
                            textFieldLabel(label: 'descriptionInEnglish'),
                            4.verticalSpace,
                            HtmlEditorWidget(
                              controller:
                                  controller.descList[index].htmlController1,
                              initialText:
                                  controller.descList[index].initialValue1,
                              lessHeight: true,
                              onChangeContent: (val) {
                                controller.descList[index].initialValue1 = val!;
                              },
                            ),
                            10.verticalSpace,
                            textFieldLabel(label: 'descriptionInArabic'),
                            4.verticalSpace,
                            HtmlEditorWidget(
                              controller:
                                  controller.descList[index].htmlController2,
                              lessHeight: true,
                              initialText:
                                  controller.descList[index].initialValue2,
                              onChangeContent: (val) {
                                controller.descList[index].initialValue2 = val!;
                              },
                            ),
                          ],
                        ))
              ],
            ),
          )
        : SizedBox.shrink());
  }

  Widget addVideo() {
    return Obx(() => controller.videoList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.videoList.length,
                (index) => Container(
                      width: Get.width,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 16.h),
                      decoration: BoxDecoration(
                          color: AppColors.grayColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.secondaryLightGreyColor,
                              width: 1.w)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              buildLabel("addVideo"),
                              16.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.videoList.removeAt(index);
                                },
                                child: Image.asset(
                                  AppResources.deleteIcon,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.videoList[index].controller1,
                            label: 'videoUrl',
                            hint: "enterURL",
                          ),
                        ],
                      ),
                    )),
          )
        : SizedBox.shrink());
  }

  Widget addLink() {
    return Obx(() => controller.linkList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.linkList.length,
                (index) => Container(
                      width: Get.width,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 16.h),
                      decoration: BoxDecoration(
                          color: AppColors.grayColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.secondaryLightGreyColor,
                              width: 1.w)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              buildLabel("addLink"),
                              16.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.linkList.removeAt(index);
                                },
                                child: Image.asset(
                                  AppResources.deleteIcon,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.linkList[index].controller1,
                            label: 'titleInEnglish',
                            inputFormatters:
                                InputFormatters.englishNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.linkList[index].controller2,
                            label: 'titleInArabic',
                            inputFormatters:
                                InputFormatters.arabicNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.linkList[index].controller3,
                            label: 'link',
                            hint: "enterLink",
                          ),
                        ],
                      ),
                    )),
          )
        : SizedBox.shrink());
  }

  Widget addAmount() {
    return Obx(() => controller.amountList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.amountList.length,
                (index) => Container(
                      width: Get.width,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 16.h),
                      decoration: BoxDecoration(
                          color: AppColors.grayColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.secondaryLightGreyColor,
                              width: 1.w)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              buildLabel("addAmount"),
                              16.horizontalSpace,
                              GestureDetector(
                                onTap: () {
                                  controller.amountList.removeAt(index);
                                },
                                child: Image.asset(
                                  AppResources.deleteIcon,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller:
                                controller.amountList[index].controller1,
                            label: 'titleInEnglish',
                            inputFormatters:
                                InputFormatters.englishNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller:
                                controller.amountList[index].controller2,
                            label: 'titleInArabic',
                            inputFormatters:
                                InputFormatters.arabicNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller:
                                controller.amountList[index].controller3,
                            label: 'amount',
                            amountOnly: true,
                            inputFormatters: InputFormatters.amountFormatter,
                            hint: "enterTopUpAmount",
                          ),
                        ],
                      ),
                    )),
          )
        : SizedBox.shrink());
  }

  Widget addButton() {
    return Obx(() => controller.buttonList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.buttonList.length,
                (index) => Container(
                      width: Get.width,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 16.h),
                      decoration: BoxDecoration(
                          color: AppColors.grayColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.secondaryLightGreyColor,
                              width: 1.w)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              buildLabel("addButton"),
                              16.horizontalSpace,
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  AppResources.deleteIcon,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.buttonList[index].controller1,
                            label: 'titleInEnglish',
                            inputFormatters:
                                InputFormatters.englishNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.buttonList[index].controller2,
                            label: 'titleInArabic',
                            inputFormatters:
                                InputFormatters.arabicNameFormatter,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.buttonList[index].controller3,
                            label: 'link',
                            hint: "enterLink",
                          ),
                        ],
                      ),
                    )),
          )
        : SizedBox.shrink());
  }
}
