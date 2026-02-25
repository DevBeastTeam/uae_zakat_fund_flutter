import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/project_detail_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/content_helpful_widget.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/icon_btn.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/progress_bar_content.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';
import 'package:zakat_fund/widgets/text_field_widget.dart';
import 'package:zakat_fund/widgets/video_widget.dart';

class ProjectDetailsScreen extends GetView<ProjectDetailViewModel> {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      body: _buildBody(context),
    );
  }

  WillPopScope _buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: KeyboardDismissOnTap(
        child: KeyboardActions(
          config: Utils.buildConfig(context, controller.keyboardActionsItem),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Obx(
              () => controller.isLoading.value
                  ? const SizedBox.shrink()
                  : _buildProjectDetails(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAssociationInfo(),
        8.verticalSpace,
        _buildProjectTitle(),
        10.verticalSpace,
        _buildProjectStatus(),
        16.verticalSpace,
        _buildShortDescription(),
        10.verticalSpace,
        if (controller.project?.projectImages.isNotEmpty ?? false) ...[
          _imageSlider(),
          10.verticalSpace,
        ],
        if (_hasCategory()) _buildCategories(),
        10.verticalSpace,
        _buildCompletionProgress(),
        16.verticalSpace,
        _buildLongDescription(),
        _buildAmountContainer(),
        if (controller.isPreview) _buildPreviewBottom(),
        if (!controller.isPreview) ...[
          16.verticalSpace,
          ContentHelpfulWidget(id: controller.projectId!, type: 'Project'),
          16.verticalSpace,
        ],
      ],
    );
  }

  Widget _buildProjectStatus() {
    return Row(
      children: [
        if (controller.project?.endDate != null &&
            controller.project?.startDate != null)
          _buildEndDateChip(),
        10.horizontalSpace,
        if (controller.project?.isUrgentProject == true) _buildUrgentChip(),
      ],
    );
  }

  Widget _buildEndDateChip() {
    final daysLeft = controller.project?.endDate!
            .difference(controller.project!.startDate!)
            .inDays ??
        0;
    return Chip(
      label: Text(
        "$daysLeft ${"daysLeft".tr}",
        style: AppTextStyle.secondaryDarkBrownColor12spTextStyle1,
      ),
      avatar: Image.asset(AppResources.clockIcon),
      side: BorderSide.none,
      avatarBoxConstraints: BoxConstraints.tightFor(width: 14.w, height: 14.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      backgroundColor: AppColors.secondaryDarkBrownColor.withValues(alpha: 0.1),
    );
  }

  Widget _buildUrgentChip() {
    return Chip(
      label: Text(
        "urgent".tr,
        style: AppTextStyle.urgentText12spTextStyle1,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      backgroundColor: AppColors.urgentBack,
    );
  }

  bool _hasCategory() {
    return controller.project?.category != null &&
        controller.project?.category != "";
  }

  Widget _buildCategories() {
    final categories = controller.project?.category.split(',') ?? [];
    return Wrap(
      runSpacing: 8.h,
      spacing: 8.w,
      children: categories.map<Widget>((category) {
        return Chip(
          label: Text(
            controller.getCat(category),
            style: AppTextStyle.primaryDarkBrown14spTextStyle
                .copyWith(fontWeight: FontWeight.w400),
          ),
          side: BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
          backgroundColor: AppColors.chipBackgroundColor,
        );
      }).toList(),
    );
  }

  Widget _buildProjectTitle() {
    return Text(
      Utils.isArabic
          ? controller.project!.projectNameArabic
          : controller.project!.projectName,
      style: AppTextStyle.secondaryPrimaryBlack26spTextStyle1,
    );
  }

  Widget _buildShortDescription() {
    return Text(
      Utils.isArabic
          ? controller.project!.projectDescriptionShortArabic
          : controller.project!.projectDescriptionShort,
      style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
    );
  }

  Widget _buildAssociationInfo() {
    if (controller.project?.associationName == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Row(
          children: [
            if (controller.project?.associationLogo != null)
              CircleAvatar(
                backgroundColor: AppColors.lightGrey,
                backgroundImage: NetworkImage(
                    "${controller.project!.associationLogo!.contains(FlavorConfig.storageUrl) ? controller.project?.associationLogo : "${FlavorConfig.storageUrl}${controller.project?.associationLogo!}"}"),
              ),
            if (controller.project?.associationLogo != null) 16.horizontalSpace,
            Expanded(
              child: Text(
                Utils.isArabic
                    ? controller.project!.associationNameArabic!
                    : controller.project!.associationName!,
                style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
              ),
            ),
          ],
        ),
        4.verticalSpace,
        Row(
          children: [
            if (controller.project?.socialMediaLinksFacebook != null)
              buildIconButton(
                isLink: true,
                icon: AppResources.facebookLink,
                onPressed: () =>
                    Utils.openUrl(controller.project?.socialMediaLinksFacebook),
              ),
            if (controller.project?.socialMediaLinksInstagram != null)
              buildIconButton(
                isLink: true,
                icon: AppResources.instagramLink,
                onPressed: () => Utils.openUrl(
                    controller.project?.socialMediaLinksInstagram),
              ),
            if (controller.project?.socialMediaLinksLinkedIn != null)
              buildIconButton(
                isLink: true,
                icon: AppResources.linkedinLink,
                onPressed: () =>
                    Utils.openUrl(controller.project?.socialMediaLinksLinkedIn),
              ),
            if (controller.project?.socialMediaLinksTwitter != null)
              buildIconButton(
                isLink: true,
                icon: AppResources.twitterLink,
                onPressed: () =>
                    Utils.openUrl(controller.project?.socialMediaLinksTwitter),
              ),
          ],
        )
      ],
    );
  }

  Widget _buildCompletionProgress() {
    dynamic progress = controller.project?.percentOfCompletion;
    if (progress == null) {
      progress = 0;
    } else if (progress > 100) {
      progress = 100;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey1),
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppResources.userCircleAvatar,
                width: 40.w,
                height: 40.h,
              ),
              8.horizontalSpace,
              Text(
                "+${controller.project?.totalDonors ?? 0} ${"donors".tr}",
                style: AppTextStyle.secondaryDarkBrownColor20spTextStyle,
              ),
              Spacer(),
              Text("$progress%",
                  style: AppTextStyle.secondaryDarkBrownColor20spTextStyle),
            ],
          ),
          16.verticalSpace,
          ProgressBarContent(isDonation: true, project: controller.project),
        ],
      ),
    );
  }

  Widget _buildLongDescription() {
    if (controller.project?.projectDescriptionLong.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return HtmlWidget(
      Utils.isArabic
          ? controller.project?.projectDescriptionLongArabic
          : controller.project?.projectDescriptionLong,
      textStyle: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
      renderMode: RenderMode.column,
    );
  }

  Column _buildPreviewBottom() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        16.verticalSpace,
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
            minimumSize: Size(Get.width, 45.h),
          ),
          onPressed: controller.toggleLocale,
          icon: const Icon(
            Icons.visibility_rounded,
            color: AppColors.primaryDarkBrownColor,
          ),
          label: Text(
            Utils.isArabic ? "previewInEnglish".tr : "previewInArabic".tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.primaryDarkBrown16spTextStyle1,
          ),
        ),
        16.verticalSpace,
        elevatedButton(
          text: "backToProject",
          onPressed: controller.handleBackPress,
        ),
      ],
    );
  }

  Container _buildAmountContainer() {
    final project = controller.project;
    final quickAmounts = project?.quickAmount?.split(',') ?? [];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.greyBackColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "chooseAmount".tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle1,
          ),
          8.verticalSpace,
          Text(
            "chooseAmountDetails".tr,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
          ),
          if (quickAmounts.isNotEmpty) ...[
            16.verticalSpace,
            _buildQuickAmountChips(quickAmounts),
          ],
          if (project?.isAddQuantity == true && quickAmounts.isNotEmpty) ...[
            16.verticalSpace,
            textFieldLabel(label: "enterQuantity"),
            4.verticalSpace,
            TextFieldWidget(
              white: true,
              hint: "enterAmount".tr,
              focusNode: controller.quantityNode,
              controller: controller.quantity,
              onChanged: (_) => controller.updateTotalAmount(),
            ),
          ],
          16.verticalSpace,
          textFieldLabel(label: "totalAmount"),
          4.verticalSpace,
          TextFieldWidget(
            white: true,
            hint: "totalAmount".tr,
            focusNode: controller.amountNode,
            controller: controller.amount,
            amount: true,
          ),
          20.verticalSpace,
          _buildDonateButton(),
          16.verticalSpace,
          _buildAddToCartButton()
        ],
      ),
    );
  }

  Widget _buildQuickAmountChips(List<String> amounts) {
    return Wrap(
      runSpacing: 13.h,
      spacing: 8.w,
      children: List.generate(amounts.length, (index) {
        return Obx(() {
          final isSelected = controller.selectedAmountIndex.value == index;
          final labelText = "${amounts[index]} ${"currency".tr}";
          return RawChip(
            tapEnabled: true,
            onPressed: () => controller.updateAmount(index),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(
              labelText,
              style: isSelected
                  ? AppTextStyle.warningBackColor12spTextStyle1
                  : AppTextStyle.lightGray12spTextStyle,
            ),
            side: BorderSide(
                color:
                    isSelected ? themeViewModel.color : AppColors.remindColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            backgroundColor:
                isSelected ? themeViewModel.color : AppColors.greyBackColor,
          );
        });
      }),
    );
  }

  Widget _imageSlider() {
    final projectImages = controller.project?.projectImages ?? [];

    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
          carouselController: controller.carouselController,
          options: CarouselOptions(
            height: 357.h,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) => controller.handlePageChange(index),
          ),
          itemCount: projectImages.length,
          itemBuilder: (_, index, __) => ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: _buildMedia(projectImages[index]),
          ),
        ),
        Positioned(bottom: 10.h, child: _buildIndicator(projectImages.length)),
        Positioned(
            left: 8.w, right: 8.w, child: _buildArrows(projectImages.length)),
        if (!controller.isPreview && userBox.isNotEmpty) _buildFavoriteButton(),
      ],
    );
  }

  Widget _buildMedia(ProjectImage image) {
    if (image.mediaType == 1) {
      return VideoPlayerWidget(
        key: image.playerKey,
        video: image.mediaUrl,
        isAsset: image.projectId == null,
      );
    }

    return image.projectId != null
        ? CachedImage(
            image: image.mediaUrl,
            width: 100.sw,
            height: 357.h,
          )
        : Image.file(
            File(image.mediaUrl),
            width: 100.sw,
            height: 357.h,
            fit: BoxFit.cover,
          );
  }

  Widget _buildIndicator(int count) {
    return SizedBox(
      height: 8.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: count,
        separatorBuilder: (_, __) => 4.horizontalSpace,
        itemBuilder: (_, index) => Obx(() {
          final isActive = controller.currentPicIndex.value == index;
          return Container(
            width: isActive ? 16.w : 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              shape: isActive ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isActive ? BorderRadius.circular(5.r) : null,
              color:
                  isActive ? Colors.white : AppColors.secondaryLightGreyColor,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildArrows(int totalItems) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildArrow(
          icon: AppResources.arrowCircleLeftIcon,
          onTap: () {
            if (controller.currentPicIndex.value > 0) {
              controller.carouselController?.animateToPage(
                controller.currentPicIndex.value - 1,
              );
            }
          },
        ),
        _buildArrow(
          icon: AppResources.arrowCircleRightIcon,
          onTap: () {
            if (controller.currentPicIndex.value < totalItems - 1) {
              controller.carouselController?.animateToPage(
                controller.currentPicIndex.value + 1,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildArrow({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.flip(
        flipX: Utils.isArabic,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 4),
                blurRadius: 150,
              ),
            ],
          ),
          child: SvgPicture.asset(icon, width: 40.w, height: 40.h),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 13.h,
      left: Utils.isArabic ? null : 13.h,
      right: Utils.isArabic ? 13.h : null,
      child: FloatingActionButton(
        heroTag: "details",
        mini: true,
        onPressed: controller.addToFavorite,
        backgroundColor: AppColors.chipBackgroundColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
        child: Obx(() => SvgPicture.asset(
              controller.isFavorite.value
                  ? AppResources.starFillIcon
                  : AppResources.starIcon,
            )),
      ),
    );
  }

  Widget _buildImageListView() {
    final images = controller.project?.projectImages ?? [];

    return SizedBox(
      height: 132.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => 10.horizontalSpace,
        itemBuilder: (context, index) {
          final image = images[index];

          return GestureDetector(
            onTap: () {
              controller.currentPicIndex.value = index;
              controller.carouselController?.animateToPage(index);
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: _buildImagePreview(image),
                ),
                if (image.mediaType == 1) _buildPlayIconOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePreview(ProjectImage image) {
    final isVideo = image.mediaType == 1;
    final isFromNetwork = image.projectId != null;

    if (isVideo) {
      return FutureBuilder(
        future: isFromNetwork
            ? Utils.urlThumbnail(image.mediaUrl)
            : Utils.fileThumbnail(image.mediaUrl),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return isFromNetwork
                ? Image.file(
                    File(snapshot.data),
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  )
                : Image.memory(
                    snapshot.data,
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  );
          }
          return Image.asset(
            AppResources.placeholder,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return isFromNetwork
        ? CachedImage(
            image: image.mediaUrl,
            width: 100.w,
            height: 100.h,
          )
        : Image.file(
            File(image.mediaUrl),
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          );
  }

  Widget _buildPlayIconOverlay() {
    return Positioned.fill(
      child: Center(
        child: SvgPicture.asset(
          AppResources.playIcon,
          width: 33.w,
          height: 33.h,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 100.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildDonateButton()),
          10.horizontalSpace,
          Expanded(child: _buildAddToCartButton()),
        ],
      ),
    );
  }

  Widget _buildDonateButton() {
    return SizedBox(
      height: 40.h,
      child: elevatedButton(
        text: "donateNow",
        onPressed: () => controller.addToCart(isDonate: true),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 40.h,
      child: OutlinedButton(
        onPressed: () {
          controller.addToCart(isDonate: false);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryDarkBrownColor,
          side: const BorderSide(color: AppColors.secondaryDarkBrownColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 12),
            SizedBox(width: 4),
            Text("addToCart".tr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
