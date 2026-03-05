import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/onboarding.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/onboarding_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class OnBoardingScreen extends GetView<OnboardingViewModel> {
  const OnBoardingScreen({super.key});

  final onboardingData = const [
    Onboarding(
        image: AppResources.onboardingImage1,
        title: 'passwordLessSignIn',
        subTitle: 'onBoardingMessage1'),
    Onboarding(
        image: AppResources.onboardingImage2,
        title: 'singleMobileIdentity',
        subTitle: 'onBoardingMessage2'),
    Onboarding(
        image: AppResources.onboardingImage3,
        title: 'digitalSignature',
        subTitle: 'onBoardingMessage3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff412B0B),
              Color(0xffD6D0C6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SvgPicture.asset(
                AppResources.uaePassLogo,
                width: 150.w,
                height: 46.h,
              ),
              const Spacer(),
              Expanded(
                flex: 4,
                child: PageView(
                  onPageChanged: (index) => controller.updateIndex(index),
                  children: onboardingData
                      .map((data) => IntrinsicWidth(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    data.image,
                                    width: 350.w,
                                    height: 200.h,
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    data.title.tr,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.white24spTextStyle,
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    data.subTitle.tr,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.white18spTextStyle2,
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIndicator(controller.currentIndex.value == 0),
                      8.horizontalSpace,
                      _buildIndicator(controller.currentIndex.value == 1),
                      8.horizontalSpace,
                      _buildIndicator(controller.currentIndex.value == 2),
                    ],
                  )),
              Spacer(),
              elevatedButton(
                  text: 'skip',
                  onPressed: () {
                    onboardingBox.add(true);
                    Get.offNamed(AppRoutes.mainScreen);
                  }),
              const SizedBox(height: 10),
              Text(
                "copyrightZakatFund".tr,
                textAlign: TextAlign.center,
                style: AppTextStyle.lightBlack14spTextStyle,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: isActive ? 96.w : 40.w,
      height: 10.h,
      decoration: BoxDecoration(
        color: isActive
            ? themeViewModel.color
            : themeViewModel.color.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(32.r),
      ),
    );
  }
}
