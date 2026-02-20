import 'package:get/get.dart';
import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/model/company.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';

class SettingsViewModel extends GetxController {
  late final List<Categories> settingTabs;

  Association? association;
  Individual? individual;
  Company? company;

  String logo = "";
  RxString name = "".obs;

  final accountViewModel = Get.find<AccountViewModel>();

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.settingsScreen);
    _initializeSettingTabs();
    _initializeArguments();
    super.onInit();
  }

  void _initializeSettingTabs() {
    settingTabs = [
      if (userBox.isNotEmpty&&accountViewModel.showNotificationPreferences)
        Categories(
            name: "notificationsPreferences",
            icon: AppResources.notificationIcon,
            code: "S-01"),
      Categories(
          name: "languages", icon: AppResources.languageIcon, code: "S-02"),
      if (userBox.isNotEmpty&&userBox.getAt(0).roles[0]=="Individuals"&&!userBox.getAt(0).isEmployeeAndDonor)
        Categories(
            name: "account", icon: AppResources.accountInfoIcon, code: "S-03"),
      if (userBox.isNotEmpty&&accountViewModel.showPasswordSecurity)
        Categories(
            name: "passwordSecurity",
            icon: AppResources.securityIcon,
            code: "S-04"),
      if (userBox.isNotEmpty&&userBox.getAt(0).roles[0]=="Individuals")
        Categories(
            name: "donationReminder", icon: AppResources.timerIcon, code: "S-05"),
      if (userBox.isNotEmpty&&userBox.getAt(0).roles[0]=="Individuals")
        Categories(
            name: "newProjectAlerts", icon: AppResources.notificationIcon, code: "S-06"),
    ];
  }

  void _initializeArguments() {
    final args = Get.arguments;
    if (args != null) {
      association = args["association"];
      individual = args["individual"];
      company = args["company"];
      setAccountInfo();
    }
  }

  void setAccountInfo() {
    if (association?.associationInfo != null) {
      _updateAccountInfo(
        logo: association!.associationInfo!.accountLogo,
        nameArabic: association!.associationInfo!.accountNameArabic,
        nameEnglish: association!.associationInfo!.accountName,
      );
    } else if (individual?.accountInfo != null) {
      _updateAccountInfo(
        logo: individual!.accountInfo!.photo,
        nameArabic:
        "${individual!.accountInfo?.firstNameArabic ?? ""} ${individual!.accountInfo?.lastNameArabic ?? ""}",
        nameEnglish:
        "${individual!.accountInfo?.firstName ?? ""} ${individual!.accountInfo?.lastName ?? ""}",
      );
    } else if (company?.accountInfo != null) {
      _updateAccountInfo(
        logo: company!.accountInfo!.accountLogo,
        nameArabic: company!.accountInfo!.accountNameArabic,
        nameEnglish: company!.accountInfo!.accountName,
      );
    }
  }

  void _updateAccountInfo({String? logo, String? nameArabic, String? nameEnglish}) {
    this.logo = logo ?? "";
    name.value = Utils.isArabic ? (nameArabic ?? "") : (nameEnglish ?? "");
  }

  void navigateToScreen(String code) {
    final routes = {
      "S-01": AppRoutes.notificationPreferenceScreen,
      "S-02": AppRoutes.languageScreen,
      "S-03": AppRoutes.accountDeletionScreen,
      "S-04": AppRoutes.passwordSecurityScreen,
      "S-05": AppRoutes.donationReminderScreen,
      "S-06": AppRoutes.projectAlertsScreen,
    };

    final route = routes[code];
    if (route != null) {
      Get.toNamed(route)?.then((_) {
        if (code == "S-02") {
          setAccountInfo();
        }
      });
    }
  }

  @override
  void onClose() {
    name.close();
    super.onClose();
  }

}