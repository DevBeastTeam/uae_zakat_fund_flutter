import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/about_sahem.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/about_sahem_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AboutSahemScreen extends GetView<AboutSahemViewModel> {
  const AboutSahemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: myAppBar(title: "aboutSahem"),
      body: _buildBody(),
    );
  }

  Obx _buildBody() {
    return Obx(() {
      final about = controller.aboutSahem.value;
      if (about == null) return const SizedBox.shrink();

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _localizedText(about.aboutAr, about.aboutEn,
                style: AppTextStyle.tealGreyColor16spTextStyle),
            16.verticalSpace,
            ...about.sections.map((section) => _buildSection(section)),
            // _sectionTitle("missionAndVision".tr),
            _buildCard(
              color: AppColors.dartBlackColor,
              children: [
                _sectionTitle("mission".tr, color: Colors.white),
                16.verticalSpace,
                _localizedText(about.missionSubjectAr, about.missionSubjectEn,
                    style: AppTextStyle.white20spTextStyle),
                16.verticalSpace,
                _localizedText(about.missionDetailsAr, about.missionDetailsEn,
                    style: AppTextStyle.white16spTextStyle1),
              ],
            ),
            _buildCard(
              color: AppColors.ligghtGrey,
              children: [
                _sectionTitle("vision".tr, color: Colors.white),
                16.verticalSpace,
                _localizedText(about.visionDetailsAr, about.visionDetailsEn,
                    style: AppTextStyle.white20spTextStyle),
              ],
            ),
            16.verticalSpace,
            // _sectionTitle("entityVisionAndMission".tr),
            // 16.verticalSpace,
            _buildCardWithShadow(
              children: [
                _sectionTitle("institutionalValues".tr),
                20.verticalSpace,
                ...about.corporateValues.map((val) => _buildTitledParagraph(
                      val.headingAr,
                      val.headingEn,
                      val.detailsAr,
                      val.detailsEn,
                    ))
              ],
            ),
            16.verticalSpace,
            _buildCardWithShadow(
              children: [
                _sectionTitle("strategicGoals".tr),
                20.verticalSpace,
                ...about.strategicGoals.map((goal) => _localizedText(
                      goal.detailsAr,
                      goal.detailsEn,
                      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
                    ))
              ],
            ),
            16.verticalSpace,
           if(about.teamMembers.isNotEmpty) _sectionTitle("ourTeam".tr),
            16.verticalSpace,
            ...about.teamMembers.map(_buildTeamMember)
          ],
        ),
      );
    });
  }

  Widget _localizedText(String ar, String en, {required TextStyle style}) {
    return Text(Utils.isArabic ? ar : en, style: style);
  }

  Widget _sectionTitle(String text, {Color? color}) {
    return Text(
      text,
      style: color != null
          ? AppTextStyle.white26spTextStyle.copyWith(color: color)
          : AppTextStyle.secondaryPrimaryBlack32spTextStyle1,
    );
  }

  Widget _buildSection(Section section) {
    if (section.headingEn == "Our Mission") {
      return _buildMessaion(section);
    } else if (section.headingEn == "Our History") {
      return _buildVission(section);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: CachedImage(
            image: section.image,
            width: Get.width,
            height: 250.h,
          ),
        ),
        16.verticalSpace,
        _localizedText(
          section.headingAr,
          section.headingEn,
          style: AppTextStyle.secondaryPrimaryBlack32spTextStyle2,
        ),
        10.verticalSpace,
        _localizedText(
          section.detailsAr,
          section.detailsEn,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildMessaion(Section section) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _localizedText(
            section.headingAr,
            section.headingEn,
            style: AppTextStyle.secondaryPrimaryBlack32spTextStyle2,
          ),
          10.verticalSpace,
          _localizedText(
            section.detailsAr,
            section.detailsEn,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
          ),
          10.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedImage(
              image: section.image,
              width: Get.width,
              height: 250.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVission(Section section) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedImage(
              image: section.image,
              width: Get.width,
              height: 250.h,
            ),
          ),
          16.verticalSpace,
          _localizedText(
            section.headingAr,
            section.headingEn,
            style: AppTextStyle.secondaryPrimaryBlack32spTextStyle2,
          ),
          10.verticalSpace,
          _localizedText(
            section.detailsAr,
            section.detailsEn,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
          ),
        ],
      ),
    );
  }

  Widget _buildTitledParagraph(
    String headingAr,
    String headingEn,
    String detailsAr,
    String detailsEn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _localizedText(
          headingAr,
          headingEn,
          style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1,
        ),
        16.verticalSpace,
        _localizedText(
          detailsAr,
          detailsEn,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildCard({required Color color, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildCardWithShadow({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTeamMember(TeamMember member) {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedImage(
              image: member.image,
              width: 280.w,
              height: 270.h,
            ),
          ),
          16.verticalSpace,
          Text(
            Utils.isArabic ? member.nameAr : member.nameEn,
            textAlign: TextAlign.center,
            style: AppTextStyle.secondaryPrimaryBlack18spTextStyle1,
          ),
          8.verticalSpace,
          Text(
            Utils.isArabic ? member.jobTitleAr : member.jobTitleEn,
            textAlign: TextAlign.center,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}
