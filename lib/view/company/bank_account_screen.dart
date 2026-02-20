import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class BankAccountScreen extends StatelessWidget {
  final dynamic controller;

  const BankAccountScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.bankFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() => LabelDropDown2(
                items: controller.banksList.value,
                showSearch: true,
                selectedValue: controller.selectedBank.value,
                onChanged: (value) {
                  controller.selectedBank.value = value;
                  String swiftCode = value!.code;
                  controller.swiftCodeController.text = swiftCode;
                },
                isRequired: true,
                label: 'bankName',
                hint: 'chooseAnOption',
              )),
          16.verticalSpace,
          LabelTextField(
            controller: controller.swiftCodeController,
            isRequired: true,
            checkValidation: true,
            readOnly: true,
            label: 'swiftCode',
          ),
          16.verticalSpace,
          LabelTextField(
            controller: controller.ibanNumberController,
            isRequired: true,
            checkValidation: true,
            focusNode: controller.ibanNode,
            label: 'ibanNumber',
            keyboardType: TextInputType.text,
            inputFormatters: InputFormatters.ibanNumberFormatter,
            validator: (val)=>Validator.validateIBANNumber(val!),
          ),
          20.verticalSpace,
          elevatedButton(
            text: "submitRequest",
            onPressed: () => controller.submitRequest(),
          ),
          16.verticalSpace,
          elevatedIconButton(
            text: "previous",
            backgroundColor: AppColors.lightGreyColor,
            next: false,
            onPressed: () {
              controller.currentSubTab.value = 2;
              controller.scrollToTop();
            },
          ),
          16.verticalSpace,
          if (controller.showSaveAsDraft)
            CustomButton(
                buttonType: ButtonType.draft,
                onPressed: () =>
                    controller.submitRequest(saveAsDraft: true))
        ],
      ),
    );
  }
}
