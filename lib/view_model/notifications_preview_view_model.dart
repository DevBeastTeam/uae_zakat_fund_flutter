import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/notifications_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class NotificationsPreviewViewModel extends ModulePermissionsViewModel {
  final titleInEnglish = TextEditingController();
  final titleInArabic = TextEditingController();
  final publishScheduleTime = TextEditingController();
  final descInEnglish = TextEditingController();
  final descInArabic = TextEditingController();

  final Rxn<Notifications> notification = Rxn<Notifications>();
  final NotificationsRepoImpl repo = NotificationsRepoImpl();

  @override
  void onInit() {
    Future.microtask(()=> fetchDetails());
    super.onInit();
  }

  fetchDetails() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.notificationDetails(request: RequestBody(endPoint: "${ApiConstant.notificationDetails}/${request?.entityId}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      notification.value = apiResponse.data;
      isAdmin.value = (request?.status == 1 && user.isAdmin);
      titleInEnglish.text = notification.value!.titleEn;
      titleInArabic.text = notification.value!.titleAr;
      if(notification.value?.publishDate!=null){
        publishScheduleTime.text = Utils.dateTimeFormat.format(notification.value!.publishDate!);
      }
      descInEnglish.text = notification.value!.descriptionEn;
      descInArabic.text = notification.value!.descriptionAr;
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  notificationDetailsDialog(Notifications notification) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.highlight_remove_outlined,
                    color: AppColors.secondaryPrimaryBlackColor,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Text(
                Utils.isArabic ? notification.titleAr : notification.titleEn,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
              ),
            ),
            if (notification.imageName != null && notification.imageName != "")
              16.verticalSpace,
            if (notification.imageName != null && notification.imageName != "")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedImage(
                    image: notification.imageName!,
                    width: Get.width,
                    height: 250.h,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
              child: Text(
                Utils.isArabic
                    ? notification.descriptionAr
                    : notification.descriptionEn,
                style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
              ),
            ),
            4.verticalSpace,
          ],
        ),
      ),
    ));
  }

  @override
  void onClose() {
    titleInEnglish.dispose();
    titleInArabic.dispose();
    publishScheduleTime.dispose();
    descInEnglish.dispose();
    descInArabic.dispose();

    notification.close();
    super.onClose();
  }

}
