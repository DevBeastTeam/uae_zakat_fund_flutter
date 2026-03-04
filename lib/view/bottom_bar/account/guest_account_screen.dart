import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/account_list_tile.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class GuestAccountScreen extends StatelessWidget {
  GuestAccountScreen({super.key});

  final List<Categories> guestTabs = [
    Categories(name: "accessibility", icon: AppResources.accessibilityIcon),
    Categories(name: "settings", icon: AppResources.settingsIcon),
    Categories(name: "associations", icon: AppResources.associations),
    // Categories(name: "mediaCenter", icon: AppResources.mediaCenter),
    Categories(name: "services", icon: AppResources.services),
    Categories(name: "projects", icon: AppResources.projects),
    Categories(name: "contactUs", icon: AppResources.contactUs),
    Categories(name: "faqs", icon: AppResources.faqs),
    Categories(name: "aboutUs", icon: AppResources.aboutUs),
    Categories(name: "privacyPolicy", icon: AppResources.securityIcon),
  ];
  final viewModel = Get.find<MainViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Get.height,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: ValueListenableBuilder(
                valueListenable: userBox.listenable(),
                builder:
                    (BuildContext context, Box<dynamic> value, Widget? child) {
                  User? user;
                  if (value.isNotEmpty) {
                    user = value.getAt(0);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: user != null
                            ? () {
                                Get.toNamed(AppRoutes.accountScreen);
                              }
                            : null,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: user != null
                            ? ClipOval(
                                child: user.photo != null
                                    ? CachedImage(
                                        image: user.photo,
                                        width: 56.w,
                                        height: 56.h,
                                        profile: true,
                                      )
                                    : Image.asset(
                                        AppResources.userAvatar,
                                        width: 56.w,
                                        height: 56.h,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : SvgPicture.asset(
                                AppResources.profileCircle,
                                width: 56.w,
                                height: 56.h,
                              ),
                        horizontalTitleGap: 10.w,
                        title: Text(
                            user != null
                                ? "${user.firstName} ${user.lastName}"
                                : "welcomeGuest".tr,
                            style: AppTextStyle
                                .secondaryPrimaryBlack18spTextStyle2),
                        subtitle: Text(
                          user != null ? user.email : "manageYourAccount".tr,
                          style: AppTextStyle.darkGreyOne14spTextStyle,
                        ),
                      ),
                      10.verticalSpace,
                      SizedBox(
                        height: 36.h,
                        child: user != null
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(
                                                12.r)),
                                    elevation: 0,
                                    side: BorderSide(
                                        color:
                                            AppColors.secondaryDarkBrownColor)),
                                onPressed: () {
                                  viewModel.logOut();
                                },
                                child: Text(
                                  "signOut".tr,
                                  maxLines: 1,
                                  style: AppTextStyle
                                      .secondaryDarkBrownColor14spTextStyle,
                                ),
                              )
                            : ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        themeViewModel.color),
                                    elevation: const WidgetStatePropertyAll(0),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r)))),
                                onPressed: () {
                                  Get.toNamed(AppRoutes.logInScreen);
                                },
                                icon: Transform.flip(
                                    flipX: Utils.isArabic,
                                    child: SvgPicture.asset(
                                        AppResources.loginWindow)),
                                label: Text(
                                  "signIn".tr,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
            16.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: _buildMenusList(),
            ),
            16.verticalSpace,
            ColorBlindScreen(),
            130.verticalSpace,
          ],
        ),
      ),
    );
  }

  Column _buildMenusList() {
    return Column(
      children: List.generate(
          guestTabs.length,
          (index) => accountMenuWidget(
              tab: guestTabs[index],
              onTap: () => donorMenusNavigation(index))).toList(),
    );
  }

  donorMenusNavigation(int index) {
    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.accessibilityScreen);
      case 1:
        Get.toNamed(AppRoutes.settingsScreen);
      case 2:
        Get.toNamed(AppRoutes.allAssociationsScreen);
      case 3:
        viewModel.switchTab(1);
      case 4:
        viewModel.switchTab(2);
      case 5:
        Get.toNamed(AppRoutes.contactUsScreen);
      case 6:
        Get.toNamed(AppRoutes.faqScreen);
      case 7:
        Get.toNamed(AppRoutes.aboutSahemScreen);
      case 8:
        // The instruction provided a snippet with `if (code == "S-07")`
        // which uses a variable `code` not available in this context.
        // Assuming the intent was to modify the existing case 8 logic
        // or to introduce a new conditional check within the switch.
        // Since the instruction explicitly shows the `if` block replacing
        // the `case 8` content, and to maintain syntactic correctness
        // within the `switch` statement, the `if` condition is adapted
        // to check the `index` value.
        // If the original intent was to use a 'code' string,
        // further clarification would be needed.
        if (index == 8) {
          // Assuming "S-07" maps to index 8 for privacy policy
          Get.toNamed(AppRoutes.webViewScreen, arguments: {
            "title": "privacyPolicy".tr,
            "url":
                "${FlavorConfig.webSiteUrl}page/privacy${Utils.isArabic ? 'ar' : 'en'}"
          });
          return;
        }
        break; // Added break to prevent fall-through after the if block
      default:
    }
  }
}

enum ColorBlindType {
  normal,
  blind,
  gray,
  blue,
  green,
  red,
}

class ColorBlindController extends GetxController {
  final selected = ColorBlindType.normal.obs;

  @override
  void onInit() {
    if (colorsBox.isNotEmpty) {
      selected.value = ColorBlindType.values[colorsBox.getAt(0)];
    }
    super.onInit();
  }

  Future<void> change(ColorBlindType type) async {
    selected.value = type;
    await colorsBox.clear();
    colorsBox.add(ColorBlindType.values.indexOf(type));
    Get.offAllNamed(AppRoutes.mainScreen);
  }
}

class ColorBlindScreen extends StatelessWidget {
  ColorBlindScreen({super.key});

  final controller = Get.put(ColorBlindController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "colorBlindness".tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle3,
          ),
          16.verticalSpace,
          Obx(() => _optionTile(
                title: "normal",
                type: ColorBlindType.normal,
                dotColor: AppColors.brownPrimaryColor,
              )),
          const SizedBox(height: 12),
          Obx(() => _optionTile(
                title: "colorBlind",
                type: ColorBlindType.blind,
                dotColor: Colors.grey,
              )),
          const SizedBox(height: 12),
          Obx(() => _optionTile(
                title: "grayWeakness",
                type: ColorBlindType.gray,
                dotColor: Colors.grey.shade700,
              )),
          const SizedBox(height: 12),
          Obx(() => _optionTile(
                title: "blueWeakness",
                type: ColorBlindType.blue,
                dotColor: const Color(0xFFE78BC4),
              )),
          const SizedBox(height: 12),
          Obx(() => _optionTile(
                title: "greenWeakness",
                type: ColorBlindType.green,
                dotColor: const Color(0xFF405E8F),
              )),
          const SizedBox(height: 12),
          Obx(() => _optionTile(
                title: "redWeakness",
                type: ColorBlindType.red,
                dotColor: const Color(0xFF7DE4D3),
              )),
        ],
      ),
    );
  }

  Widget _optionTile({
    required String title,
    required ColorBlindType type,
    required Color dotColor,
  }) {
    final isSelected = controller.selected.value == type;

    return GestureDetector(
      onTap: () => controller.change(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected ? const Color(0xFFB58B3C) : Colors.grey.shade300,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFB58B3C),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB58B3C),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
