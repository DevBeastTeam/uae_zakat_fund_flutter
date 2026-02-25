import 'package:get/get.dart';
import 'package:zakat_fund/view_model/user_selection_view_model.dart';

class UserSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserSelectionViewModel());
  }
}
