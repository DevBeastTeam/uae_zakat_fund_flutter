import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_group_view_model.dart';

class AddGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddGroupViewModel());
  }
}
