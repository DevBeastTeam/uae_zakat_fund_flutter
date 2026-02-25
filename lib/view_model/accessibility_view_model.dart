import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class AccessibilityViewModel extends GetxController {
  RxString fontSize = "A\n${"standard".tr}".obs;
  RxString colors = "normal".tr.obs;

  static const colorOptions = {
    0: 'normal',
    1: 'colorBlind',
    2: 'red',
    3: 'green',
    4: 'blue',
  };

  final fontSizeOptions = {
    0: 'A\n${'large'.tr}',
    1: 'A\n${'standard'.tr}',
  };

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.accessibilityScreen);

    _loadFontSizeFromBox();
    _loadColorFromBox();

    super.onInit();
  }

  void _loadFontSizeFromBox() {
    final index = fontSizeBox.isNotEmpty ? fontSizeBox.getAt(0) : 1;
    final key = fontSizeOptions[index] ?? fontSizeOptions[1]!;
    fontSize.value = key.tr;
  }

  void _loadColorFromBox() {
    final index = colorsBox.isNotEmpty ? colorsBox.getAt(0) : 0;
    final colorKey = colorOptions[index] ?? colorOptions[0]!;
    colors.value = colorKey.tr;
  }

  Future<void> changeColor(String label, int value) async {
    final translated = label.tr;
    if (translated == colors.value) return;
    colors.value = translated;
    await colorsBox.clear();
    colorsBox.add(value);
    Get.offAllNamed(AppRoutes.mainScreen);
  }

  Future<void> onFontSelected(int index) async {
    final key = fontSizeOptions[index] ?? fontSizeOptions[1]!;
    fontSize.value = key.tr;
    await fontSizeBox.clear();
    fontSizeBox.add(index);
  }

  @override
  void onClose() {
    fontSize.close();
    colors.close();

    super.onClose();
  }
}
