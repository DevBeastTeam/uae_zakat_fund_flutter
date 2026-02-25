import 'package:get/get.dart';
import 'package:zakat_fund/view_model/about_association_view_model.dart';

class AboutAssociationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AboutAssociationViewModel());
  }
}