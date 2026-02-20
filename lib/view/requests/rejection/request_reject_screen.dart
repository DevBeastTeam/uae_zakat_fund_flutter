import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/request_reject_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class RequestRejectScreen extends GetView<RequestRejectViewModel> {
  const RequestRejectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: controller.title),
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(),
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(context, controller.keyboardActionsItem),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.isRejected)
                  Obx(() => LabelDropDown(
                        items: AppConstant.reasons,
                        isRequired: true,
                        selectedValue: controller.selectedReason.value,
                        hint: "chooseAnOption",
                        onChanged: (value) =>
                            controller.selectedReason.value = value,
                        label: 'rejectionReason',
                      )),
                if (controller.isRejected) 16.verticalSpace,
                LabelTextField(
                  controller: controller.notesController,
                  label: "addNote",
                  isRequired: true,
                  focusNode: controller.notesNode,
                  checkValidation: true,
                  maxLines: 6,
                ),
                if (!controller.isRejected) ...[
                  20.verticalSpace,
                  textFieldLabel(label: "uploadDocument"),
                  6.verticalSpace,
                  _buildUploadDocument()
                ],
                20.verticalSpace,
                _buildDocuments()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Obx _buildDocuments() {
    return Obx(() => Column(
          children: [
            if (controller.documents.isNotEmpty)
              textFieldLabel(label: "uploadedDocuments"),
            ...List.generate(
                controller.documents.length,
                (index) => Container(
                      height: 45.h,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.only(top: 13.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                              width: 1.w, color: AppColors.lightBrownColor)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppResources.documentIcon,
                            width: 20.w,
                            height: 20.h,
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: Text(
                              Utils.fileName(controller.documents[index].path!),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.secondaryBlack14spTextStyle1,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: IconButton(
                                onPressed: () =>
                                    controller.documents.removeAt(index),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.highlight_remove_outlined,
                                  color: AppColors.grey,
                                )),
                          ),
                        ],
                      ),
                    ))
          ],
        ));
  }

  Widget _buildUploadDocument() {
    return GestureDetector(
      onTap: () => controller.pickDocuments(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          height: 140.h,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: AppColors.darkBrownColor,
              strokeWidth: 4.w,
              // borderType: BorderType.RRect,
              radius: Radius.circular(10.r),
              dashPattern: const [16],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppResources.uploadIcon,
                    width: 40.w,
                    height: 40.h,
                  ),
                  8.verticalSpace,
                  Text(
                    "uploadTheDocument".tr,
                    style: AppTextStyle.darkBrown16spTextStyle,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0.0, -4.0),
            blurRadius: 100.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          elevatedButton(
            text: "send",
            onPressed: () {
              if (!controller.formKey.currentState!.validate()) {
                return;
              }
              controller.rejectRequest();
            },
          ),
          16.verticalSpace,
          elevatedButton(
              text: "cancel",
              onPressed: () => Get.back(),
              backgroundColor: AppColors.lightGreyColor)
        ],
      ),
    );
  }
}
