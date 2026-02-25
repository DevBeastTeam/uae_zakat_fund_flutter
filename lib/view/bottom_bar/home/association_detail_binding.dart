import 'package:get/get.dart';
import 'package:zakat_fund/view_model/association_detail_view_model.dart';

class AssociationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AssociationDetailViewModel());
  }
}
