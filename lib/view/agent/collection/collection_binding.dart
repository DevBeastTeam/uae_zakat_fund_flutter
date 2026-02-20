import 'package:get/get.dart';
import 'package:zakat_fund/view_model/collection_view_model.dart';

class CollectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CollectionViewModel());
  }
}
