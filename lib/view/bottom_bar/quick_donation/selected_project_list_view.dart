import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class SelectedProjectsListView extends StatelessWidget {
  const SelectedProjectsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<MainViewModel>();
    return Expanded(
      child: Obx(() {
        final selectedProjects = viewModel.selectedProjectsList;
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            ...List.generate(selectedProjects.length, (index){
              final project = selectedProjects[index];
              return KeyboardActions(
                autoScroll: false,
                config: Utils.buildConfig(
                  context,
                  [KeyboardActionsItem(displayArrows: false, focusNode: project.focusNode)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              Utils.isArabic
                                  ? project.projectNameArabic
                                  : project.projectName,
                              style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          16.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              selectedProjects.removeAt(index);
                              selectedProjects.refresh();
                            },
                            child: Image.asset(
                              AppResources.deleteIcon,
                              width: 16.w,
                              height: 16.h,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.isArabic
                                ? project.associationNameArabic!
                                : project.associationName!,
                            style: AppTextStyle.primaryDarkGrey14spTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          8.verticalSpace,
                          Wrap(
                            runSpacing: 8.h,
                            spacing: 8.w,
                            children: [
                              ...project.priceList.map((price) => _buildPriceChip(project, price)),
                              _buildCustomAmountField(project),
                            ],
                          ),
                        ],
                      ),
                    ),
                    6.verticalSpace,
                    const Divider(color: AppColors.lightGrey, height: 0),
                  ],
                ),
              );
            }),
            _buildTotalAmount(viewModel),
            _buildPaymentSecurityInfo(),
          ],
        );
      }),
    );
  }

  Widget _buildPriceChip(ProjectElements project, int price) {
    final viewModel = Get.find<MainViewModel>();
    final isSelected = project.price == price;

    return SizedBox(
      height: 35,
      child: RawChip(
        onPressed: () {
          project.controller.clear();
          FocusScope.of(Get.context!).unfocus();
          project.price = price;
          viewModel.selectedProjectsList.refresh();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        side: const BorderSide(color: AppColors.lightGrey),
        backgroundColor: isSelected ? AppColors.chipBackgroundColor : Colors.white,
        label: Text("$price ${"currency".tr}"),
        labelStyle: isSelected
            ? AppTextStyle.accentBrown12spTextStyle
            : AppTextStyle.darkGreyOne12spTextStyle1,
      ),
    );
  }

  Widget _buildCustomAmountField(ProjectElements project) {
    final viewModel = Get.find<MainViewModel>();
    return SizedBox(
      height: 35,
      width: 115.w,
      child: TextField(
        controller: project.controller,
        focusNode: project.focusNode,
        textAlign: TextAlign.center,
        style: AppTextStyle.accentBrown12spTextStyle,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.ltr,
        onChanged: (val) {
          project.price = val.isNotEmpty ? int.parse(val) : 10;
          viewModel.selectedProjectsList.refresh();
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.deny(RegExp(r'^0+')),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(width: 1.w, color: AppColors.accentBrownColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(width: 1.w, color: AppColors.lightGrey),
          ),
          hintText: "enterTopUpAmount".tr,
          hintMaxLines: 1,
          hintStyle: AppTextStyle.darkGreyOne12spTextStyle1,
        ),
      ),
    );
  }

  Widget _buildTotalAmount(MainViewModel viewModel) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.grayColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("totalAmount".tr),
          Text("${viewModel.getTotalAmount()} ${"currency".tr}"),
        ],
      ),
    );
  }

  Widget _buildPaymentSecurityInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.grayColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_rounded, color: themeViewModel.color),
          6.horizontalSpace,
          Flexible(
            child: Text(
              "paymentSecureMessage".tr,
              textAlign: TextAlign.center,
              style: AppTextStyle.primaryDarkBlack12spTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}