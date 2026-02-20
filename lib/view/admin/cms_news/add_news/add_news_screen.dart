import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/view_model/add_news_view_model.dart';
import 'package:zakat_fund/widgets/activity_log_btn.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/html_editor_widget.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AddNewsScreen extends GetView<AddNewsViewModel> {
  const AddNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      body: _buildBody(),
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
              activityLogBtn(model: controller.news,status: controller.news?.requestStatus,id:controller.news?.id,type: "News"),
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
                    items: controller.newsViewModel.categoriesList.value,
                    isRequired: true,
                    selectedValue: controller.selectedCategory.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => controller.onChangeCategory(value!),
                    label: 'category',
                  )),
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
              textFieldLabel(
                  label: 'briefDescriptionInEnglish', isRequired: true),
              4.verticalSpace,
              HtmlEditorWidget(
                controller: controller.shortDescEnglishController,
                initialText: controller.news?.descriptionShortEN,
              ),
              Obx(() => controller.shortDescEnglishEmpty.value
                  ? emptyError('briefDescriptionInEnglish')
                  : SizedBox()),
              16.verticalSpace,
              textFieldLabel(
                  label: 'briefDescriptionInArabic', isRequired: true),
              4.verticalSpace,
              HtmlEditorWidget(
                controller: controller.shortDescArabicController,
                initialText: controller.news?.descriptionShortAR,
              ),
              Obx(() => controller.shortDescEnglishEmpty.value
                  ? emptyError('briefDescriptionInArabic')
                  : SizedBox()),
              16.verticalSpace,
              LabelTextField(
                controller: controller.authorNameInEnglish,
                label: 'authorNameInEnglish',
                isRequired: true,
                checkValidation: true,
                inputFormatters: InputFormatters.englishNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.authorNameInArabic,
                label: 'authorNameInArabic',
                isRequired: true,
                checkValidation: true,
                inputFormatters: InputFormatters.arabicNameFormatter,
              ),
              16.verticalSpace,
              textFieldLabel(
                  label: 'longDescriptionInEnglish', isRequired: true),
              4.verticalSpace,
              HtmlEditorWidget(
                controller: controller.descEnglishController,
                initialText: controller.news?.descriptionEn,
              ),
              Obx(() => controller.shortDescEnglishEmpty.value
                  ? emptyError('longDescriptionInEnglish')
                  : SizedBox()),
              16.verticalSpace,
              textFieldLabel(
                  label: 'longDescriptionInArabic', isRequired: true),
              4.verticalSpace,
              HtmlEditorWidget(
                controller: controller.descArabicController,
                initialText: controller.news?.descriptionAr,
              ),
              Obx(() => controller.shortDescEnglishEmpty.value
                  ? emptyError('longDescriptionInArabic')
                  : SizedBox()),
              16.verticalSpace,
              LabelTextField(
                label: 'theFirstPicture',
                readOnly: true,
                onAddFile: () => controller.addImage(controller.firstPic),
                controller: controller.firstPic,
              ),
              4.verticalSpace,
              pictureInstructWidget(),
              16.verticalSpace,
              LabelTextField(
                label: 'theSecondPicture',
                readOnly: true,
                onAddFile: () => controller.addImage(controller.secondPic),
                controller: controller.secondPic,
              ),
              4.verticalSpace,
              pictureInstructWidget(),
              16.verticalSpace,
              LabelTextField(
                label: 'thumbnail',
                readOnly: true,
                onAddFile: () => controller.addImage(controller.thumbnail),
                controller: controller.thumbnail,
              ),
              4.verticalSpace,
              pictureInstructWidget(),
              20.verticalSpace,
              CustomButton(
                buttonType: ButtonType.submit,
                onPressed: () => controller.saveNews(),
              ),
              10.verticalSpace,
              CustomButton(
                buttonType: ButtonType.preview,
                onPressed: () => controller.saveNews(isPreview: true),
              ),
              10.verticalSpace,
              if (controller.news == null ||
                  controller.news?.requestStatus == 8)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: CustomButton(
                    buttonType: ButtonType.draft,
                    onPressed: () => controller.saveNews(saveAsDraft: true),
                  ),
                ),
              CustomButton(
                buttonType: ButtonType.cancel,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyError(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 4.h),
      child: Text(
        "${label.tr} ${"isRequired".tr}",
        style: TextStyle(
          color: Get.theme.colorScheme.error,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
