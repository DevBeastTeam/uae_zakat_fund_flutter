import 'package:get/get.dart';
import 'package:zakat_fund/view_model/transfer_queue_view_model.dart';

class TransferQueueBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransferQueueViewModel());
  }
}
