import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/fund_request.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/sahem_bank.dart';
import 'package:zakat_fund/repository/fund_request_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class FundsRequestPreviewViewModel extends ModulePermissionsViewModel {

  final formKey = GlobalKey<FormState>();

  final fundRepo = FundRequestRepoImpl();

  final donorName = TextEditingController();
  final availableAmount = TextEditingController();
  final requestedAmount = TextEditingController();
  final requestDate = TextEditingController();

  final banks = <String>[].obs;
  final selectedBank = Rxn<String>();

  List<SahemBank> sahemBanks = [];

  FundRequestDetails? details;


  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData()  {
    Future.microtask(() async {
      try{
        Utils.showLoadingDialog();
        await Future.wait([fetchSahemBanks(),fetchAssociationId()]);
      }finally{
        Utils.hideLoadingDialog();
      }
    });
  }

  Future fetchFundRequest(int id) async {
    ApiResponse apiResponse = await fundRepo.fetchFundRequest(
        request: RequestBody(
            endPoint:
                "${ApiConstant.fundRequestDetails}/$id/${request?.entityId}"));
    if (apiResponse.appState == AppState.onSuccess) {
      FundRequest fundRequest = apiResponse.data;
      donorName.text = Utils.isArabic
          ? fundRequest.associationNameAr
          : fundRequest.associationName;
      availableAmount.text =
          "${"currency".tr} ${fundRequest.availableAmount.toInt()}";
      requestedAmount.text =
          "${"currency".tr} ${fundRequest.requestedAmount.toInt()}";
      isAdmin.value = (request?.status == 1 && user.isAdmin);
      if (details!.sahemBankAccountId != null) {
        SahemBank? bank = sahemBanks
            .firstWhereOrNull((bank) => bank.id == details!.sahemBankAccountId);
        if (bank != null) {
          selectedBank.value =
          Utils.isArabic ? bank.bankNameArabic : bank.bankName;
        }
      }
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchAssociationId() async {
    ApiResponse apiResponse = await fundRepo.fetchAssociationId(
        request: RequestBody(
            endPoint: "${ApiConstant.fundTransferDetail}/${request?.entityId}"));
    if (apiResponse.appState == AppState.onSuccess) {
      details = apiResponse.data;
      if(banks.isNotEmpty){
        await fetchRequestDetails();
      }
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchSahemBanks() async {
    ApiResponse apiResponse = await fundRepo.fetchSahemBank(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      sahemBanks = apiResponse.data;
      banks.value = sahemBanks.map((bank) => bank.bankName).toList();
      banks.refresh();
      if(details!=null){
        await fetchRequestDetails();
      }
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchRequestDetails() async {
    await fetchFundRequest(details!.associationId);
  }

  @override
  void onClose() {
    donorName.dispose();
    availableAmount.dispose();
    requestedAmount.dispose();
    requestDate.dispose();

    banks.close();
    selectedBank.close();
    super.onClose();
  }

}
