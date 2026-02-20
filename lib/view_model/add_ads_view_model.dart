import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/ads.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/ads_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/ads_management_view_model.dart';
import 'package:zakat_fund/widgets/pop_up.dart';

class AddAdsViewModel extends GetxController with GenericMixin {
  final titleInEnglish = TextEditingController();
  final titleInArabic = TextEditingController();
  final descInEnglish = TextEditingController();
  final descInArabic = TextEditingController();
  final publishDateTime = TextEditingController();
  final expiryDateTime = TextEditingController();
  final duration = TextEditingController();
  final iconController = TextEditingController();
  final imageController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final titleInEnglishNode = FocusNode();
  final titleInArabicNode = FocusNode();
  final descInEnglishNode = FocusNode();
  final descInArabicNode = FocusNode();
  final durationNode = FocusNode();

  Ads? ads;
  late User user;

  Rxn selectedType = Rxn<String>();
  Rxn selectedLanguage = Rxn<String>();
  Rxn selectedCloseButton = Rxn<String>();
  Rxn selectedPosition = Rxn<String>();

  Rxn selectedBannerTextColor = Rxn<String>();

  DateTime? selectedPublishDate, selectedExpiryDate;
  TimeOfDay? selectedPublishTime, selectedExpiryTime;

  final genericRepo = GenericRepoImpl();
  final repo = AdsRepoImpl();
  final adsViewModel = AdsManagementViewModel();

  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    user = userBox.getAt(0);
    ads = Get.arguments;
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: descInEnglishNode, displayArrows: false),
      KeyboardActionsItem(focusNode: descInArabicNode, displayArrows: false),
      KeyboardActionsItem(focusNode: durationNode, displayArrows: false),
    ];
    if (ads == null) {
      selectedBannerTextColor.value = "#000000";
      selectedType.value = "banner";
      selectedCloseButton.value = "yes";
      selectedPosition.value = "center";
      selectedLanguage.value = Utils.isArabic ? "arabic" : "english";
    } else {
      setData();
    }
    Utils.logEvent(
        name: ads != null
            ? EventConstant.updateAdScreen
            : EventConstant.addNewAdScreen);
  }

  setData() {
    if (ads?.adType == 1) {
      selectedType.value = "banner";
      selectedBannerTextColor.value = ads?.bannerTextColor;
    } else {
      selectedType.value = "popUp";
      duration.text = ads!.displayDuration.toString();
      if (ads!.popupCloseButton != null) {
        selectedCloseButton.value = ads!.popupCloseButton! ? "yes" : "no";
      }

      selectedPosition.value = ads!.popupPosition == 1 ? "center" : "top";
      iconController.text = ads!.icon ?? "";
      imageController.text = ads!.adsImage ?? "";
    }
    selectedLanguage.value = ads?.adLanguage == 1 ? "english" : "arabic";
    titleInEnglish.text = ads?.adTitleEn;
    titleInArabic.text = ads?.adTitleAr ?? "";
    descInEnglish.text = ads?.adDetailEn;
    descInArabic.text = ads?.adDetailAr ?? "";
    if (ads?.publicScheduleTime != null) {
      publishDateTime.text =
          Utils.dateTimeFormat.format(ads!.publicScheduleTime!);
    }
    if (ads?.expiryDate != null) {
      expiryDateTime.text = Utils.dateTimeFormat.format(ads!.expiryDate!);
    }
  }

  dateTimePicker({bool expiry = false}) async {
    final DateTime now = DateTime.now();
    DateTime? selectedDateTime = await Utils.datePickerDialog(
      initialDate: now,
      lastDate: DateTime(now.year + 10),
      firstDate: now,
    );
    if (expiry) {
      selectedExpiryDate = selectedDateTime;
    } else {
      selectedPublishDate = selectedDateTime;
    }
    TimeOfDay? time = await Utils.timePickerDialog();
    if (time != null) {
      String formatTime = Utils.formatDateAndTime(selectedDateTime!, time);
      if (expiry) {
        if (Utils.isDateAfter(formatTime)) {
          selectedExpiryTime = time;
          expiryDateTime.text = formatTime;
        }
      } else {
        if (Utils.isDateAfter(formatTime)) {
          selectedPublishTime = time;
          publishDateTime.text = formatTime;
        }
      }
    }
  }

  Future saveAds({bool saveAsDraft = false, bool isPreview = false}) async {
    String titleEnglish = titleInEnglish.text.trim();
    String titleArabic = titleInArabic.text.trim();
    if (!saveAsDraft && !isPreview) {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (selectedType.value == "banner") {
        if (selectedBannerTextColor.value == null) {
          Utils.showGlobalSnackBar(
              message: "${"bannerTextColor".tr} ${"isRequired".tr}");
          return;
        }
      }
    } else {
      if (Utils.isWidgetVisible(titleInEnglishNode.context!) &&
          titleEnglish.isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInEnglishNode);
        return;
      }

      if (Utils.isWidgetVisible(titleInArabicNode.context!) &&
          titleArabic.isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"titleInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(titleInArabicNode);
        return;
      }
    }
    if (isPreview) {
      _showPreview();
      return;
    }
    String? publishDate, expiryDate;
    DateTime? parsedPublishDate, parseExpiryDate;
    if (publishDateTime.text.isNotEmpty) {
      parsedPublishDate = Utils.dateTimeFormat.parse(publishDateTime.text);
      publishDate = Utils.outputFormat.format(parsedPublishDate.toUtc());
    }

    if (expiryDateTime.text.isNotEmpty) {
      parseExpiryDate = Utils.dateTimeFormat.parse(expiryDateTime.text);
      expiryDate = Utils.outputFormat.format(parseExpiryDate.toUtc());
    }

    if (parsedPublishDate != null && parseExpiryDate != null) {
      if (parsedPublishDate.isAfter(parseExpiryDate)) {
        Utils.showGlobalSnackBar(message: "futureDate".tr);
        return;
      }
    }
    if (parseExpiryDate != null && parseExpiryDate.isBefore(DateTime.now())) {
      Utils.showGlobalSnackBar(message: "futureDate".tr);
      return;
    }
    Utils.showLoadingDialog();

    final isBanner = selectedType.value == "banner";
    final isEnglish = selectedLanguage.value == "english";
    final shouldIncludeId = ads != null && ads?.requestStatus != 8;

    final body = <String, dynamic>{
      if (shouldIncludeId) "id": ads?.id,
      "adType": isBanner ? 1 : 2,
      "adTitleEN": titleEnglish,
      "adTitleAR": titleArabic,
      "adLanguage": isEnglish ? 1 : 2,
      "adDetailEN": descInEnglish.text,
      "adDetailAR": descInArabic.text,
      "expiryDate": expiryDate,
      "status": ads?.status ?? 1,
      "publicScheduleTime": publishDate,
      if (!isBanner) ...{
        "popupCloseButton": selectedCloseButton.value == "yes",
        "popupPosition": selectedPosition.value == "center" ? 1 : 2,
        "icon": iconController.text,
        if (imageController.text.isNotEmpty) "adsImage": imageController.text,
        "displayDuration": duration.text,
      },
      if (isBanner) "bannerTextColor": selectedBannerTextColor.value,
    };

    if (saveAsDraft) {
      _saveAsDraft(body);
    } else {
      _submitAds(body);
    }
  }

  _showPreview() {
    Ads ad = Ads(
      id: 0,
      isActive: false,
      adType: selectedType.value == "banner" ? 1 : 2,
      adTitleEn: titleInEnglish.text,
      adTitleAr: titleInArabic.text,
      adLanguage: selectedLanguage.value == "english" ? 1 : 2,
      adDetailEn: descInEnglish.text,
      adDetailAr: descInArabic.text,
      popupCloseButton: selectedCloseButton.value == "yes",
      popupPosition: selectedPosition.value == "center" ? 1 : 2,
      icon: selectedType.value != "banner" ? iconController.text : "",
      displayDuration: duration.text,
      status: 1,
      bannerBackgroundColor: null,
      bannerTextColor: selectedBannerTextColor.value ?? "",
      requestStatus: 1,
      adsImage: selectedType.value != "banner" ? imageController.text : "",
    );
    Navigator.of(
      Get.context!,
    ).push(
      PageRouteBuilder(
        opaque: false,
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => PopUpDialog(
          ads: ad,
        ),
      ),
    );
  }

  _submitAds(body) async {
    Map<String, dynamic>? queryParameters;
    if (ads != null && ads?.requestStatus == 8) {
      queryParameters = {
        "draftId": ads?.id,
      };
      ApiResponse apiResponse1 = await genericRepo.updateDraft(
          request: RequestBody(queryParameters: queryParameters));
      if (apiResponse1.appState != AppState.onSuccess) {
        Utils.hideLoadingDialog();
        Utils.handleAPIError(apiResponse1);
        return;
      }
    }

    if (ads != null) {
      queryParameters = {
        "resubmitForApproval": ads?.requestStatus == 7,
      };
    }

    ApiResponse apiResponse = ads == null || ads?.requestStatus == 8
        ? await repo.addAds(request: RequestBody(body: body))
        : await repo.updateAds(
            request: RequestBody(
                body: body,
                endPoint: "${ApiConstant.updateAds}/${ads!.id}",
                queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message: ads != null
              ? "adUpdatedSuccessfully".tr
              : "adAddedSuccessfully".tr);
      if (ads != null) {
        adsViewModel.pageSize = adsViewModel.ads.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _saveAsDraft(body) async {
    Map<String, dynamic>? queryParameters;
    if (ads != null) {
      queryParameters = {
        "draftId": ads?.id,
      };
    }
    var draftBody = {
      "userId": user.id,
      "draftType": 16,
      "draftJson": jsonEncode(body),
      if (ads != null) "draftId": ads?.id
    };
    ApiResponse apiResponse = await genericRepo.saveAsDraft(
        request:
            RequestBody(body: draftBody, queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
      if (ads != null) {
        adsViewModel.pageSize = adsViewModel.ads.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  addImage({bool icon = false}) async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      File file = File(image.path);
      Utils.showLoadingDialog();
      final result = await uploadImage(filePath: file.path);
      Utils.hideLoadingDialog();
      if (result != null) {
        if (icon) {
          iconController.text = result;
        } else {
          imageController.text = result;
        }
      }
    }
  }

  onChangeType(String value) => selectedType.value = value;

  onChangeLanguage(String value) => selectedLanguage.value = value;

  String getTitle() => ads != null ? "editAds" : "adsDetails";

  @override
  void onClose() {
    titleInEnglish.dispose();
    titleInArabic.dispose();
    descInEnglish.dispose();
    descInArabic.dispose();
    publishDateTime.dispose();
    expiryDateTime.dispose();
    duration.dispose();
    iconController.dispose();
    imageController.dispose();

    titleInEnglishNode.dispose();
    titleInArabicNode.dispose();
    descInEnglishNode.dispose();
    descInArabicNode.dispose();
    durationNode.dispose();

    selectedType.close();
    selectedLanguage.close();
    selectedCloseButton.close();
    selectedPosition.close();
    selectedBannerTextColor.close();

    super.onClose();
  }
}
