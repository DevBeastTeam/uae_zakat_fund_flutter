import 'package:get/get.dart';
import 'package:zakat_fund/view_model/contact_us_view_model.dart';

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ContactUsViewModel());
  }
}
