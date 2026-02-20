import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/survey.dart';
import 'package:zakat_fund/repository/survey_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class SurveyViewModel extends ModulePermissionsViewModel {

  final repo = SurveyRepoImpl();

  Rxn<Survey> survey = Rxn<Survey>();

  final TextEditingController surveyName = TextEditingController();
  final TextEditingController pageLink = TextEditingController();
  final TextEditingController responseLimit = TextEditingController();
  final TextEditingController language = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    Future.microtask(()=> fetchSurveyDetails());
  }


  fetchSurveyDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.fetchSurveyDetails(
        request: RequestBody(
            endPoint: "${ApiConstant.surveyDetails}/${request?.entityId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      survey.value = apiResponse.data;
      _setSurveyData();
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  _setSurveyData(){
    isAdmin.value = request?.status == 1 ? user.isAdmin : false;
    surveyName.text = survey.value!.surveyName;
    pageLink.text = survey.value!.pageLink;
    responseLimit.text = "${survey.value!.responseLimit}";
    language.text = survey.value!.languageCode == 1 ? "english".tr : "arabic".tr;
  }


  @override
  void onClose() {
    surveyName.dispose();
    pageLink.dispose();
    responseLimit.dispose();
    language.dispose();

    survey.close();
    super.onClose();
  }

}
