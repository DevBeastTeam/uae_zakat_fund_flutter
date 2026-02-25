import 'package:get/get.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/web_view_model.dart';

class PaymentReceiptViewModel extends GetxController {
  late int type;
  ReceiptDetails? transactionDetails;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.confirmationPaymentScreen);
    var data = Get.arguments;
    type = data["type"];
    transactionDetails = data["transactionDetails"];
    Get.delete<WebViewModel>();
  }
}
