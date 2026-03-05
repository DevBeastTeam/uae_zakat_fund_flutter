import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view/bottom_bar/account/guest_account_screen.dart';
import 'package:zakat_fund/view_model/accessibility_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AccessibilityScreen extends GetView<AccessibilityViewModel> {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "accessibility"),
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("fontSize"),
          8.verticalSpace,
          Obx(() => _buildToggleRow(
                items: [
                  (
                    controller.fontSizeOptions[0]!,
                    () => controller.onFontSelected(0)
                  ),
                  (
                    controller.fontSizeOptions[1]!,
                    () => controller.onFontSelected(1)
                  ),
                ],
                current: controller.fontSize.value,
              )),
          16.verticalSpace,
          ColorBlindScreen(),
          // _buildSectionTitle("colors"),
          // 8.verticalSpace,
          // Obx(() => _buildToggleRow(
          //   items: [
          //     ('normal'.tr, () => controller.changeColor("normal", 0)),
          //     ('colorBlind'.tr, () => controller.changeColor("colorBlind", 1)),
          //   ],
          //   current: controller.colors.value,
          // )),
          // 10.verticalSpace,
          // Obx(() => _buildToggleRow(
          //   items: [
          //     ('red'.tr, () => controller.changeColor("red", 2)),
          //     ('green'.tr, () => controller.changeColor("green", 3)),
          //   ],
          //   current: controller.colors.value,
          // )),
          // 16.verticalSpace,
          // Obx(() => _buildButton(
          //   label: 'blue'.tr,
          //   currentLabel: controller.colors.value,
          //   onPressed: () => controller.changeColor("blue", 4),
          // )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.tr,
      style: AppTextStyle.primaryDarkBlack16spTextStyle,
    );
  }

  Widget _buildToggleRow({
    required List<(String, VoidCallback)> items,
    required String current,
  }) {
    return Row(
      children: List.generate(items.length, (index) {
        final (label, onPressed) = items[index];
        return Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(right: index < items.length - 1 ? 10.w : 0),
            child: _buildButton(
              label: label,
              currentLabel: current,
              onPressed: onPressed,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildButton({
    required String label,
    required String currentLabel,
    required VoidCallback onPressed,
  }) {
    final isSelected = label == currentLabel;

    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            isSelected ? WidgetStatePropertyAll(themeViewModel.color) : null,
        fixedSize: WidgetStatePropertyAll(Size(Get.width, 64.h)),
        side: WidgetStatePropertyAll(
          BorderSide(width: 0.5.w, color: const Color(0xffD1D0D1)),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.darkGreyColor,
          fontSize: 16.sp,
          height: 0,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
