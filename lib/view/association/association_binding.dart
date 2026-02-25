import 'package:get/get.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';

class AssociationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AssociationViewModel());
  }
}
