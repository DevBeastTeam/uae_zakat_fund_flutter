import 'package:get/get.dart';
import 'package:zakat_fund/view_model/company_view_model.dart';

class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CompanyViewModel());
  }
}
