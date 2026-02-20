import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class IconDropDown extends StatelessWidget {
  final List<String> items;
  final String label;
  String? selectedValue;
  bool isRequired;
  bool showLabel;
  bool isBackWhite;
  String hint;
  void Function(String?)? onChanged;
  TextEditingController controller = TextEditingController();
  GlobalKey? globalKey;

  IconDropDown(
      {super.key,
      this.selectedValue,
      this.hint = "",
      this.isRequired = false,
      this.showLabel = true,
      this.isBackWhite = false,
      required this.items,
      this.globalKey,
      required this.onChanged,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(showLabel)textFieldLabel(
            label: label.tr, isRequired: isRequired, isBlack: isBackWhite),
        if(showLabel)4.verticalSpace,
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<String>(
            key: globalKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            isExpanded: true,
            validator: isRequired
                ? (value) {
                    return Validator.validateDropDown(
                        value: selectedValue, label: label);
                  }
                : null,
            items: items
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: SvgPicture.asset(
                        item == "3"
                            ? AppResources.warningIcon1
                            : AppResources.notificationIcon,
                      ),
                    ))
                .toList(),
            hint: Text(
              hint.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            value: selectedValue,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                    width: 1.w, color: AppColors.secondaryLightGreyColor),
                color: isBackWhite ? Colors.white : AppColors.lightGreyColor,
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Image.asset(
                  AppResources.arrowDownIcon,
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250.h,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14), color: Colors.white),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40.h,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
            ),

          ),
        ),
      ],
    );
  }
}
