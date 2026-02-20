import 'package:get/get.dart';
import 'package:zakat_fund/view_model/user_doc_view_model.dart';

class UserDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserDocumentsViewModel());
  }
}
