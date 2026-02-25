import 'package:get/get.dart';
import 'package:zakat_fund/view_model/public_doc_view_model.dart';

class PublicDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PublicDocumentsViewModel());
  }
}
