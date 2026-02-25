import 'package:get/get.dart';
import 'package:zakat_fund/view_model/photo_view_model.dart';

class PhotoViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PhotoViewModel());
  }
}
