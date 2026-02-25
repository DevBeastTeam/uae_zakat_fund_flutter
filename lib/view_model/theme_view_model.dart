import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

class ThemeViewModel extends GetxController {

  List<ThemeData> themes = [];

  @override
  void onInit() {
    themes = [
      createTheme(AppColors.brownPrimaryColor),
      createTheme(AppColors.brownPrimaryColor),
      createTheme(Colors.grey.shade700),
      createTheme(const Color(0xFFE78BC4)),
      createTheme(const Color(0xFF405E8F)),
      createTheme(const Color(0xFF7DE4D3)),
    ];
    super.onInit();
  }

  ThemeData createTheme(Color primaryColor) {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brownPrimaryColor),
      fontFamily: "Roboto",
      useMaterial3: true,
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.transparent,
      ),
    );
  }

  ThemeData get currentTheme => themes[colorsBox.isEmpty?0:colorsBox.getAt(0)];

  Color get color => currentTheme.primaryColor;

}
