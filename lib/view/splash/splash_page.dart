import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppResources.splashBG,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.70),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  SvgPicture.asset(
                    AppResources.newLogo,
                    width: 72.w,
                    height: 72.h,
                  ),
                  8.verticalSpace,
                  SvgPicture.asset(
                    AppResources.zakatPlatform,
                    width: 250.w,
                    height: 45.h,
                  ),
                  16.verticalSpace,
                  Text(
                    "splashDesc".tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.secondaryDarkBrown18spTextStyle,
                  ),
                  20.verticalSpace,
                  Text(
                    "selectLanguage".tr,
                    style: AppTextStyle.secondaryDarkBrownColor32spTextStyle,
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: elevatedButton(
                            text: "English",
                            onPressed: () {
                              appLangBox.add(1);
                              Get.updateLocale(Locale("en"));
                              if (onboardingBox.isEmpty) {
                                Get.offNamed(AppRoutes.onBoardingScreen);
                              } else {
                                Get.offNamed(AppRoutes.mainScreen);
                              }
                            }),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: elevatedButton(
                            text: "عربي",
                            onPressed: () {
                              Get.updateLocale(Locale("ar"));
                              appLangBox.add(2);
                              if (onboardingBox.isEmpty) {
                                Get.offNamed(AppRoutes.onBoardingScreen);
                              } else {
                                Get.offNamed(AppRoutes.mainScreen);
                              }
                            }),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  SvgPicture.asset(
                    AppResources.awqafIcon,
                    width: 233.w,
                    height: 40.h,
                  ),
                  30.verticalSpace
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
