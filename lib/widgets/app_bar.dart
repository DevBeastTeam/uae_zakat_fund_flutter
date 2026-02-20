import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zakat_fund/chatbot/core/di.dart';
import 'package:zakat_fund/chatbot/presentation/view/chat_bot_view.dart';
import 'package:zakat_fund/chatbot/presentation/view_model/chat_bot_view_model.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

PreferredSizeWidget appBarWidget() {
  var viewModel = Get.find<MainViewModel>();
  var cartViewModel = Get.find<CartViewModel>();

  return PreferredSize(
    preferredSize: Size.fromHeight(150.h),
    child: SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ValueListenableBuilder(
          valueListenable: userBox.listenable(),
          builder: (BuildContext context, Box<dynamic> value, Widget? child) {
            return Obx(() {
              final currentIndex = viewModel.currentIndex.value;
              final notificationCount = viewModel.notificationCount.value;
              return Row(
                children: [
                  Builder(
                      builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: _circleButton(icon: AppResources.menuIcon),
                          )),
                  if (currentIndex != 2) 8.horizontalSpace,
                  const Spacer(),
                  currentIndex != 0
                      ? Text(
                          _getAppBarTitle(currentIndex),
                          style: AppTextStyle.darkBlack18spTextStyle,
                        )
                      : GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return ChangeNotifierProvider(
                                create: (BuildContext context) =>
                                    ChatBotViewModel(
                                      suggestionsUsecase: sl(),
                                      chatUsecase: sl(),
                                      getChatsHistoryUsecase: sl(),
                                      getChatMessagesUsecase: sl(),
                                    )..getSuggestions(),
                                child: ChatBotView());
                          })),
                          child: Lottie.asset(
                              Utils.isArabic
                                  ? AppResources.zakatFundHeaderAR
                                  : AppResources.zakatFundHeaderEN,
                              width: 175.w,
                              height: 70.h),
                        ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      cartViewModel.resetData();
                      cartViewModel.fetchCart(showLoading: true);
                      Get.toNamed(AppRoutes.cartScreen);
                    },
                    child: Obx(() => Badge(
                          label: Text(
                            '${cartViewModel.cartCount.value}',
                            style: AppTextStyle.white12spTextStyle,
                          ),
                          offset: Offset(0, -3),
                          isLabelVisible: cartViewModel.cartCount.value > 0,
                          backgroundColor: Colors.red,
                          child: SvgPicture.asset(
                            AppResources.cartIcon,
                            width: 32.w,
                            height: 32.h,
                          ),
                        )),
                  ),
                  if (value.isEmpty) _buildLoginButton()
                ],
              );
            });
          },
        ),
      ),
    ),
  );
}

Widget _buildLoginButton() {
  return GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.logInScreen),
    child: Transform.flip(
      flipX: Utils.isArabic,
      child: SvgPicture.asset(
        AppResources.loginIcon,
        width: 32.w,
        height: 32.h,
      ),
    ),
  );
}

Widget _buildNotificationIcon(int notificationCount) {
  return GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.notificationScreen),
    child: Badge(
      label: Text(
        '$notificationCount',
        style: AppTextStyle.white12spTextStyle,
      ),
      offset: const Offset(0, 4),
      isLabelVisible: notificationCount > 0,
      backgroundColor: Colors.red,
      child: _circleButton(icon: AppResources.notificationIcon),
    ),
  );
}

String _getAppBarTitle(int index) {
  switch (index) {
    case 0:
      return "home".tr;
    case 1:
      return "services".tr;
    case 2:
      return "projects".tr;
    case 3:
      return "statics".tr;
    case 4:
      return "profile".tr;
    default:
      return "account".tr;
  }
}

Widget _circleButton({required String icon}) {
  return Container(
    height: 40.h,
    width: 40.w,
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
          color: AppColors.lightGreyColor, width: 2, style: BorderStyle.solid),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.01),
          offset: const Offset(0.0, 4.0),
          blurRadius: 50.0,
        ),
      ],
    ),
    child: SvgPicture.asset(
      icon,
      color: AppColors.secondaryLightGreyColor1,
    ),
  );
}
