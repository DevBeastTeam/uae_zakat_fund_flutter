import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/uae_role_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/footer.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';

class RoleLinkScreen extends GetView<UaeRoleViewModel> {
  const RoleLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogo(),
            _buildTitle(),
            if (controller.user!.roles.contains("Individuals"))
              buildCheckboxListTile("donor", 0),
            if (controller.associationsList.isNotEmpty)
              buildCheckboxListTile("association", 1),
            if (controller.companiesList.isNotEmpty)
              buildCheckboxListTile("company", 2),
            20.verticalSpace,
            elevatedButton(text: "login", onPressed: () => controller.logIn()),
            16.verticalSpace,
            elevatedIconButton(
              text: "back",
              next: false,
              backgroundColor: AppColors.lightGreyColor,
              onPressed: () => controller.onBackPressed(),
            ),
            16.verticalSpace,
            buildFooter(),
          ],
        ),
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      "selectAccountToLogIn".tr,
      style: AppTextStyle.primaryDarkBrown24spTextStyle1,
    );
  }

  Widget _buildLogo() {
    return controller.isUaePass
        ? Image.asset(
            AppResources.uaeThumb,
            width: 96.w,
            height: 92.h,
          )
        : Center(
            child: SvgPicture.asset(
              AppResources.awqafSVGLogo,
              height: 120.h,
            ),
          );
  }

  Widget buildCheckboxListTile(String title, int index) {
    return Obx(() => CheckboxListTile(
          splashRadius: 20.r,
          title: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: AppColors.primaryDarkGreyColor),
                  borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.tr, style: AppTextStyle.black20spTextStyle),
                  8.verticalSpace,
                  if (index == 1)
                    Obx(() => LabelDropDown(
                      items: controller.associationsList,
                      selectedValue: controller.selectedAssociation.value,
                      onChanged: (val) {
                        controller.selectedRole.value = 1;
                        controller.selectedAssociation.value = val;
                      },
                      label: "",
                      showLabel: false,
                    )),
                  if (index == 2)
                    Obx(() => LabelDropDown(
                      items: controller.companiesList,
                      selectedValue: controller.selectedCompany.value,
                      onChanged: (val) {
                        controller.selectedRole.value = 2;
                        controller.selectedCompany.value = val;
                      },
                      label: "",
                      showLabel: false,
                    )),
                ],
              )),
          activeColor: AppColors.lightBrownColor,
          value: controller.selectedRole.value == index,
          controlAffinity: ListTileControlAffinity.leading,
          checkboxShape: const CircleBorder(),
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: -4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (_)=>controller.onAccountChange(index),
        ));
  }
}
