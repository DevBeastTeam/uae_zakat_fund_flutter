import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/static_page.dart';
import 'package:zakat_fund/repository/static_page_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class StaticPageViewModel extends ModulePermissionsViewModel {

  final repo = StaticPageRepoImpl();

  final pageLinkController = TextEditingController();
  final pageNameController = TextEditingController();
  final parentPageController = TextEditingController();
  final pageSectionController = TextEditingController();
  final pageOrderController = TextEditingController();
  final pageLanguageController = TextEditingController();
  final pageTitleController = TextEditingController();

  Rxn<String> selectedLanguage = Rxn<String>();
  Rxn<StaticPage> staticPage = Rxn<StaticPage>();


  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    selectedLanguage.value = Utils.isArabic ? "arabic" : "english";
    Future.microtask(()=> fetchStaticPageDetails());
  }

  fetchStaticPageDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.staticPageDetails(
        request: RequestBody(
            endPoint: "${ApiConstant.staticPageDetails}/${request?.entityId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      staticPage.value = apiResponse.data;
      _setStaticPageData();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _setStaticPageData() {
    isAdmin.value = request?.status == 1 ? user.isAdmin : false;
    pageNameController.text = staticPage.value!.pageNameEN!;
    parentPageController.text = staticPage.value!.pageSection == 1
        ? Utils.headerParentPageIntoString(staticPage.value!.parentPage!)
        : Utils.footerParentPageIntoString(staticPage.value!.parentPage!);
    pageSectionController.text =
        staticPage.value!.pageSection == 1 ? "header".tr : "footer".tr;
    pageOrderController.text = staticPage.value!.pageOrder.toString();
    int? lang = staticPage.value?.pageLanguage;
    pageLanguageController.text = lang == 1 ? "english".tr : "arabic".tr;
      pageTitleController.text = Utils.isArabic
        ? staticPage.value!.pageTitleAR ?? ""
        : staticPage.value!.pageTitleEN ?? "";
    pageLinkController.text =
        "${FlavorConfig.webSiteUrl}page/${staticPage.value!.pageLink!}";
  }

  onChangeLanguage(String value){
    selectedLanguage.value = value;
    if (value == "english") {
      pageTitleController.text = staticPage.value!.pageTitleEN.toString();
    } else {
      pageTitleController.text = staticPage.value!.pageTitleAR.toString();
    }
  }

  showPreview(){
    Get.toNamed(AppRoutes.webViewScreen, arguments: {
      "title": Utils.isArabic
          ? staticPage.value!.pageTitleAR ??
          staticPage.value!.pageTitleEN
          : staticPage.value!.pageTitleEN,
      "isStaticPage": true,
      "url":
      '${FlavorConfig.webSiteUrl}page/${staticPage.value!.pageLink}?mobile=true&lang=${Utils.isArabic ? "ar" : "en"}'
    });
  }

  @override
  void onClose() {
    pageLinkController.dispose();
    pageNameController.dispose();
    parentPageController.dispose();
    pageSectionController.dispose();
    pageOrderController.dispose();
    pageLanguageController.dispose();
    pageTitleController.dispose();

    selectedLanguage.close();
    staticPage.close();
    super.onClose();
  }

}
