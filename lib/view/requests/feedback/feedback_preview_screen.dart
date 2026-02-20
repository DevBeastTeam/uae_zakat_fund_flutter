import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/feedback_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/file_view_widget.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class FeedbackPreviewScreen extends GetView<FeedbackPreviewViewModel> {
  const FeedbackPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "feedbackPreview"),
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(context, controller.keyboardActionsItem),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Obx(() {
            if (controller.feedback.value == null) {
              return SizedBox.shrink();
            }
            if (controller.feedback.value.userId == controller.user.id &&
                !controller.user.isAdmin) {
              return myFeedbackWidget();
            }
            return _buildAdminContent();
          }),
        ),
      ),
    );
  }

  Column _buildAdminContent() {
    return Column(
      children: [
        _buildFeedbackIDTextField(),
        10.verticalSpace,
        LabelTextField(
          controller: controller.userTypeController,
          readOnly: true,
          label: "userType",
        ),
        10.verticalSpace,
        LabelTextField(
          controller: controller.nameController,
          readOnly: true,
          label: "name",
        ),
        10.verticalSpace,
        LabelTextField(
          controller: controller.emailController,
          readOnly: true,
          label: "email",
        ),
        10.verticalSpace,
        LabelTextField(
          controller: controller.mobileController,
          readOnly: true,
          isArabicDirection: true,
          label: "phoneNumber",
        ),
        10.verticalSpace,
        _buildFeedbackTypeTextField(),
        10.verticalSpace,
        titleTextField(),
        if (controller.feedback.value.attachment.isNotEmpty) _buildAttachment(),
        10.verticalSpace,
        detsilsTextField(),
        Obx(() => controller.showResponse.value
            ? buildResponse()
            : SizedBox.shrink()),
        20.verticalSpace,
        _buildBottomActions()
      ],
    );
  }

  LabelTextField _buildFeedbackIDTextField() {
    return LabelTextField(
      controller: controller.feedbackIdController,
      readOnly: true,
      label: "feedbackId",
    );
  }

  LabelTextField titleTextField() {
    return LabelTextField(
      controller: controller.titleController,
      readOnly: true,
      maxLines: 2,
      isArabicDirection: true,
      label: "title",
    );
  }

  LabelTextField detsilsTextField() {
    return LabelTextField(
      controller: controller.detailsController,
      readOnly: true,
      maxLines: 5,
      isArabicDirection: true,
      label: "details",
    );
  }

  Widget buildBottomBar() {
    return Obx(() => controller.isAdmin.value
        ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            elevatedButton(
              text: controller.selectedCategory.value == "spam"
                  ? "closeFeedback"
                  : "submitForApproval",
              isClosed: controller.selectedCategory.value == "spam",
              onPressed: () {
                controller.submitFeedbackResponse();
              },
            ),
            16.verticalSpace,
            elevatedButton(
                text: "cancel",
                onPressed: () => Get.back(),
                backgroundColor: AppColors.lightGreyColor),
          ],
        )
        : SizedBox.shrink());
  }

  Widget buildResponse() {
    return Obx(() => Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              controller.readOnly.value
                  ? LabelTextField(
                      controller: controller.catController,
                      readOnly: true,
                      label: "categorization",
                    )
                  : Obx(() => LabelDropDown(
                        items: controller.categories,
                        selectedValue: controller.selectedCategory.value,
                        hint: "chooseAnOption",
                        isRequired: true,
                        onChanged: (value) {
                          controller.selectedCategory.value = value;
                        },
                        label: 'categorization',
                      )),
              if (controller.selectedCategory.value != "spam") ...[
                10.verticalSpace,
                LabelTextField(
                  controller: controller.rootCauseController,
                  readOnly: controller.readOnly.value,
                  maxLines: 4,
                  isRequired: true,
                  focusNode: controller.rootCauseNode,
                  checkValidation: true,
                  label: "rootCause",
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.solutionProvidedController,
                  readOnly: controller.readOnly.value,
                  maxLines: 4,
                  isRequired: true,
                  focusNode: controller.solutionProvidedNode,
                  checkValidation: true,
                  label: "solutionProvided",
                ),
                10.verticalSpace,
                responseTextField(),
              ]
            ],
          ),
        ));
  }

  LabelTextField responseTextField() {
    return LabelTextField(
      controller: controller.responseController,
      readOnly: controller.readOnly.value,
      maxLines: 6,
      focusNode: controller.responseNode,
      isRequired: true,
      checkValidation: true,
      label: "response",
    );
  }

  Widget myFeedbackWidget() {
    return Column(
      children: [
        _buildFeedbackIDTextField(),
        10.verticalSpace,
        _buildFeedbackTypeTextField(),
        10.verticalSpace,
        titleTextField(),
        10.verticalSpace,
        detsilsTextField(),
        if (controller.feedback.value.attachment.isNotEmpty) _buildAttachment(),
        10.verticalSpace,
        if (controller.showResponse.value &&
            controller.feedback.value!.requestStatus == 2)
          responseTextField(),
        20.verticalSpace,
        _buildBottomActions()
      ],
    );
  }

  LabelTextField _buildFeedbackTypeTextField() {
    return LabelTextField(
      controller: controller.feedbackTypeController,
      readOnly: true,
      label: "feedbackType",
    );
  }

  Widget _buildAttachment() {
    return Column(
      children: [
        10.verticalSpace,
        textFieldLabel(label: "attachment"),
        4.verticalSpace,
        fileViewWidget(
            isImage: false, value: controller.feedback.value.attachment),
      ],
    );
  }

  Widget _buildBottomActions() {
    return controller.isRequest
        ? Obx(() => controller.isAdmin.value
            ? acceptRejectBottomBar(
                onAccept: controller.showAccept
                    ? () {
                        Utils.showLoadingDialog();
                        Get.find<RequestsViewModel>().approveRejectRequest(
                            request: controller.request!,
                            message: "feedbackResponseAccepted");
                      }
                    : null,
                onReturn: controller.showReturn
                    ? () => Utils.openRejectionScreen(
                          title: "feedbackResponseReturn",
                          request: controller.request!,
                        )
                    : null,
                onReject: controller.showReject
                    ? () => Utils.openRejectionScreen(
                        title: "feedbackResponseRejection",
                        request: controller.request!,
                        isRejected: true)
                    : null,
              )
            : const SizedBox.shrink())
        : buildBottomBar();
  }
}
