import 'package:get/get.dart';
import 'package:zakat_fund/view_model/media_center_view_model.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MediaCenterViewModel());
  }
}
