import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class AccountDeletionViewModel extends GetxController {
  final formKey = GlobalKey<FormState>();
  final selectedReason = Rxn<String>();

  final details = TextEditingController();
  final detailsNode = FocusNode();
  final isAgree = false.obs;

  final genericRepo = GenericRepoImpl();
  late final User user;
  late final List<KeyboardActionsItem> keyboardActionsItem;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.accountDeletionScreen);
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: detailsNode, displayArrows: false)
    ];
    user = userBox.getAt(0);
  }

  deleteAccount() async {
    Utils.showLoadingDialog();
    var queryParameters = {
      "userId": user.empId,
    };
    var body = {
      "userId": user.empId,
      "deleteReason": TranslationService().keys['en']![selectedReason.value]!,
      "deleteReasonAr": TranslationService().keys['ar']![selectedReason.value]!,
      "detailedReason": details.text,
      "detailedReasonAr": ""
    };
    ApiResponse apiResponse = await genericRepo.deleteAccount(
        request: RequestBody(body: body, queryParameters: queryParameters));

    if (apiResponse.appState == AppState.onSuccess) {
      _handleAccountDeletionSuccess();
    } else {
      Utils.hideLoadingDialog();
      Utils.handleAPIError(apiResponse);
    }
  }

  _handleAccountDeletionSuccess() async {
    final homeViewModel = Get.find<HomeViewModel>();
    await homeViewModel.addDevice(isLogout: true);
    Future.wait([userBox.clear(), switchAccountBox.clear(), rememberMeBox.clear()]);
    Utils.hideLoadingDialog();
    Get.offAllNamed(AppRoutes.mainScreen);
  }

  confirmationDialog() {
    if (!formKey.currentState!.validate()) return;

    if (!isAgree.value) {
      Utils.showGlobalSnackBar(message: "accountDeletionAcknowledge".tr);
      return;
    }

    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: _buildDialogContent(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ));
  }

  Column _buildDialogContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SvgPicture.asset(AppResources.infoIcon),
            ),
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.highlight_remove_outlined,
                  color: AppColors.secondaryPrimaryBlackColor,
                )),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Text(
                "areYouSure".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
              ),
              16.verticalSpace,
              Text(
                "acknowledgeMessage".tr,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
              ),
              16.verticalSpace,
              elevatedButton(
                  text: "confirm",
                  onPressed: () {
                    Get.back();
                    deleteAccount();
                  }),
              8.verticalSpace,
              elevatedButton(
                text: "cancel",
                onPressed: () => Get.back(),
                backgroundColor: AppColors.lightGreyColor,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onClose() {
    details.dispose();
    detailsNode.dispose();

    selectedReason.close();
    isAgree.close();

    super.onClose();
  }
}
