import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/view_model/all_projects_view_model.dart';
import 'package:zakat_fund/widgets/cupertino_search_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/recent_projects.dart';

class AllProjectsScreen extends GetView<AllProjectsViewModel> {
  const AllProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final title = Get.arguments["title"] ?? "projects";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: title),
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchBar(),
          Obx(() => _buildProjectList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
      child: CupertinoSearchField(
        controller: controller.searchController,
        onChanged: (_) => controller.filterProjects(),
      ),
    );
  }

  Widget _buildProjectList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.projects.length,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (context, index) {
        final project = controller.projects[index];
        return ProjectCard(
          project: project,
          isVertical: true,
        );
      },
    );
  }
}
