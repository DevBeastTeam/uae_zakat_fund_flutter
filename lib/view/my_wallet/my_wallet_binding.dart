import 'package:get/get.dart';
import 'package:zakat_fund/view_model/my_wallet_view_model.dart';

class MyWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyWalletViewModel());
  }
}
