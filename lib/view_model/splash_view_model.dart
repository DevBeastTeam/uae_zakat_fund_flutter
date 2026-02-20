import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class SplashViewModel extends GetxController {
  final RxInt selectedLanguage = 0.obs;
  final bool setData;

  SplashViewModel(this.setData);

  @override
  void onInit() {
    if (setData & appLangBox.isNotEmpty) {
      int appLang = appLangBox.getAt(0);
      selectedLanguage.value = appLang;
    }
    Utils.logEvent(name: EventConstant.languageSelectionScreen);
    _initializeUUID();

    super.onInit();
  }

  void _initializeUUID() {
    if (uuidBox.isEmpty) {
      uuidBox.add(const Uuid().v4());
    }
  }

  Future<void> changeMenuData() async {
    final accountViewModel = Get.find<AccountViewModel>();
    final mainViewModel = Get.find<MainViewModel>();
    final homeViewModel = Get.find<HomeViewModel>();

    accountViewModel.filterNationality();
    Utils.showLoadingDialog();

    mainViewModel.menu.clear();

    await Future.wait([
      homeViewModel.fetchStaticPages(1),
      homeViewModel.fetchStaticPages(2),
    ]);

    Utils.hideLoadingDialog();
    mainViewModel.menu.refresh();
  }

  selectLanguage(english, index) async {
    await appLangBox.clear();
    await appLangBox.add(index);

    print("WHAT ${appLangBox.getAt(0)}");
    Utils.logEvent(
        name: english
            ? EventConstant.languageSelectedEnglish
            : EventConstant.languageSelectedArabic);
    if (setData) {
      if (selectedLanguage.value == index) {
        return;
      }
      selectedLanguage.value = index;
      Get.updateLocale(Locale(english ? "en" : "ar"));
      await changeMenuData();
    } else {
      selectedLanguage.value = index;
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        Get.updateLocale(Locale(english ? "en" : "ar"));
        Get.offNamed(AppRoutes.mainScreen);
      });
    }
  }
}
