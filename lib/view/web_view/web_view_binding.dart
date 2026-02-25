import 'package:get/get.dart';
import 'package:zakat_fund/view_model/web_view_model.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WebViewModel(title: "",url: ""));
  }
}
