import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class LabelTextField extends StatelessWidget {
  bool isPassword;
  bool isArabicDirection;
  bool obscureText;
  bool isDate;
  bool isNewDate;
  bool isTime;
  bool isBlack;
  bool feedback;
  bool isRequired;
  bool showLabel;
  bool amountOnly;
  bool addAmount;
  bool checkValidation;
  String? hint;
  int? maxLength;
  bool showVerify;
  int maxLines;
  final Function()? onAddFile;
  final Function()? onVerify;
  final String? prefixIcon;
  List<TextInputFormatter>? inputFormatters;
  bool readOnly;
  TextInputType? keyboardType;
  bool isBackWhite;
  String? Function(String?)? validator;
  final String label;
  void Function()? onSuffixTap;
  void Function()? onAdd;
  void Function(String)? onChanged;
  final TextEditingController controller;
  FocusNode? focusNode;
  Function()? onTap;
  GlobalKey? globalKey;

  LabelTextField(
      {super.key,
      this.maxLines = 1,
      this.validator,
      this.focusNode,
      this.isPassword = false,
      this.showLabel = true,
      this.feedback = false,
      this.keyboardType,
      this.isArabicDirection = false,
      this.isDate = false,
      this.isNewDate = false,
      this.isTime = false,
      this.addAmount = false,
      this.isBlack = false,
      this.amountOnly = false,
      this.obscureText = false,
      this.readOnly = false,
      this.isBackWhite = false,
      this.showVerify = false,
      this.onSuffixTap,
      this.onChanged,
      this.prefixIcon,
      this.hint,
      this.maxLength,
      this.globalKey,
      this.onTap,
      this.onVerify,
      this.inputFormatters,
      this.onAdd,
      required this.controller,
      this.checkValidation = false,
      this.isRequired = false,
      required this.label,
      this.onAddFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          textFieldLabel(
              label: label.tr, isRequired: isRequired, isBlack: isBlack),
        if (showLabel) 4.verticalSpace,
        TextFormField(
          onTap: onTap,
          minLines: 1,
          enableInteractiveSelection: !readOnly,
          focusNode: focusNode,
          key: globalKey,
          inputFormatters: inputFormatters,
          validator: checkValidation
              ? validator ??
                  (value) {
                    return Validator.validateEmpty(value: value, label: label);
                  }
              : null,
          readOnly: readOnly,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          style: AppTextStyle.secondaryBlack14spTextStyle1,
          obscureText: obscureText,
          maxLines: maxLines,
          onChanged: onChanged,
          maxLength: maxLength,
          textAlign: Utils.isArabic && isArabicDirection
              ? TextAlign.right
              : TextAlign.start,
          textDirection:
              Utils.isArabic && isArabicDirection ? TextDirection.ltr : null,
          decoration: InputDecoration(
            fillColor: isBackWhite?Colors.white:null,
            filled: isBackWhite,
            hintText: onAddFile != null ? "selectFile".tr : hint?.tr,
            hintTextDirection:
                Utils.isArabic && isArabicDirection ? TextDirection.ltr : null,
            errorMaxLines: 2,
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12.r),
                borderSide: BorderSide(
                    width: 1.w, color: AppColors.secondaryLightGreyColor)),
            suffixIcon: showVerify
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: RawChip(
                      tapEnabled: true,
                      onPressed: onVerify,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text("verify".tr,
                          style: AppTextStyle.secondaryBlack14spTextStyle1),
                      side: BorderSide(
                          color: AppColors.secondaryLightGreyColor, width: 1.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r)),
                      backgroundColor: Colors.white,
                    ),
                  )
                : onAddFile != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: RawChip(
                          tapEnabled: true,
                          onPressed: onAddFile,
                          avatar: Image.asset(AppResources.attachIcon),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text("addFile".tr,
                              style: AppTextStyle.secondaryBlack14spTextStyle1),
                          side: BorderSide(
                              color: AppColors.secondaryLightGreyColor,
                              width: 1.w),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                          backgroundColor: Colors.white,
                        ),
                      )
                    : amountOnly
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 0.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "currency".tr,
                                  style:
                                      AppTextStyle.darkGreyColor14spTextStyle,
                                ),
                                if (addAmount) 8.horizontalSpace,
                                if (addAmount)
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 4.w)),
                                        backgroundColor: WidgetStatePropertyAll(
                                            themeViewModel.color),
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r)))),
                                    onPressed: onAdd,
                                    child: Text(
                                      "add".tr,
                                      maxLines: 1,
                                      style: AppTextStyle.btnText14spTextStyle1,
                                    ),
                                  )
                              ],
                            ),
                          )
                        : isTime
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: Image.asset(
                                  AppResources.clockIcon,
                                  color: const Color(0xff939393),
                                ),
                              )
                            : isDate
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: SvgPicture.asset(
                                        AppResources.calendarIcon1),
                                  )
                                : isPassword
                                    ? GestureDetector(
                                        onTap: onSuffixTap,
                                        child: Icon(obscureText
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined),
                                      )
                                    : null,
            prefixIcon: isNewDate
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SvgPicture.asset(AppResources.calendarIcon1),
                  )
                : prefixIcon != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: SvgPicture.asset(
                          prefixIcon!,
                          color: feedback ? AppColors.grey : null,
                        ),
                      )
                    : null,
            hintStyle: AppTextStyle.lightGrey116spTextStyle,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: maxLines != 1 ? 8.h : 0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                    width: 1.w, color: AppColors.secondaryLightGreyColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                    width: 1.w, color: AppColors.secondaryLightGreyColor)),
          ),
        ),
      ],
    );
  }
}
