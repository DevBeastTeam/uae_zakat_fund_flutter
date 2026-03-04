
# this is for ios policy issue

- 1. /Users/mac/Documents/flutter_projects/uae_zakat_fund_flutter/lib/view_model/settings_view_model.dart

added --> 
  void navigateToScreen(String code) {
    final routes = {
      "S-01": AppRoutes.notificationPreferenceScreen,
      "S-02": AppRoutes.languageScreen,
      "S-03": AppRoutes.accountDeletionScreen,
      "S-04": AppRoutes.passwordSecurityScreen,
      "S-05": AppRoutes.donationReminderScreen,
      "S-06": AppRoutes.projectAlertsScreen,
      "S-07": AppRoutes.webViewScreen,
    };

    if (code == "S-07") {
      Get.toNamed(AppRoutes.webViewScreen, arguments: {
        "title": "privacyPolicy".tr,
        "url":
            "${FlavorConfig.webSiteUrl}${Utils.isArabic ? 'ar' : 'en'}/privacy-policy"
      });
      return;
    }


////// 
2. /Users/mac/Documents/flutter_projects/uae_zakat_fund_flutter/lib/view/bottom_bar/account/guest_account_screen.dart

was removed --> 
  Widget build(BuildContext context) {
    final List<String> routes = [
      AppRoutes.faqScreen,
      AppRoutes.addFeedbackScreen,
      AppRoutes.accessibilityScreen,
      AppRoutes.settingsScreen,
    ];

added ----> 
    Categories(name: "privacyPolicy", icon: AppResources.securityIcon),
  ];
  final viewModel = Get.find<MainViewModel>();


 case 8:
        Get.toNamed(AppRoutes.webViewScreen, arguments: {
          "title": "privacyPolicy".tr,
          "url":
              "${FlavorConfig.webSiteUrl}${Utils.isArabic ? 'ar' : 'en'}/privacy-policy"
        });


