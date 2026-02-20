import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/widgets/already_have_account.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/footer.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            20.verticalSpace,
            Image.asset(
              AppResources.tickCircleIcon,
              width: 56.w,
              height: 56.h,
            ),
            20.verticalSpace,
            Text(
              "successfullyVerified".tr,
              textAlign: TextAlign.center,
              style: AppTextStyle.black16spTextStyle,
            ),
            4.verticalSpace,
            Text(
              "completeRegistration".tr,
              textAlign: TextAlign.center,
              style: AppTextStyle.primaryDarkGrey14spTextStyle1,
            ),
            20.verticalSpace,
            elevatedButton(
              text: "login",
              onPressed: () => Get.until(
                  (route) => route.settings.name == AppRoutes.logInScreen),
            ),
            const Spacer(),
            buildAlreadyHaveAccount(),
            20.verticalSpace,
            buildFooter(),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
