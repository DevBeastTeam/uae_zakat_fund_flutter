import 'package:flutter/cupertino.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/faq_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class FaqPreviewViewModel extends ModulePermissionsViewModel {

  final title = TextEditingController();
  final titleArabic = TextEditingController();
  final category = TextEditingController();
  final answer = TextEditingController();
  final answerArabic = TextEditingController();

  final FaqRepoImpl repo = FaqRepoImpl();
  List<FaqCategory> cats = [];

  @override
  void onInit() {
    Future.microtask(()=> fetchFAQCategories());
    super.onInit();
  }


  Future fetchFAQCategories() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
    await repo.fetchFAQCategories(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      cats = apiResponse.data;
      fetchFaqDetails();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.hideLoadingDialog();
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  fetchFaqDetails() async {
    ApiResponse apiResponse = await repo.fetchFaqDetails(
        request: RequestBody(
            endPoint: "${ApiConstant.faqDetails}/${request?.entityId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if(apiResponse.data.isEmpty){
        return;
      }
      FaQs faq = apiResponse.data[0];
      isAdmin.value = (request?.status == 1 && user.isAdmin);
      title.text =faq.question;
      titleArabic.text = faq.questionArabic;
      answer.text = faq.answer;
      answerArabic.text = faq.answerArabic;
      FaqCategory cat = cats.firstWhere((question)=>question.categoryId==faq.categoryId);
      category.text = Utils.isArabic?cat.titleArabic:cat.title;
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    title.dispose();
    titleArabic.dispose();
    category.dispose();
    answer.dispose();
    answerArabic.dispose();
    super.onClose();
  }

}
