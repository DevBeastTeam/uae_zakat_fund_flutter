import 'package:get/get.dart';
import 'package:zakat_fund/view_model/favourite_view_model.dart';

class FavouriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavouriteViewModel());
  }
}
