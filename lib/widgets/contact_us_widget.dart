import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/contact_us_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ContactUsWidget extends GetView<ContactUsViewModel> {
  final Project? association;

  const ContactUsWidget(this.association, {super.key});

  @override
  Widget build(BuildContext context) {
    _initializeContactData();
    return _buildBody(context);
  }

  KeyboardActions _buildBody(BuildContext context) {
    return KeyboardActions(
      config: Utils.buildConfig(context, controller.keyboardActionsItem),
      autoScroll: false,
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildContactInfo(
                label: "email", value: controller.email.value)),
            16.verticalSpace,
            Obx(() => _buildContactInfo(
                label: "phoneNumber", value: controller.phoneNumber.value)),
            16.verticalSpace,
            Obx(() => _buildContactInfo(
                label: "address", value: controller.address.value)),
            if (association == null) ...[8.verticalSpace, _buildDirectionBtn()],
            16.verticalSpace,
            _buildEmailField(),
            16.verticalSpace,
            _buildNameField(),
            16.verticalSpace,
            _buildMessageField(),
            20.verticalSpace,
            _buildSendButton(),
            16.verticalSpace,
            if (association == null) _buildSocialMediaRow(),
          ],
        ),
      ),
    );
  }

  void _initializeContactData() {
    if (association == null) {
      controller.fetchContactUs();
    } else {
      controller.setContactInfoFromAssociation(association!);
    }
  }

  Widget _buildEmailField() => LabelTextField(
        isBackWhite: true,
        controller: controller.emailController,
        label: 'email',
        keyboardType: TextInputType.emailAddress,
        isArabicDirection: true,
        readOnly: controller.emailController.text.isNotEmpty,
        hint: 'you@email.com',
        validator: (value) => Validator.validateEmailId(value: value!),
        checkValidation: true,
        inputFormatters: InputFormatters.denySpaces,
      );

  Widget _buildNameField() => LabelTextField(
        isBackWhite: true,
        isBlack: true,
        controller: controller.nameController,
        readOnly: controller.nameController.text.isNotEmpty,
        label: 'nameOptional',
        hint: 'name',
      );

  Widget _buildMessageField() => LabelTextField(
        isBackWhite: true,
        isBlack: true,
        maxLines: 5,
        checkValidation: true,
        focusNode: controller.messageNode,
        controller: controller.messageController,
        label: 'theMessage',
      );

  Widget _buildSendButton() => elevatedButton(
        text: "send",
        onPressed: () => controller.sendContactUs(association),
      );

  Widget _buildContactInfo({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr,
          style: AppTextStyle.darkGreyOne16spTextStyle1,
        ),
        2.verticalSpace,
        Text(
          value.tr,
          textDirection: label == "address" && Utils.isArabic
              ? TextDirection.rtl
              : TextDirection.ltr,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle2,
        ),
      ],
    );
  }

  Widget _buildDirectionBtn() {
    return ElevatedButton.icon(
      onPressed: () async => _openMap(),
      icon: Transform.flip(
        flipX: Utils.isArabic,
        child: Image.asset(
          AppResources.arrowRight,
          color: AppColors.darkBrownColor,
          width: 6.w,
          height: 11.h,
        ),
      ),
      iconAlignment: IconAlignment.end,
      label: Text(
        "seeDirection".tr,
        style: AppTextStyle.darkBrown12spTextStyle,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.chipBackgroundColor,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
    );
  }

  Future<void> _openMap() async {
    Utils.openUrl(controller.addressApiUrl);
  }

  Widget _buildSocialMediaRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldLabel(label: "socialMedia"),
        4.verticalSpace,
        Obx(() {
          final icons = <Widget>[
            if (controller.youtube.isNotEmpty)
              _socialIcon(
                  AppResources.youtubeFillIcon, controller.youtube.value),
            if (controller.twitter.isNotEmpty)
              _socialIcon(
                  AppResources.twitterFillIcon, controller.twitter.value),
            if (controller.instagram.isNotEmpty)
              _socialIcon(
                  AppResources.instFillIcon, controller.instagram.value),
            if (controller.facebook.isNotEmpty)
              _socialIcon(AppResources.fbFillIcon, controller.facebook.value),
          ].expand((icon) => [icon, 8.horizontalSpace]).toList();

          if (icons.isNotEmpty) icons.removeLast(); // remove last spacer

          return Row(children: icons);
        }),
      ],
    );
  }

  Widget _socialIcon(String icon, String url) => buildIconButton(
        icon: icon,
        onPressed: () => Utils.openUrl(url),
      );
}
