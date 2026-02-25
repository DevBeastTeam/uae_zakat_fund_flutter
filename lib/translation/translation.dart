import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/translation/ar.dart';
import 'package:zakat_fund/translation/en.dart';

class TranslationService extends Translations {
  //static Locale? get locale => appLangBox.isEmpty?Get.deviceLocale:getSelectedLanguage();

  static Locale get locale {
    // First launch
    if (appLangBox.isEmpty) {
      final deviceLocale = Get.deviceLocale;

      if (deviceLocale != null &&
          deviceLocale.languageCode == 'ar') {
        return const Locale('ar');
      }

      // Default fallback
      return const Locale('en');
    }

    // User-selected language
    return getSelectedLanguage();
  }

  static const fallbackLocale = Locale('en');
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'ar': ar,
  };

  static Locale getSelectedLanguage(){
    int lang = appLangBox.getAt(0);
    return Locale(lang==1?"en":"ar");
  }

}