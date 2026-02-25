import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/association_about_us.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/about_association_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class AboutAssociationViewModel extends GetxController with GenericMixin {

  final titleInEnglish = TextEditingController();
  final titleInArabic = TextEditingController();
  final descInEnglish = TextEditingController();
  final descInArabic = TextEditingController();
  final beneficiaries = TextEditingController();
  final amountRaised = TextEditingController();
  final projectCompleted = TextEditingController();
  final firstImage = TextEditingController();
  final secondImage = TextEditingController();

  final descInEnglishNode = FocusNode();
  final descInArabicNode = FocusNode();
  final beneficiariesNode = FocusNode();
  final amountRaisedNode = FocusNode();
  final projectCompletedNode = FocusNode();

  var formKey = GlobalKey<FormState>();

  final repo = AboutAssociationRepoImpl();
  final genericRepo = GenericRepoImpl();

  late User user;
  List<AssociationAboutUs> aboutUs = [];
  RxBool showDraft = false.obs;
  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: descInEnglishNode),
      KeyboardActionsItem(focusNode: descInArabicNode),
      KeyboardActionsItem(focusNode: beneficiariesNode),
      KeyboardActionsItem(focusNode: amountRaisedNode),
      KeyboardActionsItem(focusNode: projectCompletedNode),
    ];
    user = userBox.getAt(0);
    fetchAboutUs();
  }

  addImage(TextEditingController controller) async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      File file = File(image.path);
      Utils.showLoadingDialog();
      String? result = await uploadImage(filePath: file.path);
      Utils.hideLoadingDialog();
      controller.text = result??"";
    }
  }

  Future fetchAboutUs() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.associationAboutUs(
        request: RequestBody(
            endPoint: "${ApiConstant.associationAboutUs}/${user.accountId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      aboutUs = apiResponse.data;
      _setAboutUsData();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _setAboutUsData(){
    if (aboutUs.isNotEmpty) {
      AssociationAboutUs about = aboutUs.first;
      titleInEnglish.text = about.titleEn;
      titleInArabic.text = about.titleAr;
      descInEnglish.text = about.descriptionEn;
      descInArabic.text = about.descriptionAr;
      if (about.beneficiaries != 0) {
        beneficiaries.text = "${about.beneficiaries}";
      }
      if (about.amountRaised != 0) {
        amountRaised.text = "${about.amountRaised}";
      }
      if (about.projectsCompleted != 0) {
        projectCompleted.text = "${about.projectsCompleted}";
      }

      firstImage.text = about.firstPicture;
      secondImage.text = about.secondPicture;

      if (about.requestStatus == 8) showDraft.value = true;
    } else {
      showDraft.value = true;
    }
    Utils.logEvent(
        name: aboutUs.isNotEmpty
            ? EventConstant.updateAboutAssociationScreen
            : EventConstant.addAboutAssociationScreen);
  }

  submitForReview({bool saveAdDraft = false}) async {
    if (!saveAdDraft && !formKey.currentState!.validate()) {
      return;
    }
    var body = {
      "titleEN": titleInEnglish.text,
      "descriptionEN": descInEnglish.text,
      "titleAR": titleInArabic.text,
      "descriptionAR": descInArabic.text,
      "firstPicture": firstImage.text,
      "secondPicture": secondImage.text,
      if (beneficiaries.text.isNotEmpty)
        "beneficiaries": int.parse(beneficiaries.text),
      if (amountRaised.text.isNotEmpty)
        "amountRaised": int.parse(amountRaised.text),
      if (projectCompleted.text.isNotEmpty)
        "projectsCompleted": int.parse(projectCompleted.text),
      "associationId": user.accountId,
      if (aboutUs.isNotEmpty) "id": aboutUs[0].id,
    };
    Utils.showLoadingDialog();
    if (saveAdDraft) {
      _saveAsDraft(body);
    } else {
      _submit(body);
    }
  }

  _saveAsDraft(Map<String, dynamic> body) async {
    Map<String, dynamic>? queryParameters;
    if (aboutUs.isNotEmpty) {
      queryParameters = {
        "draftId": aboutUs[0].id,
      };
    }
    var draftBody = {
      "userId": user.id,
      "accountId": user.accountId,
      "draftType": 4,
      "draftJson": jsonEncode(body),
      if (aboutUs.isNotEmpty) "draftId": aboutUs[0].id
    };
    ApiResponse apiResponse = await genericRepo.saveAsDraft(
        request:
            RequestBody(body: draftBody, queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
      Get.back();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future<void> _submit(Map<String, dynamic> body) async {
    Map<String, dynamic>? queryParameters;
    if (aboutUs.isNotEmpty && aboutUs[0].requestStatus == 8) {
      queryParameters = {
        "draftId": aboutUs[0].id,
      };
      ApiResponse apiResponse1 = await genericRepo.updateDraft(
          request: RequestBody(queryParameters: queryParameters));
      if (apiResponse1.appState != AppState.onSuccess) {
        Utils.hideLoadingDialog();
        Utils.handleAPIError(apiResponse1);
        return;
      }
    }

    if (aboutUs.isNotEmpty) {
      queryParameters = {
        "resubmitForApproval": aboutUs[0].requestStatus == 7,
      };
    }
    ApiResponse apiResponse = aboutUs.isEmpty || aboutUs[0].requestStatus == 8
        ? await repo.addAboutUs(request: RequestBody(body: body))
        : await repo.updateAboutUs(
            request: RequestBody(
                endPoint: "${ApiConstant.updateAboutUs}/${aboutUs[0].id}",
                body: body,
                queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    titleInEnglish.dispose();
    titleInArabic.dispose();
    descInEnglish.dispose();
    descInArabic.dispose();
    beneficiaries.dispose();
    amountRaised.dispose();
    projectCompleted.dispose();
    firstImage.dispose();
    secondImage.dispose();

    descInEnglishNode.dispose();
    descInArabicNode.dispose();
    beneficiariesNode.dispose();
    amountRaisedNode.dispose();
    projectCompletedNode.dispose();

    showDraft.close();

    super.onClose();
  }

}
