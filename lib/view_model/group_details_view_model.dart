import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/group_details.dart';
import 'package:zakat_fund/model/recipients_campaign.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/campaign_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/recipients_campaign_view_model.dart';

class RecipientDetailsViewModel extends GetxController {
  final searchController = TextEditingController();
  late RecipientsCampaign group;
  RxList<GroupDetails> recipients = <GroupDetails>[].obs;
  List<GroupDetails> allRecipients = [];
  final repo = CampaignRepoImpl();
  late bool canDelete;
  final recipientsViewModel = Get.find<RecipientsCampaignViewModel>();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    group = Get.arguments;
    canDelete = recipientsViewModel.canDelete;
    fetchDetails();
  }

  fetchDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.groupDetails(
        request:
            RequestBody(endPoint: "${ApiConstant.groupDetails}/${group.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allRecipients = apiResponse.data;
      recipients.value = List.from(allRecipients);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future deleteRecipient(GroupDetails recipient) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteGroupRecipients(
        request: RequestBody(body: jsonEncode([recipient.userId])));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      recipients.remove(recipient);
      recipients.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void filterRecipientByEmail() {
    String? requestId =
        searchController.text.trim().isNotEmpty ? searchController.text : null;
    List<GroupDetails> filterList = allRecipients.where((data) {
      bool matchesRequestId = searchController.text.trim().isEmpty ||
          data.email.toLowerCase().startsWith(requestId!.toLowerCase());
      return matchesRequestId;
    }).toList();
    recipients.value = filterList;
  }

  clearAllRecipients() => recipients.value = List.from(allRecipients);

  @override
  void onClose() {
    searchController.dispose();

    recipients.close();
    super.onClose();
  }
}
