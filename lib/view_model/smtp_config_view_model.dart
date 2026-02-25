import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/smtp_config.dart';
import 'package:zakat_fund/repository/smtp_config_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class SMTPConfigViewModel extends GetxController {
  final hostController = TextEditingController();
  final portController = TextEditingController();
  final accountEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final encKeyController = TextEditingController();
  final contactUsEmailController = TextEditingController();
  final senderController = TextEditingController();
  final bccSenderController = TextEditingController();
  final vipEmailController = TextEditingController();
  final logoPathController = TextEditingController();
  final apiPathController = TextEditingController();

  Rxn selectedEnabled = Rxn<String>();

  final portNode = FocusNode();

  RxBool showPassword = true.obs;

  final repo = SmtpConfigRepoImpl();

  List<SmtpConfig> smtpConfig = [];

  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.emailSMTPScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: portNode, displayArrows: false)
    ];
    fetchSMTPConfig();
  }

  updateShowPassword() {
    showPassword.value = !showPassword.value;
  }

  fetchSMTPConfig() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.smtpConfig(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      smtpConfig = apiResponse.data;
      hostController.text = smtpConfig[0].value;
      portController.text = smtpConfig[1].value;
      accountEmailController.text = smtpConfig[2].value;
      passwordController.text = smtpConfig[3].value;
      encKeyController.text = smtpConfig[4].value;
      contactUsEmailController.text = smtpConfig[5].value;
      senderController.text = smtpConfig[6].value;
      bccSenderController.text = smtpConfig[7].value;
      vipEmailController.text = smtpConfig[8].value;
      logoPathController.text = smtpConfig[10].value;
      apiPathController.text = smtpConfig[11].value;
      selectedEnabled.value = smtpConfig[8].value == "1" ? "yes" : "no";
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  saveSMTPConfig() async {
    smtpConfig[0].value = hostController.text;
    smtpConfig[1].value = portController.text;
    smtpConfig[2].value = accountEmailController.text;
    smtpConfig[3].value = passwordController.text;
    smtpConfig[4].value = encKeyController.text;
    smtpConfig[5].value = contactUsEmailController.text;
    smtpConfig[6].value = senderController.text;
    smtpConfig[7].value = bccSenderController.text;
    smtpConfig[8].value = vipEmailController.text;
    smtpConfig[9].value = selectedEnabled.value == "yes" ? "1" : "0";
    smtpConfig[10].value = logoPathController.text;
    smtpConfig[11].value = apiPathController.text;
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.addSMTPConfig(
        request: RequestBody(body: jsonEncode(smtpConfig)));
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
    hostController.dispose();
    portController.dispose();
    accountEmailController.dispose();
    passwordController.dispose();
    encKeyController.dispose();
    contactUsEmailController.dispose();
    senderController.dispose();
    bccSenderController.dispose();
    vipEmailController.dispose();
    logoPathController.dispose();
    apiPathController.dispose();

    portNode.dispose();

    selectedEnabled.close();
    showPassword.close();
    super.onClose();
  }

}
