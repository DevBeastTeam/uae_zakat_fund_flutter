import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class LabelDropDown2 extends StatelessWidget {
  final List<LookupData> items;
  final String label;
  LookupData? selectedValue;
  bool isRequired;
  bool showLabel;
  bool showSearch;
  bool isBackWhite;
  String hint;
  void Function(LookupData?)? onChanged;
  TextEditingController controller = TextEditingController();
  FocusNode? focusNode;

  LabelDropDown2(
      {super.key,
      this.selectedValue,
      this.hint = "",
      this.isRequired = false,
      this.showLabel = true,
      this.isBackWhite = false,
      this.showSearch = false,
      required this.items,
      this.focusNode,
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
          child: DropdownButtonFormField2<LookupData>(
            focusNode: focusNode,

            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,

            ),
            isExpanded: true,
            validator: isRequired
                ? (value) {
                    return Validator.validateDropDown2(value: selectedValue, label: label);
                  }
                : null,
            items: items
                .map((LookupData item) => DropdownMenuItem<LookupData>(
                      value: item,
                      child: Text(
                        Utils.isArabic?item.nameAr:item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.secondaryBlackColor,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp),
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
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    width: 1.w, color: AppColors.secondaryLightGreyColor),
                color:  Colors.white,
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
                  borderRadius: BorderRadius.circular(14.r), color: Colors.white),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40.h,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
            ),
            dropdownSearchData: showSearch
                ? DropdownSearchData(
                    searchController: controller,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: controller,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'search'.tr,
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      LookupData itemData  = item.value!;
                      String name = Utils.isArabic?itemData.nameAr:itemData.name;
                      return name
                          .toString()
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  )
                : null,
            onMenuStateChange: showSearch
                ? (isOpen) {
                    if (!isOpen) {
                      controller.clear();
                    }
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
