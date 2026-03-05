import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';
import 'package:zakat_fund/widgets/association_card.dart';
import 'package:zakat_fund/widgets/featured_projects.dart';
import 'package:zakat_fund/widgets/home_stats_widget.dart';
import 'package:zakat_fund/widgets/project_card.dart';
import 'package:zakat_fund/widgets/section_header.dart';
import 'package:zakat_fund/widgets/service_card_widget.dart';
import 'package:zakat_fund/widgets/tabbar_widget_v2.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final viewModel = Get.put(HomeViewModel());
  final mainViewModel = Get.find<MainViewModel>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: viewModel.refreshData,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (viewModel.featuredProjects.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  20.verticalSpace,
                  SectionHeader(
                      title: "featuredProjects",
                      onViewAll: () {
                        mainViewModel.switchTab(2);
                      }),
                  FeaturedProjectsSection(
                    featuredProjects: viewModel.featuredProjects,
                    campaignIndex: viewModel.campaignIndex,
                    onPageChanged: (index, reason) =>
                        viewModel.updateCampaignIndicator(index),
                  ),
                ],
              );
            }),
            SectionHeader(
                title: "learnAboutCurrentProjects",
                onViewAll: () {
                  mainViewModel.switchTab(2);
                }),
            Obx(() => TabBarWidgetV2(
                  tabs: viewModel.projCategoriesList
                      .map((cat) => Utils.isArabic ? cat.nameAr : cat.name)
                      .toList()
                      .cast<String>(),
                  currentIndex: viewModel.projCategoriesList
                      .indexOf(viewModel.homeSelectedProjectCat.value),
                  onTabChanged: (index) {
                    viewModel
                        .filterProjects(viewModel.projCategoriesList[index]);
                  },
                )),
            20.verticalSpace,
            Obx(() => SizedBox(
                  height: 215.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (BuildContext context, int index) =>
                        ProjectCard(
                      project: viewModel.projects[index],
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        10.horizontalSpace,
                    itemCount: viewModel.projects.length,
                  ),
                )),

            if (userBox.isNotEmpty) ...[
              20.verticalSpace,
              HomeStatsWidget(),
            ],
            10.verticalSpace,
            SectionHeader(
                title: "discoverMoreAssociations",
                onViewAll: () {
                  Get.toNamed(AppRoutes.allAssociationsScreen);
                }),
            Obx(() => TabBarWidgetV2(
                  tabs: viewModel.associationCatsList
                      .map((cat) => Utils.isArabic ? cat.nameAr : cat.name)
                      .toList()
                      .cast<String>(),
                  currentIndex: viewModel.associationCatsList
                      .indexOf(viewModel.homeSelectedAssociationCat.value),
                  onTabChanged: (index) {
                    viewModel.filterHomeAssociations(
                        viewModel.associationCatsList[index]);
                  },
                )),
            20.verticalSpace,
            Obx(() => SizedBox(
                  height: 150.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 16),
                    itemBuilder: (BuildContext context, int index) =>
                        AssociationCard(
                      association: viewModel.associations[index],
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        10.horizontalSpace,
                    itemCount: viewModel.associations.length > 10
                        ? 10
                        : viewModel.associations.length,
                  ),
                )),
            20.verticalSpace,
            SectionHeader(
                title: "ourServices",
                onViewAll: () {
                  mainViewModel.switchTab(1);
                }),
            Obx(() => TabBarWidgetV2(
                  tabs: viewModel.servicesCategoriesList
                      .map((cat) => Utils.isArabic ? cat.nameAr : cat.name)
                      .toList()
                      .cast<String>(),
                  currentIndex: viewModel.servicesCategoriesList
                      .indexOf(viewModel.selectedServiceCat.value),
                  onTabChanged: (index) {
                    viewModel.filterServices(
                        viewModel.servicesCategoriesList[index]);
                  },
                )),
            20.verticalSpace,
            Obx(() => SizedBox(
                  height: 120.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (BuildContext context, int index) =>
                        ServiceCard(
                      category: viewModel.services[index],
                      allServices: viewModel.services,
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        10.horizontalSpace,
                    itemCount: viewModel.services.length,
                  ),
                )),
            // 20.verticalSpace,
            // SectionHeader(
            //     title: "latestNewsEvents",
            //     onViewAll: () {
            //       Get.toNamed(AppRoutes.mediaCenterScreen);
            //     }),
            // Container(
            //   height: 52.h,
            //   margin: EdgeInsets.symmetric(
            //     horizontal: 16.w,
            //   ),
            //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(24.r),
            //       border: Border.all(color: AppColors.lightGrey),
            //       color: Colors.white),
            //   child: Obx(() => ListView.separated(
            //         scrollDirection: Axis.horizontal,
            //         itemBuilder: (BuildContext context, int index) {
            //           final category = viewModel.categoriesList[index];
            //           return GestureDetector(
            //             onTap: () => viewModel.filterLatestNews(category),
            //             child: Obx(() {
            //               return Container(
            //                 padding: EdgeInsets.symmetric(horizontal: 10.w),
            //                 alignment: Alignment.center,
            //                 decoration: viewModel.selectedNewsCat.value ==
            //                         category
            //                     ? BoxDecoration(
            //                         borderRadius: BorderRadius.circular(24.r),
            //                         color: AppColors.secondaryDarkBrownColor
            //                             .withValues(alpha: 0.12))
            //                     : null,
            //                 child: Text(
            //                   Utils.isArabic ? category.nameAr : category.name,
            //                   style: AppTextStyle
            //                       .secondaryDarkBrownColor14spTextStyle,
            //                 ),
            //               );
            //             }),
            //           );
            //         },
            //         separatorBuilder: (BuildContext context, int index) =>
            //             16.horizontalSpace,
            //         itemCount: viewModel.categoriesList.length,
            //       )),
            // ),

            // 20.verticalSpace,
            // Obx(() => SizedBox(
            //       height: 166.h,
            //       child: ListView.separated(
            //         padding: EdgeInsets.symmetric(horizontal: 16.w),
            //         scrollDirection: Axis.horizontal,
            //         itemBuilder: (BuildContext context, int index) =>
            //             NewsCard(news: viewModel.latestNews[index]),
            //         separatorBuilder: (BuildContext context, int index) =>
            //             10.horizontalSpace,
            //         itemCount: viewModel.latestNews.length > 10
            //             ? 10
            //             : viewModel.latestNews.length,
            //       ),
            //     )),
            110.verticalSpace,
          ],
        ),
      ),
    );
  }
}

