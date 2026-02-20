import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/view_model/static_page_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class StaticPageScreen extends GetView<StaticPageViewModel> {
  const StaticPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "staticPagePreview"),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "headerDetails".tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle3,
          ),
          16.verticalSpace,
          LabelTextField(
            controller: controller.pageLinkController,
            readOnly: true,
            label: "pageLink",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.pageNameController,
            readOnly: true,
            label: "pageName",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.parentPageController,
            readOnly: true,
            label: "parentPage",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.pageSectionController,
            readOnly: true,
            label: "pageSection",
          ),
          10.verticalSpace,
          LabelTextField(
            controller: controller.pageOrderController,
            readOnly: true,
            label: "pageOrder",
          ),
          16.verticalSpace,
          Text(
            "pageDetails".tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle3,
          ),
          16.verticalSpace,
          Obx(() => LabelDropDown(
                items: AppConstant.languages,
                selectedValue: controller.selectedLanguage.value,
                onChanged: (value)=>controller.onChangeLanguage(value!),
                label: 'language',
              )),
          16.verticalSpace,
          LabelTextField(
            controller: controller.pageTitleController,
            readOnly: true,
            maxLines: 2,
            label: "pageTitleInSelectedLanguage",
          ),
          20.verticalSpace,
          _buildBottomActions(),
          8.verticalSpace,
          _buildPreviewBtn()
        ],
      ),
    );
  }

  OutlinedButton _buildPreviewBtn() {
    return OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
            minimumSize: Size(Get.width, 45.h),
          ),
          onPressed: ()=>controller.showPreview(),
          label: Text(
            "preview".tr,
            maxLines: 1,
            style: AppTextStyle.primaryDarkBrown16spTextStyle1,
          ),
          icon: const Icon(
            Icons.visibility_rounded,
            color: AppColors.primaryDarkBrownColor,
          ),
        );
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (!controller.isAdmin.value) {
        return SizedBox.shrink();
      }
      return acceptRejectBottomBar(
          onAccept: controller.showAccept
              ? () {
                  Utils.showLoadingDialog();
                  Get.find<RequestsViewModel>().approveRejectRequest(
                      request: controller.request!,
                      message: "staticPageAccepted");
                }
              : null,
          onReturn: controller.showReturn
              ? () => Utils.openRejectionScreen(
                    title: "staticPageReturn",
                    request: controller.request!,
                  )
              : null,
          onReject: controller.showReject
              ? () => Utils.openRejectionScreen(
                  title: "staticPageRejection",
                  request: controller.request!,
                  isRejected: true)
              : null,);
    });
  }
}
