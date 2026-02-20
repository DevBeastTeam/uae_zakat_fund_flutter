import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/association_about_us.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/about_association_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class AboutUsViewModel extends ModulePermissionsViewModel {
  final Rxn<AssociationAboutUs> association = Rxn<AssociationAboutUs>();

  final titleEnglish = TextEditingController();
  final titleArabic = TextEditingController();
  final descriptionEnglish = TextEditingController();
  final descriptionArabic = TextEditingController();
  final beneficiaries = TextEditingController();
  final amountRaised = TextEditingController();
  final projectCompleted = TextEditingController();

  final repo = AboutAssociationRepoImpl();

  @override
  void onInit() {
    Future.microtask(() => fetchAboutAssociation());
    super.onInit();
  }

  fetchAboutAssociation() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.aboutAssociation(
        request: RequestBody(
            endPoint: "${ApiConstant.aboutAssociation}/${request?.entityId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      association.value = apiResponse.data;
      _setData();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _setData() {
    isAdmin.value = (request?.status == 1 && user.isAdmin);
    titleEnglish.text = association.value!.titleEn;
    titleArabic.text = association.value!.titleAr;
    descriptionEnglish.text = association.value!.descriptionEn;
    descriptionArabic.text = association.value!.descriptionAr;
    beneficiaries.text = association.value!.beneficiaries.toString();
    amountRaised.text = association.value!.amountRaised.toString();
    projectCompleted.text = association.value!.projectsCompleted.toString();
  }

  @override
  void onClose() {
    titleEnglish.dispose();
    titleArabic.dispose();
    descriptionEnglish.dispose();
    descriptionArabic.dispose();
    beneficiaries.dispose();
    amountRaised.dispose();
    projectCompleted.dispose();

    association.close();

    super.onClose();
  }
}
