import 'package:get/get.dart';
import 'package:zakat_fund/view_model/account_deletion_view_model.dart';

class AccountDeletionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountDeletionViewModel());
  }
}
