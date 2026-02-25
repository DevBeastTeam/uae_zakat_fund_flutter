import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zakat_fund/model/individual.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/address_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class AddAddressScreen extends GetView<AddressViewModel> {
  final Address? address;

  const AddAddressScreen({this.address, super.key});

  @override
  Widget build(BuildContext context) {
    if (address != null) {
      controller.setData(address!);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
        child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            8.verticalSpace,
            _buildHeadingRow(),
            20.verticalSpace,
            LabelTextField(
              controller: controller.streetName,
              isRequired: true,
              checkValidation: true,
              label: 'streetName',
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.buildingName,
              isRequired: true,
              checkValidation: true,
              label: 'buildingName',
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.nearestLandMark,
              isRequired: true,
              checkValidation: true,
              label: 'nearestLandmark',
            ),
            20.verticalSpace,
            _buildGoogleMap(),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: elevatedButton(
                      text: "cancel",
                      onPressed: () => Get.back(),
                      backgroundColor: AppColors.lightGreyColor),
                ),
                16.horizontalSpace,
                Expanded(
                  child: elevatedButton(
                    text: address != null ? "updateAddress" : "addAddress",
                    onPressed: () => controller.addAddress(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  SizedBox _buildGoogleMap() {
    return SizedBox(
      width: Get.width,
      height: 185.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Obx(() => GoogleMap(
              markers: Set<Marker>.of(controller.markers.value.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: controller.cameraPosition.value,
              onMapCreated: controller.onMapCreated,
              onCameraMove: controller.onCameraMove,
            )),
      ),
    );
  }

  Row _buildHeadingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          address != null ? "editAddress".tr : "addNewAddress".tr,
          style: AppTextStyle.secondaryPrimaryBlack20spTextStyle,
        ),
        GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.highlight_remove_outlined,
              color: AppColors.secondaryPrimaryBlackColor,
            )),
      ],
    );
  }
}
