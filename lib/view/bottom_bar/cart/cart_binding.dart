import 'package:get/get.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartViewModel());
  }
}
