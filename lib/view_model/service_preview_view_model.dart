import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/faq.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class ServicePreviewViewModel extends ModulePermissionsViewModel with GenericMixin {

  int preIndex = -1;

  Rxn<OurServices> service = Rxn<OurServices>();

  final title = TextEditingController();
  final category = TextEditingController();
  final support = TextEditingController();
  final duration = TextEditingController();
  final fees = TextEditingController();

  RxList<FaQs> subFaqs = <FaQs>[].obs;

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
        await Future.wait([fetchServiceDetails(), fetchCategories()]);
      }finally{
        Utils.hideLoadingDialog();
      }
    });

  }

  Future fetchServiceDetails() async {
    final result = await getServiceDetails(request!.entityId);
    if(result!=null){
      service.value = result;
      isAdmin.value = (request?.status == 1) ? user.isAdmin : false;
      subFaqs.value = service.value!.faqs;
      title.text =
      Utils.isArabic ? service.value!.titleAr : service.value!.titleEn;
      support.text = Utils.isArabic
          ? service.value!.supportTitleAr ?? service.value!.supportTitleEn
          : service.value!.supportTitleEn;
      duration.text = Utils.isArabic
          ? service.value!.durationAr ?? service.value!.duration
          : service.value!.duration;
      fees.text = service.value!.serviceFee;
      if (categoriesList.isNotEmpty) {
        setCategory();
      }
    }
  }

  Future fetchCategories() async {
    final result = await getLookUpData(endPoint: ApiConstant.serviceCategories);
    if(result.isNotEmpty){
      categoriesList = result;
      if (service.value != null) {
        setCategory();
      }
    }
  }

  setCategory() {
      category.text = Utils.findLookupName(categoriesList, service.value?.serviceCategoryId);
  }

  @override
  void onClose() {
    title.dispose();
    category.dispose();
    support.dispose();
    duration.dispose();
    fees.dispose();

    subFaqs.close();
    service.close();

    super.onClose();
  }

}
