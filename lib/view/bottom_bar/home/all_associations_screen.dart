import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AllAssociationsScreen extends GetView<HomeViewModel> {
  const AllAssociationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Utils.logEvent(name: EventConstant.allAssociationsScreen);
    controller.searchAssociation.clear();
    controller.filterAssociation();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: myAppBar(title: "associations"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssociationSidebar(),
                10.horizontalSpace,
                Expanded(
                  child: Obx(() => GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 190.h,
                          crossAxisSpacing: 10.h,
                          mainAxisSpacing: 10.h,
                        ),
                        itemCount: controller.associationsList.length,
                        itemBuilder: (context, itemIndex) {
                          return AssociationCard(
                              association:
                                  controller.associationsList[itemIndex]);
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: CupertinoSearchField(
        controller: controller.searchAssociation,
        onChanged: (_) {
          controller.filterAssociation();
        },
      ),
    );
  }

  Widget _buildAssociationsList() {
    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.associationsList.length,
          separatorBuilder: (_, __) => 16.verticalSpace,
          itemBuilder: (context, index) {
            final association = controller.associationsList[index];
            return _buildAssociationCard(association);
          },
        ));
  }

  Widget _buildAssociationCard(Project association) {
    final accountName = Utils.isArabic
        ? association.accountNameArabic
        : association.accountName;
    final description = Utils.isArabic
        ? association.associationDescriptionAR
        : association.associationDescriptionEN;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0.0, 4.0),
            blurRadius: 40.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          association.accountLogo != null
              ? CachedImage(
                  image: association.accountLogo!,
                  height: 64.h,
                  width: Get.width,
                  isCover: false,
                )
              : Image.asset(
                  AppResources.placeholder,
                  height: 64.h,
                  width: Get.width,
                ),
          16.verticalSpace,
          // _buildProjectsChip(association.projects.length),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              accountName,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTextStyle.darkBrown18spTextStyle,
            ),
          ),
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.secondaryPrimaryBlack12spTextStyle1,
            ),
          ),
          16.verticalSpace,
          elevatedButton(
            text: "more",
            onPressed: () => Get.toNamed(
              AppRoutes.associationDetailsScreen,
              arguments: association.accountId,
            ),
          ),
        ],
      ),
    );
  }
}

class AssociationCard extends StatelessWidget {
  final Project association;

  const AssociationCard({
    super.key,
    required this.association,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.associationDetailsScreen,
        arguments: association.accountId,
      ),
      child: Container(
        width: 127.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 117.w,
                height: 84.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.greyBackColor),
                child: association.accountLogo != null
                    ? CachedImage(
                        image: association.accountLogo!,
                        isCover: false,
                        width: 100.w,
                        height: 75.h,
                      )
                    : Image.asset(
                        AppResources.placeholder,
                        width: 100.w,
                        height: 75.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            10.verticalSpace,
            _buildProjectsChip(association.projects.length),
            10.verticalSpace,
            Flexible(
              child: Text(
                Utils.isArabic
                    ? association.accountNameArabic
                    : association.accountName,
                style: AppTextStyle.secondaryPrimaryBlack12spTextStyle2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                Text(
                  "viewDetails".tr,
                  style: AppTextStyle.secondaryDarkBrownColor12spTextStyle1,
                ),
                8.horizontalSpace,
                Icon(Icons.arrow_forward, size: 16.r)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsChip(int count) {
    return Chip(
      label: Text(
        "$count ${"projects".tr}",
        style: TextStyle(
          color: AppColors.secondaryDarkBrownColor,
          fontWeight: FontWeight.w400,
          fontSize: 10.sp,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: AppColors.secondaryDarkBrownColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

class AssociationSidebar extends StatelessWidget {
  AssociationSidebar({
    super.key,
  });

  final controller = Get.find<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGrey1),
      ),
      child: Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
            itemCount: controller.associationCatsList.length,
            itemBuilder: (context, index) {
              final category = controller.associationCatsList[index];

              return GestureDetector(
                onTap: () async {
                  controller.filterAssociations(category);
                },
                child: Obx(() {
                  final isSelected =
                      category == controller.selectedAssociationCat.value;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.secondaryDarkBrownColor
                                  .withValues(alpha: 0.12)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: category.value == 0
                            ? SvgPicture.asset(
                                AppResources.servicesUnFillIcon,
                                width: 24.w,
                                height: 24.h,
                              )
                            : CachedImage(
                                image: category.icon,
                                width: 24.w,
                                height: 24.h),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Utils.isArabic ? category.nameAr : category.name,
                        textAlign: TextAlign.center,
                        style: isSelected
                            ? AppTextStyle.secondaryDarkBrownColor10spTextStyle
                            : AppTextStyle.greyColor10spTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      20.verticalSpace,
                    ],
                  );
                }),
              );
            },
          )),
    );
  }
}
