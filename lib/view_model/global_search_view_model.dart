import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class GlobalSearchViewModel extends GetxController{
  final searchController = TextEditingController();

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.globalSearchScreen);
    super.onInit();
  }

  openSearchResultsScreen(String query){
    Get.toNamed(AppRoutes.searchResultScreen, arguments: query.tr);
  }

  onSearchQuery(String query){
    if (query.trim().isEmpty) {
      return;
    }
    Get.toNamed(AppRoutes.searchResultScreen, arguments: query);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

}