import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/our_services.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/services_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class OurServiceScreen extends GetView<OurServiceViewModel> {
  const OurServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: myAppBar(title: "ourServices"),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Obx(() {
      if (controller.services.isEmpty && controller.allServices.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildTabBar(),
          16.verticalSpace,
          _buildServicesList(),
        ],
      );
    });
  }

  TabBar _buildTabBar() {
    return tabBarWidget(
      controller.tabController,
      controller.tabs,
      controller.currentTabIndex.value,
      newTab: true,
    );
  }

  Padding _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: CupertinoSearchField(
        controller: controller.searchController,
        onChanged: (_) => controller.filterServices(),
      ),
    );
  }

  Widget _buildServicesList() {
    return Obx(() => Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            itemCount: controller.services.length,
            separatorBuilder: (_, __) => 16.verticalSpace,
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return _buildServiceItem(service, index);
            },
          ),
        ));
  }

  Widget _buildServiceItem(OurServices service, int index) {
    return GestureDetector(
      onTap: () => controller.openServiceDetailsScreen(service),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: AppColors.lightGrey, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              offset: const Offset(0.0, 4.0),
              blurRadius: 40.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.isArabic ? service.titleAr : service.titleEn,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.secondaryBlack20spTextStyle,
            ),
            8.verticalSpace,
            Row(
              children: [
                if (userBox.isNotEmpty)
                  buildIconButton(
                    color: AppColors.darkBrownColor,
                    icon: service.isFavorite
                        ? AppResources.starFillIcon
                        : AppResources.starIcon,
                    onPressed: () => controller.addToFavorite(index),
                  ),
                buildIconButton(
                  color: AppColors.darkBrownColor,
                  icon: AppResources.shareColorIcon,
                  onPressed: ()=>controller.shareService(service.id),
                ),
              ],
            ),
            8.verticalSpace,
            Text(
              Utils.htmlToPlainText(
                Utils.isArabic ? service.descriptionAr : service.descriptionEn,
              ),
              style: AppTextStyle.darkGrey16spTextStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
