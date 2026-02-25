import 'package:get/get.dart';
import 'package:zakat_fund/view_model/group_details_view_model.dart';

class GroupDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RecipientDetailsViewModel());
  }
}
