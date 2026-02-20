import 'package:get/get.dart';
import 'package:zakat_fund/view_model/transaction_view_model.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionViewModel());
  }
}
