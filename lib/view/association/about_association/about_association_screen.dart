import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/about_association_view_model.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';

class AboutAssociationScreen extends GetView<AboutAssociationViewModel> {
  const AboutAssociationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "aboutTheAssociation"),
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
        child: KeyboardActions(
      config: Utils.buildConfig(context, controller.keyboardActionsItem),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTextField(
                controller: controller.titleInEnglish,
                label: 'titleInEnglish',
                isRequired: true,
                checkValidation: true,
                inputFormatters: InputFormatters.englishNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.titleInArabic,
                label: 'titleInArabic',
                isRequired: true,
                checkValidation: true,
                inputFormatters: InputFormatters.arabicNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.descInEnglish,
                label: 'descriptionInEnglish',
                isRequired: true,
                focusNode: controller.descInEnglishNode,
                checkValidation: true,
                maxLines: 4,
                inputFormatters: InputFormatters.englishNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.descInArabic,
                label: 'descriptionInArabic',
                isRequired: true,
                focusNode: controller.descInArabicNode,
                checkValidation: true,
                maxLines: 4,
                inputFormatters: InputFormatters.arabicNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.beneficiaries,
                label: 'beneficiaries',
                checkValidation: true,
                focusNode: controller.beneficiariesNode,
                keyboardType: TextInputType.number,
                isRequired: true,
                inputFormatters: InputFormatters.amountFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.amountRaised,
                label: 'amountRaised',
                amountOnly: true,
                focusNode: controller.amountRaisedNode,
                checkValidation: true,
                keyboardType: TextInputType.number,
                isRequired: true,
                inputFormatters: InputFormatters.amountFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.projectCompleted,
                label: 'projectCompleted',
                checkValidation: true,
                focusNode: controller.projectCompletedNode,
                keyboardType: TextInputType.number,
                isRequired: true,
                inputFormatters: InputFormatters.amountFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                label: 'firstImage',
                checkValidation: true,
                isRequired: true,
                readOnly: true,
                onAddFile: () => controller.addImage(controller.firstImage),
                controller: controller.firstImage,
              ),
              4.verticalSpace,
              fileInstructWidget(),
              16.verticalSpace,
              LabelTextField(
                label: 'secondImage',
                isRequired: true,
                readOnly: true,
                checkValidation: true,
                onAddFile: () => controller.addImage(controller.secondImage),
                controller: controller.secondImage,
              ),
              4.verticalSpace,
              fileInstructWidget(),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: CustomButton(
                  buttonType: ButtonType.submit,
                  onPressed: () => controller.submitForReview(),
                ),
              ),
              Obx(() => controller.showDraft.value
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CustomButton(
                        buttonType: ButtonType.draft,
                        onPressed: () => controller.submitForReview(saveAdDraft: true),
                      ),
                    )
                  : SizedBox.shrink()),
              CustomButton(
                buttonType: ButtonType.cancel,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
