import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/individual_view_model.dart';
import 'package:zakat_fund/widgets/circle_image.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/profile_text_widget.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class IndividualProfileScreen extends GetView<AccountViewModel> {
  const IndividualProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.currentTabIndex.value = 0;
    controller.tabController.animateTo(0);
    final viewModel = Get.find<IndividualViewModel>();
    return Column(
      children: [
        16.verticalSpace,
        _buildImageView(),
        16.verticalSpace,
        _buildTabBar(),
        _buildTabView(viewModel)
      ],
    );
  }

  Obx _buildTabView(IndividualViewModel viewModel) {
    return Obx(() => Expanded(
        child: controller.currentTabIndex.value == 0
            ? donorAccountInfo(viewModel)
            : donorContactInfo()));
  }

  Obx _buildTabBar() {
    return Obx(() => tabBarWidget(controller.tabController, controller.tabs,
        controller.currentTabIndex.value));
  }

  Obx _buildImageView() {
    return Obx(() => circleImage(controller.profilePhoto.value,
        onPressed: () => controller.addImage(),
        profile: true,
        showAdd: controller.individual.value.accountInfo!.userId ==
            controller.user.id));
  }

  Widget donorAccountInfo(IndividualViewModel viewModel) {
    AccountInfo? accountInfo = controller.individual.value.accountInfo;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          profileTextWidget(label: "email", value: accountInfo?.email),
          profileTextWidget(label: "userName", value: accountInfo!.userName),
          profileTextWidget(
              label: "firstNameInEnglish", value: accountInfo.firstName),
          profileTextWidget(
              label: "lastNameInEnglish", value: accountInfo.lastName),
          profileTextWidget(
              label: "firstNameInArabic", value: accountInfo.firstNameArabic),
          profileTextWidget(
              label: "lastNameInArabic", value: accountInfo.lastNameArabic),
          profileTextWidget(
              label: "dob",
              value: accountInfo.dob != null
                  ? Utils.dateFormat1.format(accountInfo.dob!)
                  : ""),
          profileTextWidget(
              label: "gender",
              value: accountInfo.gender == null
                  ? ""
                  : accountInfo.gender == 1
                      ? "male".tr
                      : "female".tr),
          profileTextWidget(label: "uaeId", value: accountInfo.emirateId),
          profileTextWidget(
              label: "nationality", value: controller.nationality.value),
          Obx(() => viewModel.additionalDocuments.isNotEmpty
              ? profileAdditionDocWidget(viewModel.additionalDocuments)
              : SizedBox.shrink()),
          if (controller.individual.value.accountInfo!.userId ==
              controller.user.id)
            elevatedButton(
                text: "editInformation",
                onPressed: () => controller.updateIndTabIndexForEdit(0)),
        ],
      ),
    );
  }

  Widget donorContactInfo() {
    final viewModel = Get.find<IndividualViewModel>();
    DonorContactInfo? contactInfo = controller.individual.value.contactInfo;
    LookupData? countryData = viewModel.selectedCountry.value;
    LookupData? emirateData = viewModel.selectedEmirate.value;
    LookupData? cityData = viewModel.selectedCity.value;
    String country = "", emirate = "", city = "";
    if (countryData != null) {
      country = Utils.isArabic ? countryData.nameAr : countryData.name;
    }
    if (emirateData != null) {
      emirate = Utils.isArabic ? emirateData.nameAr : emirateData.name;
    }
    if (cityData != null) {
      city = Utils.isArabic ? cityData.nameAr : cityData.name;
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          profileTextWidget(
              label: "mobileNumberPrimary", value: contactInfo?.mobile),
          profileTextWidget(
              label: "mobileNumberSecondary",
              value: contactInfo?.additionalMobileNumber),
          profileTextWidget(label: "country", value: country),
          if (viewModel.selectedEmirate.value != null)
            profileTextWidget(label: "emirate", value: emirate),
          profileTextWidget(label: "city", value: city),
          profileTextWidget(label: "poBox", value: contactInfo?.poBox),
          Text(
            "address".tr,
            style: AppTextStyle.primaryDarkGrey14spTextStyle1,
          ),
          8.verticalSpace,
          _buildAddressListView(contactInfo),
          if (controller.individual.value.accountInfo!.userId ==
              controller.user.id)
            elevatedButton(
                text: "editInformation",
                onPressed: () => controller.updateIndTabIndexForEdit(1)),
        ],
      ),
    );
  }

  Column _buildAddressListView(DonorContactInfo? contactInfo) {
    return Column(
        children: List.generate(
            contactInfo!.addresses.length,
            (index) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 50.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${index == 0 ? "address1".tr : "address2".tr} ${contactInfo.addresses[index].isDefault ? "primary".tr : ""}",
                        style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                      ),
                      8.verticalSpace,
                      Text(contactInfo.addresses[index].street,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(contactInfo.addresses[index].building,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(contactInfo.addresses[index].landmark,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                    ],
                  ),
                )));
  }
}
