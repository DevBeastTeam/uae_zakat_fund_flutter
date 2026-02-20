import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/widgets/cache_image.dart';

Widget circleImage(String? image,
    {bool showAdd = false,
    bool profile = false,
    required VoidCallback onPressed}) {
  return Center(
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.secondaryLightGreyColor, width: 2.w)),
          child: ClipOval(
            child: image != null
                ? CachedImage(
                    image: image,
                    width: 96.w,
                    height: 96.h,
                    profile: profile,
                  )
                : Image.asset(
                    AppResources.userAvatar,
                    width: 96.w,
                    height: 96.h,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        if (showAdd)
          Positioned(
            bottom: -5,
            right: 0,
            child: FloatingActionButton(
              heroTag: "camera",
              backgroundColor: themeViewModel.color,
              onPressed: onPressed,
              shape: const CircleBorder(),
              mini: true,
              child: SvgPicture.asset(
                AppResources.pencilIcon,
                width: 16.w,
                height: 16.h,
              ),
            ),
          ),
        16.verticalSpace,
      ],
    ),
  );
}
