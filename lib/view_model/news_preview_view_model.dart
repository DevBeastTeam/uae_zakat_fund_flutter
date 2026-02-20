import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/news.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class NewsPreviewViewModel extends ModulePermissionsViewModel with GenericMixin {
  final Rxn<News> news = Rxn<News>();
  final title = TextEditingController();
  final category = TextEditingController();
  final details = TextEditingController();

  List<LookupData> categoriesList = [];

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Future.microtask(() async {
      try{
        Utils.showLoadingDialog();
        await Future.wait([fetchNewsDetails(), fetchCategories()]);
      }finally{
        Utils.hideLoadingDialog();
      }
    });
  }

  Future fetchNewsDetails() async {
    final result = await getNewsDetails(request!.entityId);
    if(result!=null){
      news.value = result;
      isAdmin.value = (request?.status == 1 && user.isAdmin);
      title.text = Utils.isArabic ? news.value!.titleAr : news.value!.titleEn;
      details.text = news.value!.descriptionEn;
      if (categoriesList.isNotEmpty) setCategory();
    }
  }

  Future fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.newsCategories);
    if(result.isNotEmpty){
      categoriesList = result;
      if (news.value != null) setCategory();
    }
  }

  setCategory() {
    category.text = Utils.findLookupName(categoriesList, news.value?.newsCategoryId);
  }

  @override
  void onClose() {
    title.dispose();
    category.dispose();
    details.dispose();

    news.close();
    super.onClose();
  }

}
