import 'package:get/get.dart';
import 'package:zakat_fund/view_model/all_companies_view_model.dart';

class AllCompaniesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllCompaniesViewModel());
  }
}
