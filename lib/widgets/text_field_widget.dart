import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final bool amount;
  final bool white;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const TextFieldWidget(
      {super.key,
      required this.hint,
      required this.focusNode,
      this.amount = false,
      this.controller,
      this.onChanged,
      this.white = false,
      this.validator});

  BorderSide get _borderSide => white
      ? BorderSide(width: 1.w, color: AppColors.secondaryLightGreyColor)
      : BorderSide.none;

  OutlineInputBorder get _outlineBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(
          width: 1.w, color: AppColors.remindColor));


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      inputFormatters: InputFormatters.amountFormatter,
      textAlign: Utils.isArabic ? TextAlign.right : TextAlign.start,
      keyboardType: TextInputType.number,
      textDirection: Utils.isArabic ? TextDirection.ltr : null,
      style: AppTextStyle.secondaryBlack14spTextStyle1,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint.tr,
        suffixIcon: amount
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14),
                child: Text("currency".tr,
                    style: AppTextStyle.darkGreyColor14spTextStyle),
              )
            : null,
        fillColor: white ? Colors.white : AppColors.lightGreyColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        focusedBorder: _outlineBorder,
        hintStyle: AppTextStyle.textFieldHintStyle,
        enabledBorder: _outlineBorder,
        border: _outlineBorder,
      ),
    );
  }
}
