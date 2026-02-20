import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/services_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';

class ServicesScreen extends StatelessWidget {
  ServicesScreen({super.key});

  final controller = Get.put(OurServiceViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: CupertinoSearchField(
            controller: controller.searchController,
            onChanged: (_) => controller.filterServices(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServiceSidebar(),
                10.horizontalSpace,
                Expanded(
                  child: Obx(() => GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 80.h,
                          crossAxisSpacing: 10.h,
                          mainAxisSpacing: 10.h,
                        ),
                        itemCount: controller.services.length,
                        itemBuilder: (context, itemIndex) {
                          return ServiceGridItem(
                              item: controller.services[itemIndex],services:controller.services);
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
        110.verticalSpace,
      ],
    );
  }
}

class ServiceGridItem extends StatelessWidget {
  final OurServices item;
  final List<OurServices> services;

  const ServiceGridItem({super.key, required this.item, required this.services});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.serviceDetails, arguments: {"service": item,"allServices":services});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.lightGrey1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedImage(image: item.icon ?? "", width: 26.w, height: 26.h),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                Utils.isArabic ? item.titleAr : item.titleEn,
                textAlign: TextAlign.center,
                style: AppTextStyle.lightBlackColor12TextStyle1
                    .copyWith(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceSidebar extends StatelessWidget {
  ServiceSidebar({
    super.key,
  });

  final controller = Get.find<OurServiceViewModel>();

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
            itemCount: controller.categoriesList.length,
            itemBuilder: (context, index) {
              final category = controller.categoriesList[index];
              bool isSVG =
                  category.icon?.toString().split(".").last.toLowerCase() ==
                      "svg";
              return GestureDetector(
                onTap: () {
                  controller.updateCategory(category);
                },
                child: Obx(() {
                  final isSelected =
                      category == controller.selectedCategory.value;

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
                            : isSVG
                                ? SvgPicture.network(
                                    '${FlavorConfig.storageUrl}${category.icon}')
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
