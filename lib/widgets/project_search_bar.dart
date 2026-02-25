import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';

Container buildProjectSearchBar(viewModel) => Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
        border: Border.all(
            color: AppColors.lightGreyColor,
            width: 1.0.w,
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            offset: const Offset(0.0, 4.0),
            blurRadius: 100.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoSearchTextField(
              placeholder: "search".tr,
              controller: viewModel.searchController,
              style: AppTextStyle.secondaryBlack14spTextStyle1.copyWith(fontFamily: "Alexandria"),
              placeholderStyle: AppTextStyle.darkGrey14spTextStyle.copyWith(fontFamily: "Alexandria"),
            onChanged: (value) async {
                if(value.isEmpty){
                  Utils.showLoadingDialog();
                  await viewModel.fetchProjects(search: true,clear:true);
                  Utils.hideLoadingDialog();
                }
            },
            onSubmitted: (value) async {
              Utils.showLoadingDialog();
              await viewModel.fetchProjects(search: true,clear:true);
              Utils.hideLoadingDialog();
            },
              prefixInsets: EdgeInsets.only(
                  left: Utils.isArabic ? 0.w : 13.w,
                  right: Utils.isArabic ? 13.w : 0.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.r),
              ),
              prefixIcon: SvgPicture.asset(
                AppResources.searchIcon,
                width: 16.w,
                height: 16.h,
              ),
            ),
          ),
          // 16.horizontalSpace,
          Expanded(
            child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    items: viewModel.associationsNames
                        .map<DropdownMenuItem<String>>(
                            (String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item.tr,
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
                    value: viewModel.selectedAssociation.value,
                    onChanged: (val) async {
                      if(val==viewModel.selectedAssociation.value){
                        return;
                      }
                      viewModel.selectedAssociation.value = val!;
                        Utils.showLoadingDialog();
                        await viewModel.fetchProjects(search: true,clear:true);
                        Utils.hideLoadingDialog();

                    },
                    hint: Text(
                      "selectAssociation".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.primaryDarkBlack14spTextStyle,
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 54,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                            width: 1.w,
                            color: AppColors.secondaryLightGreyColor),
                        color: Colors.white,
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
                        borderRadius: BorderRadius.circular(14.r),
                          color: Colors.white
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 40.h,
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: viewModel.searchAssociationController,
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
                          controller: viewModel.searchAssociationController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'searchAssociation'.tr,
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        viewModel.searchAssociationController.clear();
                      }
                    },
                  ),
                )),
          ),
          13.horizontalSpace,
        ],
      ),
    );
