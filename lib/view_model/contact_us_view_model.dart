import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/smtp_config.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/smtp_config_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class ContactUsViewModel extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  final messageNode = FocusNode();
  RxInt index = 0.obs;

  final genericRepo = GenericRepoImpl();
  final repo = SmtpConfigRepoImpl();
  var formKey = GlobalKey<FormState>();
  late List<KeyboardActionsItem> keyboardActionsItem;
  List<SmtpConfig> contactUs = [];
  RxString email = "".obs;
  RxString address = "".obs;
  String addressApiUrl = "";
  RxString phoneNumber = "".obs;
  RxString youtube = "".obs;
  RxString twitter = "".obs;
  RxString instagram = "".obs;
  RxString facebook = "".obs;

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.contactUsScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: messageNode, displayArrows: false),
    ];
    if (userBox.isNotEmpty) {
      User user = userBox.getAt(0);
      emailController.text = user.email ?? "";
      phoneController.text = user.mobile ?? '';
      nameController.text = Utils.isArabic
          ? "${user.firstNameArabic} ${user.lastNameArabic}"
          : "${user.firstName} ${user.lastName}";
    }
    super.onInit();
  }

  Future sendContactUs(Project? association) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.showLoadingDialog();
    var body = {
      "email": emailController.text,
      "name": nameController.text,
      "message": messageController.text,
      if (association != null) ...{
        "associationId": association.accountId,
        "associationEmail": association.email,
        "associationName": association.accountName,
        "associationNameAr": association.accountNameArabic,
      }
    };
    ApiResponse apiResponse =
        await genericRepo.sendContactUs(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchContactUs() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.getContactUs(request: RequestBody());
    Utils.hideLoadingDialog();

    if (apiResponse.appState == AppState.onSuccess) {
      contactUs = apiResponse.data;
      log("👉🏻 contactUs: ${contactUs.map((e) => "${e.key}: ${e.value}").toList()}");
      for (SmtpConfig config in contactUs) {
        switch (config.key) {
          case "Email":
            email.value = config.value;
            break;
          case "PhoneNumber":
            phoneNumber.value = config.value;
            break;
          case "Address":
            address.value = config.value;
            break;
          case "AddressApiURL":
            addressApiUrl = config.value;
            break;
          case "YouTube":
            youtube.value = config.value;
            break;
          case "Twitter":
            twitter.value = config.value;
            break;
          case "Instagram":
            instagram.value = config.value;
            break;
          case "Facebook":
            facebook.value = config.value;
            break;
        }
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void setContactInfoFromAssociation(Project association) {
    email.value = association.email;
    address.value =
        Utils.isArabic ? association.addressArabic : association.address;
    phoneNumber.value = association.mobile;
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    messageController.dispose();
    messageNode.dispose();

    email.close();
    address.close();
    phoneNumber.close();
    youtube.close();
    twitter.close();
    instagram.close();
    facebook.close();

    super.onClose();
  }
}
