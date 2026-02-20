import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/ads.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/ads_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class AdViewModel extends ModulePermissionsViewModel {
  late String title;

  final AdsRepoImpl repo = AdsRepoImpl();
  final accountViewModel = Get.find<AccountViewModel>();

  final Rxn<Ads> ads = Rxn<Ads>();

  final adTypeController = TextEditingController();
  final titleController = TextEditingController();
  final languageController = TextEditingController();
  final expiryDateController = TextEditingController();
  final publishTimeController = TextEditingController();
  final detailsController = TextEditingController();
  final durationController = TextEditingController();
  final popUpCloseController = TextEditingController();
  final popUpPositionController = TextEditingController();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    var data = Get.arguments;
    title = data["title"];
    Future.microtask(()=> fetchAdDetails());

  }

  fetchAdDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.adDetails(
        request: RequestBody(endPoint: "${ApiConstant.adDetails}/${request?.entityId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      ads.value = apiResponse.data;
      _setAdsData();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _setAdsData(){
    isAdmin.value = (request?.status == 1 && user.isAdmin);

    int? lang = ads.value?.adLanguage;
    adTypeController.text = ads.value?.adType == 1 ? "banner".tr : "popUp".tr;
    titleController.text = lang == 1 ? ads.value?.adTitleEn : ads.value?.adTitleAr;
    languageController.text = lang == 1 ? "english".tr : "arabic".tr;
    if (ads.value!.expiryDate != null) {
      expiryDateController.text = Utils.dateFormatAMPM.format(ads.value!.expiryDate!);
    }
    if (ads.value!.publicScheduleTime != null) {
      publishTimeController.text = Utils.dateFormatAMPM.format(ads.value!.publicScheduleTime!);
    }
    detailsController.text = lang == 1 ? ads.value?.adDetailEn : ads.value?.adDetailAr;
    if (ads.value?.adType == 2) {
      durationController.text = ads.value!.displayDuration.toString();
      if (ads.value!.popupCloseButton != null) {
        popUpCloseController.text = ads.value!.popupCloseButton! ? "yes".tr : "no".tr;
      }
      popUpPositionController.text = ads.value!.popupPosition == 1 ? "center".tr : "top".tr;
    }
  }

  String getTitle() {
    if (request?.requestType == "Popup" ||
        request?.requestType == "Popup Update") {
      return "popUpAdPreview";
    }
    return "bannerAdPreview";
  }

  @override
  void onClose() {
    adTypeController.dispose();
    titleController.dispose();
    languageController.dispose();
    expiryDateController.dispose();
    publishTimeController.dispose();
    detailsController.dispose();
    durationController.dispose();
    popUpCloseController.dispose();
    popUpPositionController.dispose();

    ads.close();

    super.onClose();
  }

}
