import 'package:get/get.dart';
import 'package:zakat_fund/view_model/transaction_request_view_model.dart';

class TransactionRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionRequestViewModel());
  }
}