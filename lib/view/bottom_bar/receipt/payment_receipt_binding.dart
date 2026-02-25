import 'package:get/get.dart';
import 'package:zakat_fund/view_model/payment_receipt_view_model.dart';

class PaymentReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PaymentReceiptViewModel());
  }
}
