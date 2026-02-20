import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/campaign.dart';
import 'package:zakat_fund/model/recipients.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/campaign_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class CampaignViewModel extends ModulePermissionsViewModel {

  final repo = CampaignRepoImpl();

  late CampaignDetails campaign;

  final campaignName = TextEditingController();
  final language = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final category = TextEditingController();
  final senderName = TextEditingController();
  final subject = TextEditingController();
  final detailsController = TextEditingController();

  Rxn details = Rxn<String>();

  RxList<Recipients> recipients = <Recipients>[].obs;

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Future.microtask(() async {
      try{
        Utils.showLoadingDialog();
        await Future.wait([fetchCampaignDetails(), fetchRecipients()]);
      }finally{
        Utils.hideLoadingDialog();
      }
    });
  }

  Future fetchCampaignDetails() async {
    ApiResponse apiResponse = await repo.fetchCampaignDetails(
        request: RequestBody(
            endPoint: "${ApiConstant.campaignDetails}/${request?.entityId}"));
    if (apiResponse.appState == AppState.onSuccess) {
      campaign = apiResponse.data;
      isAdmin.value = (request?.status == 1 && user.isAdmin);
      campaignName.text = campaign.campaignName;
      language.text = campaign.languageCode == 1 ? "english".tr : "arabic".tr;
      startDate.text = Utils.dateFormatAMPM.format(campaign.startDate);
      endDate.text = Utils.dateFormatAMPM.format(campaign.endDate);
      category.text = campaign.category == 1 ? "email".tr : "sms".tr;
      senderName.text = campaign.senderName;
      subject.text = campaign.subject;
      // details.value = campaign.campaignHtml;
      detailsController.text = campaign.description??"";
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchRecipients() async {
    ApiResponse apiResponse = await repo.fetchRecipients(
        request: RequestBody(
            endPoint: "${ApiConstant.recipients}/${request?.entityId}"));
    if (apiResponse.appState == AppState.onSuccess) {
      recipients.value = apiResponse.data;
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    campaignName.dispose();
    language.dispose();
    startDate.dispose();
    endDate.dispose();
    category.dispose();
    senderName.dispose();
    subject.dispose();
    detailsController.dispose();

    recipients.close();
    details.close();

    super.onClose();
  }

}
