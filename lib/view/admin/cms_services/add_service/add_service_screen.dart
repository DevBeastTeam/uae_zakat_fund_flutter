import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/service_new_fields.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/admin/cms_services/add_service/new_fields_drawer.dart';
import 'package:zakat_fund/view_model/add_service_view_model.dart';
import 'package:zakat_fund/widgets/activity_log_btn.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/html_editor_widget.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AddServiceScreen extends GetView<AddServiceViewModel> {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "serviceDetails"),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: _buildFAB(),
      body: _buildBody(),
    );
  }

  Padding _buildFAB() {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: FloatingActionButton(
        heroTag: "newField",
        onPressed: () {
          Navigator.of(Get.context!,).push(PageRouteBuilder(
              opaque: false,
              fullscreenDialog: true,
              pageBuilder: (_, __, ___) => NewFieldsDrawer(),
            ),
          ).then((_) {
            controller.clearDrawerData();
          });
        },
        elevation: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: AppColors.btnBackgroundColor,
        mini: true,
        shape: const CircleBorder(),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
      ),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
        child: SingleChildScrollView(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 50,left: 50),
              child: activityLogBtn(model: controller.services,status: controller.services?.requestStatus,id:controller.services?.id,type: "Servicees"),
            ),
            LabelTextField(
              controller: controller.titleInEnglish,
              label: 'titleInEnglish',
              isRequired: true,
              focusNode: controller.titleInEnglishNode,
              checkValidation: true,
              inputFormatters: InputFormatters.englishNameFormatter,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.titleInArabic,
              label: 'titleInArabic',
              isRequired: true,
              focusNode: controller.titleInArabicNode,
              checkValidation: true,
              inputFormatters: InputFormatters.arabicNameFormatter,
            ),
            16.verticalSpace,
            Obx(() => LabelDropDown2(
                  items: controller.serviceViewModel.categoriesList.value,
                  isRequired: true,
                  selectedValue: controller.selectedCategory.value,
                  hint: "chooseAnOption",
                  onChanged: (value) {
                    controller.selectedCategory.value = value;
                  },
                  label: 'category',
                )),
            16.verticalSpace,
            textFieldLabel(label: 'descriptionInEnglish'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.descEnglishController,
              initialText: controller.services?.descriptionEn,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'descriptionInArabic'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.descArabicController,
              initialText: controller.services?.descriptionAr,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.publishDateTime,
              label: 'publishScheduleTime',
              isRequired: true,
              isDate: true,
              checkValidation: true,
              readOnly: true,
              onTap: () => controller.dateTimePicker(),
            ),
            16.verticalSpace,
            textFieldLabel(label: 'proceduresInEnglish'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.procedureEnglishController,
              initialText: controller.services?.proceduresEn,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'proceduresInArabic'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.procedureArabicController,
              initialText: controller.services?.procedureAr,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'termsOfUseInEnglish'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.termsOfUseEnglishController,
              initialText: controller.services?.termsOfUseEn,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'termsOfUseInArabic'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.termsOfUseArabicController,
              initialText: controller.services?.termsOfUseAr,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.fees,
              label: 'serviceFees',
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.durationInEnglish,
              label: 'durationInEnglish',
              inputFormatters: InputFormatters.englishAddressFormatter,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.durationInArabic,
              label: 'durationInArabic',
              inputFormatters: InputFormatters.arabicAddressFormatter,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'serviceChannelsInEnglish'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.serviceChannelsEnglishController,
              initialText: controller.services?.serviceChannelsEn,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'serviceChannelsInArabic'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.serviceChannelsArabicController,
              initialText: controller.services?.serviceChannelsAr,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'targetAudienceInEnglish'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.targetAudienceEnglishController,
              initialText: controller.services?.targetAudienceEn,
            ),
            16.verticalSpace,
            textFieldLabel(label: 'targetAudienceInArabic'),
            4.verticalSpace,
            HtmlEditorWidget(
              controller: controller.targetAudienceArabicController,
              initialText: controller.services?.targetAudienceAr,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.supportInEnglish,
              label: 'supportInEnglish',
              inputFormatters: InputFormatters.englishAddressFormatter,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.supportInArabic,
              label: 'supportInArabic',
              inputFormatters: InputFormatters.arabicAddressFormatter,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.startService,
              label: 'startService',
              hint: "enterLink",
            ),
            13.verticalSpace,
            faqListView(),
            picturesListView(),
            textListView(),
            descriptionListView(),
            videoListView(),
            linkListView(),
            amountListView(),
            buttonListView(),
            16.verticalSpace,
            CustomButton(
              buttonType: ButtonType.submit,
              onPressed: () => controller.addService(),
            ),
            10.verticalSpace,
            CustomButton(
              buttonType: ButtonType.preview,
              onPressed: () => controller.addService(preview: true),
            ),
            10.verticalSpace,
            if (controller.services == null ||
                controller.services?.requestStatus == 8)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: CustomButton(
                  buttonType: ButtonType.draft,
                  onPressed: () => controller.addService(saveAsDraft: true),
                ),
              ),
            CustomButton(
              buttonType: ButtonType.cancel,
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  Widget picturesListView() {
    return Obx(() => controller.picturesList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelHeader("image"),
              8.verticalSpace,
              ...List.generate(
                  controller.picturesList.length,
                  (topIndex) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100.h,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                ServiceNewFields field =
                                    controller.picturesList[topIndex][index];
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: CachedImage(
                                      image: field.controller1.text,
                                      width: 100.w,
                                      height: 100.h,
                                    ));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      10.horizontalSpace,
                              itemCount:
                                  controller.picturesList[topIndex].length,
                            ),
                          ),
                          16.verticalSpace,
                        ],
                      )),
            ],
          )
        : SizedBox.shrink());
  }

  Text buildLabelHeader(String label) {
    return Text(
      label.tr,
      style: AppTextStyle.secondaryPrimaryBlack20spTextStyle3,
    );
  }

  Widget textListView() {
    return Obx(() => controller.textList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelHeader("text"),
              8.verticalSpace,
              ...List.generate(
                  controller.textList.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelTextField(
                            controller: controller.textList[index].controller3,
                            label: controller.textList[index].controller1.text,
                            showLabel: controller
                                .textList[index].controller1.text.isNotEmpty,
                            readOnly: true,
                            maxLines: 2,
                          ),
                          10.verticalSpace,
                          LabelTextField(
                            controller: controller.textList[index].controller4,
                            label: controller.textList[index].controller2.text,
                            showLabel: controller
                                .textList[index].controller2.text.isNotEmpty,
                            maxLines: 2,
                            readOnly: true,
                          ),
                          10.verticalSpace,
                        ],
                      ))
            ],
          )
        : SizedBox.shrink());
  }

  Widget descriptionListView() {
    return Obx(() => controller.descList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.descList.length,
                (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabelHeader("description"),
                        8.verticalSpace,
                        textFieldLabel(
                            label: controller.descList[index].controller1.text),
                        4.verticalSpace,
                        HtmlEditorWidget(
                          controller:
                              controller.descList[index].htmlController1,
                          initialText: controller.descList[index].initialValue1,
                        ),
                        10.verticalSpace,
                        textFieldLabel(
                            label: controller.descList[index].controller2.text),
                        4.verticalSpace,
                        HtmlEditorWidget(
                          controller:
                              controller.descList[index].htmlController2,
                          initialText: controller.descList[index].initialValue2,
                        ),
                        10.verticalSpace,
                      ],
                    )),
          )
        : SizedBox.shrink());
  }

  Widget videoListView() {
    return Obx(() => controller.videoList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelHeader("video"),
              8.verticalSpace,
              ...List.generate(
                  controller.videoList.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelTextField(
                            readOnly: true,
                            onTap: () {
                              Utils.viewLink(
                                  controller.videoList[index].controller1.text);
                            },
                            controller: controller.videoList[index].controller1,
                            label: "videoUrl",
                          ),
                          10.verticalSpace,
                        ],
                      ))
            ],
          )
        : SizedBox.shrink());
  }

  Widget linkListView() {
    return Obx(() => controller.linkList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelHeader("link"),
              8.verticalSpace,
              ...List.generate(
                  controller.linkList.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelTextField(
                            readOnly: true,
                            onTap: () {
                              Utils.viewLink(
                                  controller.linkList[index].controller3.text);
                            },
                            controller: controller.linkList[index].controller3,
                            label: controller.linkList[index].controller1.text,
                            showLabel: controller
                                .linkList[index].controller1.text.isNotEmpty,
                          ),
                          10.verticalSpace,
                        ],
                      ))
            ],
          )
        : SizedBox.shrink());
  }

  Widget amountListView() {
    return Obx(() => controller.amountList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelHeader("amount"),
              8.verticalSpace,
              ...List.generate(
                  controller.amountList.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelTextField(
                            readOnly: true,
                            amountOnly: true,
                            controller:
                                controller.amountList[index].controller3,
                            label:
                                controller.amountList[index].controller1.text,
                            showLabel: controller
                                .amountList[index].controller1.text.isNotEmpty,
                          ),
                          10.verticalSpace,
                        ],
                      )),
            ],
          )
        : SizedBox.shrink());
  }

  Widget buttonListView() {
    return Obx(() => controller.buttonList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelHeader("button"),
              8.verticalSpace,
              ...List.generate(
                  controller.buttonList.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          elevatedButton(
                              text:
                                  controller.buttonList[index].controller1.text,
                              onPressed: () => Utils.viewLink(controller
                                  .buttonList[index].controller3.text)),
                          10.verticalSpace,
                        ],
                      ))
            ],
          )
        : SizedBox.shrink());
  }

  Widget faqListView() {
    return Obx(() => controller.selectedFAQs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelHeader("frequentlyAskedQuestions"),
              13.verticalSpace,
              ExpansionPanelList(
                elevation: 0,
                dividerColor: AppColors.lightGrey,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (int index, bool isExpanded) {
                  if (controller.preIndex != -1) {
                    controller.selectedFAQs[controller.preIndex].isExpanded =
                        false;
                  }
                  controller.preIndex = index;
                  controller.selectedFAQs[index].isExpanded = isExpanded;
                  controller.selectedFAQs.refresh();
                },
                children:
                    controller.selectedFAQs.map<ExpansionPanel>((FaQs faq) {
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    backgroundColor: Colors.white,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          Utils.isArabic ? faq.questionArabic : faq.question,
                          style: AppTextStyle.primaryBlack16spTextStyle,
                        ),
                      );
                    },
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.isArabic ? faq.answerArabic : faq.answer,
                          style:
                              AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
                        ),
                        const Divider(
                          color: AppColors.lightGrey,
                        ),
                      ],
                    ),
                    isExpanded: faq.isExpanded,
                  );
                }).toList(),
              ),
              10.verticalSpace,
            ],
          )
        : SizedBox.shrink());
  }

}
