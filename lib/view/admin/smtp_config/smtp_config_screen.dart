import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/smtp_config_view_model.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class SmtpConfigScreen extends GetView<SMTPConfigViewModel> {
  const SmtpConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "emailSMTPConfig"),
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(context, controller.keyboardActionsItem),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              LabelTextField(
                controller: controller.hostController,
                label: "host",
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.portController,
                label: "portNumber",
                focusNode: controller.portNode,
                keyboardType: TextInputType.number,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.accountEmailController,
                label: "emailAccount",
                keyboardType: TextInputType.emailAddress,
              ),
              16.verticalSpace,
              Obx(() => LabelTextField(
                label: "password",
                isPassword: true,
                checkValidation: true,
                isArabicDirection: true,
                controller: controller.passwordController,
                obscureText: controller.showPassword.value,
                onSuffixTap: () => controller.updateShowPassword(),
              )),
              16.verticalSpace,
              LabelTextField(
                controller: controller.encKeyController,
                label: "encryptionKey",
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.contactUsEmailController,
                label: "contactUsEmailAccount",
                keyboardType: TextInputType.emailAddress,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.senderController,
                label: "sender",
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.bccSenderController,
                label: "bccSender",
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.vipEmailController,
                label: "vipEmailAccount",
                keyboardType: TextInputType.emailAddress,
              ),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                items: AppConstant.yesNoList,
                isRequired: true,
                selectedValue: controller.selectedEnabled.value,
                hint: "chooseAnOption",
                onChanged: (value) {
                  controller.selectedEnabled.value = value;
                },
                label: 'sslEnabled',
              )),
              16.verticalSpace,
              LabelTextField(
                controller: controller.logoPathController,
                keyboardType: TextInputType.url,
                label: "logoPath",
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.apiPathController,
                label: "webAPIUrl",
                keyboardType: TextInputType.url,
              ),
              16.verticalSpace,
              elevatedButton(text: "save", onPressed: ()=>controller.saveSMTPConfig()),
              16.verticalSpace,
              CustomButton(buttonType: ButtonType.cancel, onPressed: ()=>Get.back(),)
            ],
          ),
        ),
      ),
    );
  }
}
