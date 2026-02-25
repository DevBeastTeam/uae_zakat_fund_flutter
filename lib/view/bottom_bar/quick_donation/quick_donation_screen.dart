import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/payment_method_widget.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

void quickDonationBottomSheet() {
  Utils.logEvent(name: EventConstant.quickDonationScreen);
  final viewModel = Get.find<MainViewModel>();

  Get.bottomSheet(
    Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: KeyboardDismissOnTap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            myAppBar(title: "quickDonate"),
            Obx(() => viewModel.goNext.value
                ? const SizedBox.shrink()
                : _buildSearchField(viewModel)),
            Obx(() {
              if (viewModel.showPaymentMethod.value) {
                return const Expanded(
                  child: SingleChildScrollView(child: PaymentMethodWidget()),
                );
              }
              return viewModel.goNext.value
                  ? _selectedProjects()
                  : _projectListView();
            }),
            _buildBottomActions(viewModel)
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    ignoreSafeArea: false,
    enableDrag: false,
  ).whenComplete(() {
    viewModel.goNext.value = false;
    viewModel.showPaymentMethod.value = false;
    viewModel.projects.clear();
  });
  viewModel.fetchProjects();
}

Widget _buildSearchField(MainViewModel viewModel) {
  final searchController = TextEditingController();
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: CupertinoSearchField(
      controller: searchController,
      onChanged: (val) {
        viewModel.projects.value = viewModel.allProjects.where((project) {
          final name =
              Utils.isArabic ? project.projectNameArabic : project.projectName;
          return name.toLowerCase().contains(val.toLowerCase());
        }).toList();
      },
    ),
  );
}

Widget _buildBottomActions(MainViewModel viewModel) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Obx(() => Row(
          children: [
            if (viewModel.goNext.value)
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: themeViewModel.color),
                    // side:
                    //     BorderSide(width: 2.w, color: AppColors.darkBrownColor),
                    minimumSize: Size(Get.width, 45.h),
                  ),
                  onPressed: () {
                    viewModel.showPaymentMethod.value
                        ? viewModel.showPaymentMethod.value = false
                        : viewModel.goNext.value = false;
                  },
                  child: Text(
                    "back".tr,
                    maxLines: 1,
                    style: TextStyle(color: themeViewModel.color),

                    // style: AppTextStyle.primaryDarkBrown16spTextStyle1,
                  ),
                ),
              ),
            if (viewModel.goNext.value && !viewModel.showPaymentMethod.value)
              10.horizontalSpace,
            if (!viewModel.showPaymentMethod.value)
              Expanded(
                child: elevatedButton(
                  text: viewModel.goNext.value ? "donateNowText" : "next",
                  onPressed: () {
                    if (viewModel.goNext.value) {
                      if (userBox.isNotEmpty) {
                        final user = userBox.getAt(0);
                        if (user.roles.contains("Admin") ||
                            user.roles.contains("Orgainizations")) {
                          Utils.showGlobalSnackBar(message: "loginAsDonor".tr);
                          return;
                        }
                      }
                      if (viewModel.selectedProjectsList.isNotEmpty) {
                        viewModel.addQuickProjects();
                      }
                    } else {
                      viewModel.selectedProjectsList.value = viewModel.projects
                          .where((project) => project.isSelected)
                          .toList();

                      if (viewModel.selectedProjectsList.isEmpty) {
                        Utils.showGlobalSnackBar(
                            message: "pleaseSelectProject".tr);
                      } else {
                        viewModel.goNext.value = true;
                        final cartViewModel = Get.find<CartViewModel>();
                        cartViewModel.cartCount.value =
                            viewModel.selectedProjectsList.length;
                      }
                    }
                  },
                ),
              ),
          ],
        )),
  );
}

Widget _selectedProjects() {
  final viewModel = Get.find<MainViewModel>();
  return Expanded(
    child: Obx(() => ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            ...List.generate(viewModel.selectedProjectsList.value.length,
                (index) {
              ProjectElements project = viewModel.selectedProjectsList[index];
              return KeyboardActions(
                autoScroll: false,
                config: Utils.buildConfig(Get.context!, [
                  KeyboardActionsItem(
                      displayArrows: false, focusNode: project.focusNode)
                ]),
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
                              style: AppTextStyle
                                  .secondaryPrimaryBlack16spTextStyle3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          16.horizontalSpace,
                          GestureDetector(
                            onTap: () {
                              viewModel.selectedProjectsList.removeAt(index);
                              viewModel.selectedProjectsList.refresh();
                              final cartViewModel = Get.find<CartViewModel>();
                              cartViewModel.cartCount.value =
                                  viewModel.selectedProjectsList.length;
                            },
                            child: Image.asset(
                              AppResources.deleteIcon,
                              width: 16.w,
                              height: 16.h,
                            ),
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${Utils.isArabic ? project.associationNameArabic : project.associationName}",
                            style: AppTextStyle.primaryDarkGrey14spTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          8.verticalSpace,
                          Wrap(
                            runSpacing: 8.h,
                            spacing: 8.w,
                            children: [
                              ...project.priceList.map((data) => SizedBox(
                                    height: 40,
                                    child: RawChip(
                                      onPressed: () {
                                        project.controller.clear();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        project.price = data;
                                        viewModel.selectedProjectsList
                                            .refresh();
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      side: BorderSide(
                                          color: data == project.price
                                              ? themeViewModel.color
                                              : AppColors.remindColor),
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.circular(8.r),
                                      // ),
                                      backgroundColor: data == project.price
                                          ? themeViewModel.color
                                          : AppColors.greyBackColor,
                                      // side: BorderSide(
                                      //     color: data == project.price
                                      //         ? AppColors.brownPrimaryColor
                                      //         : AppColors.borderColor),
                                      // backgroundColor: data == project.price
                                      //     ? AppColors.brownPrimaryColor
                                      //     : Colors.white,
                                      label: Text("$data ${"currency".tr}"),
                                      labelStyle: data == project.price
                                          ? AppTextStyle.white14spTextStyle
                                          : TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                              color: AppColors.lightGray,
                                            ),
                                    ),
                                  )),
                              SizedBox(
                                height: 35,
                                width: 115.w,
                                child: TextField(
                                  controller: project.controller,
                                  focusNode: project.focusNode,
                                  style: AppTextStyle.accentBrown12spTextStyle,
                                  textAlign: TextAlign.center,
                                  onChanged: (val) {
                                    if (val.toString().isNotEmpty) {
                                      project.price = int.parse(val);
                                      viewModel.selectedProjectsList.refresh();
                                    } else {
                                      project.price = 10;
                                      viewModel.selectedProjectsList.refresh();
                                    }
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(
                                          r'^0+'), //users can't type 0 at 1st position
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: BorderSide(
                                            width: 1.w,
                                            color: AppColors.accentBrownColor)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: BorderSide(
                                            width: 1.w,
                                            color: AppColors.lightGrey)),
                                    hintText: "enterTopUpAmount".tr,
                                    hintMaxLines: 1,
                                    hintStyle:
                                        AppTextStyle.darkGreyOne12spTextStyle1,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    6.verticalSpace,
                    const Divider(color: AppColors.lightGrey, height: 0)
                  ],
                ),
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              margin: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                  color: AppColors.grayColor,
                  // color: const Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("totalAmount".tr),
                  Text("${viewModel.getTotalAmount()} ${"currency".tr}"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.grayColor,
                // color: Color.fromARGB(255, 230, 230, 230),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    color: themeViewModel.color,
                  ),
                  6.horizontalSpace,
                  Flexible(
                    child: Text(
                      "paymentSecureMessage".tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.primaryDarkBlack10spTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
  );
}

Widget _projectListView() {
  final viewModel = Get.find<MainViewModel>();
  return Expanded(
    child: Obx(() => ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (BuildContext context, int index) {
            ProjectElements project = viewModel.projects[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: project.isSelected,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    project.isSelected = val!;
                    viewModel.projects.refresh();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    Utils.isArabic
                        ? project.projectNameArabic
                        : project.projectName,
                    style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "${Utils.isArabic ? project.associationNameArabic : project.associationName}",
                    style: AppTextStyle.primaryDarkGrey14spTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                6.verticalSpace,
                const Divider(color: AppColors.lightGrey, height: 0)
              ],
            );
          },
          itemCount: viewModel.projects.length,
        )),
  );
}
