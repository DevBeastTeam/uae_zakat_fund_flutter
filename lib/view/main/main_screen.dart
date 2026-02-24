import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/view/bottom_bar/account/account_screen.dart';
import 'package:zakat_fund/view/bottom_bar/account/guest_account_screen.dart';
import 'package:zakat_fund/view/bottom_bar/campaigns/campaigns_screen.dart';
import 'package:zakat_fund/view/bottom_bar/home/home_screen.dart';
import 'package:zakat_fund/view/bottom_bar/quick_donation/quick_donation_screen.dart';
import 'package:zakat_fund/view/bottom_bar/services/services_screen.dart';
import 'package:zakat_fund/view/bottom_bar/statics/statics_screen.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/app_bar.dart';
import 'package:zakat_fund/widgets/bottom_nav_bar.dart';
import 'package:zakat_fund/widgets/drawer.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final controller = Get.put(MainViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      extendBody: true,
      appBar: appBarWidget(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: BottomNavBar(),
      body: Obx(() => _buildBody(controller.currentIndex.value)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.quickDonateColor,
        onPressed: () => quickDonationBottomSheet(),
        shape: const CircleBorder(),
        child: SvgPicture.asset(
          AppResources.quickDonate,
          width: 24.w,
          height: 24.h,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return ServicesScreen();
      case 2:
        return CampaignsScreen();
      case 3:
        return StatisticsScreen();

      case 4:
        return ValueListenableBuilder(
          valueListenable: userBox.listenable(),
          builder: (BuildContext context, Box<dynamic> value, Widget? child) {
            return value.isEmpty ? GuestAccountScreen() : const AccountScreen();
          },
        );
      default:
        return HomeScreen();
    }
  }
}
