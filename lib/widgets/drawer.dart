import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

class DrawerWidget extends GetView<MainViewModel> {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      backgroundColor: Colors.white,
      width: 0.7.sw,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  _buildHeader(),
                  ..._buildContent(),
                  _buildLogOutButton(),
                  25.verticalSpace
                ],
              )),
        ),
      ),
    );
  }

  Transform _buildBackButton() {
    return Transform.flip(
      flipX: Utils.isArabic,
      child: Builder(
        builder: (context) => FloatingActionButton(
          heroTag: "backButton",
          highlightElevation: 0,
          onPressed: () => Get.back(),
          mini: true,
          elevation: 0,
          backgroundColor: AppColors.chipBackgroundColor,
          child: Image.asset(
            AppResources.leftArrowIcon,
            width: 24.w,
            height: 24.h,
          ),
        ),
      ),
    );
  }

  Widget _buildLogOutButton() {
    return ValueListenableBuilder(
        valueListenable: userBox.listenable(),
        builder: (_, Box<dynamic> value, __) {
          if (value.isEmpty) return const SizedBox.shrink();
          return TextButton.icon(
            onPressed: () => controller.logOut(),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            label: Text("logout".tr, style: AppTextStyle.black16spTextStyle),
            icon: Transform.flip(
              flipX: !Utils.isArabic,
              child: Image.asset(
                AppResources.logout,
                width: 32.w,
                height: 32.h,
              ),
            ),
          );
        });
  }

  Iterable<Widget> _buildContent() {
    return controller.menu.value.map((option) {
      final title = option.id == null
          ? option.pageTitleEN.toString().tr
          : Utils.isArabic
              ? option.pageTitleAR ?? ''
              : option.pageTitleEN ?? '';

      return ListTile(
        onTap: () => controller.handleDrawerNavigation(option),
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text(
          title,
          style: AppTextStyle.black16spTextStyle,
        ),
        trailing: Transform.flip(
          flipX: Utils.isArabic,
          child: Image.asset(
            AppResources.arrowRight,
            width: 16.w,
            height: 16.h,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildHeader() {
    return ValueListenableBuilder(
      valueListenable: userBox.listenable(),
      builder: (_, box, __) {
        if (box.isEmpty) return 16.verticalSpace;
        final User user = box.getAt(0);
        final User? switchAccountUser = switchAccountBox.isNotEmpty?switchAccountBox.getAt(0):null;
        final String name = Utils.isArabic
            ? '${user.firstNameArabic ?? ''} ${user.lastNameArabic ?? ''}'
            : '${user.firstName ?? ''} ${user.lastName ?? ''}';

        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 20.h),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.tileBackgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 100,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  Get.back();
                  if (controller.currentIndex.value != 3) {
                    Get.find<AccountViewModel>().fetchProfile();
                  }
                },
                leading: ClipOval(
                  child: user.photo == null
                      ? Image.asset(
                          AppResources.userAvatar,
                          fit: BoxFit.cover,
                          width: 50.w,
                          height: 50.h,
                        )
                      : CachedImage(
                          image: user.photo,
                          width: 50.w,
                          height: 50.h,
                          profile: true,
                        ),
                ),
                title: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.darkBrown16spTextStyle,
                ),
                subtitleTextStyle: TextStyle(
                  color: AppColors.darkGreyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                subtitle: Text("viewProfile".tr),
              ),
              if(switchAccountUser!=null&&switchAccountUser.roles.length>1)Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: TextButton.icon(
                  onPressed: (){
                    Get.back();
                    Get.toNamed(AppRoutes.roleLinkScreen, arguments: {"user": switchAccountUser, "isUaePass": false});
                  },
                  label: Text("switchAccount".tr, style: AppTextStyle.darkBrown12spTextStyle),
                  icon: SvgPicture.asset(AppResources.switchAccountIcon
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
