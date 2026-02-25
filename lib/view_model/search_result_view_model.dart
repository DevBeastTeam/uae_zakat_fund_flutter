import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/search_results.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class SearchResultViewModel extends GetxController with GetTickerProviderStateMixin, GenericMixin {
  late TabController tabController;
  final genericRepo = GenericRepoImpl();
  RxList<SearchResults> searchResults = <SearchResults>[].obs;
  late String searchText;
  final dateFormat = DateFormat("MMMM dd, yyyy", Get.locale?.languageCode);

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.globalSearchResultScreen);
    searchText = Get.arguments;
    tabController = TabController(vsync: this, length: AppConstant.searchResultTabs.length);
    tabController.addListener(_tabListener);
    searchData();
  }

  _tabListener(){
    if (!tabController.indexIsChanging) {
      searchData();
    }
  }

  Future searchData() async {
    searchResults.clear();
    Utils.showLoadingDialog();
    Map<String, dynamic>? queryParameters = {
      "pageNumber": 1,
      "pageSize": 10,
      "category": TranslationService()
          .keys['en']![AppConstant.searchResultTabs[tabController.index]]!,
      "searchText": searchText,
    };
    ApiResponse apiResponse = await genericRepo.fetchSearchResults(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      searchResults.value = List<SearchResults>.from(baseApiModel.data.map((x) => SearchResults.fromJson(x)));
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  openDetails(SearchResults result) {
    switch (result.category) {
      case "Association":
        Get.toNamed(AppRoutes.associationDetailsScreen,
            arguments: result.itemId);
      case "Projects":
        Get.toNamed(
          AppRoutes.projectDetailsScreen,
          arguments: {
            "projectId": result.itemId,
            "isPreview": false,
          },
        );
      case "Services":
        serviceDetails(result.itemId);
      case "News":
        Get.toNamed(AppRoutes.newsDetailScreen,
            arguments: {"id": result.itemId});
      case "FAQ":
        Get.toNamed(AppRoutes.faqScreen);
      case "Documents":
        String file = result.itemUrl;
        if(Utils.isImageFile(file)){
          Get.toNamed(AppRoutes.photoViewScreen,arguments: file);
          return;
        }
        Utils.openUrl("${FlavorConfig.storageUrl}$file");
    }
  }

  serviceDetails(int id) async {
    Utils.showLoadingDialog();
    final result = await getServiceDetails(id);
    Utils.hideLoadingDialog();
    if(result!=null){
      OurServices service = result;
      Get.toNamed(AppRoutes.serviceDetails, arguments: {"service": service});
    }
  }

  @override
  void onClose() {
    tabController.removeListener(_tabListener);
    tabController.dispose();
    searchResults.close();
    super.onClose();
  }

}
