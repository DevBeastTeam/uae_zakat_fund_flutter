import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';

class CachedImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final bool isCover;
  final bool profile;
  final Color? color;
  final bool showPlaceHolder;
  final BoxFit? fit;

  const CachedImage({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.isCover = true,
    this.profile = false,
    this.color,
    this.showPlaceHolder = false,
    this.fit = BoxFit.cover,
  });

  String get imageUrl => profile ? image : '${FlavorConfig.storageUrl}$image';

  String get placeholderAsset {
    if (showPlaceHolder) return AppResources.placeholder;
    return profile ? AppResources.userAvatar : AppResources.placeholder;
  }

  String get errorAsset =>
      profile ? AppResources.userAvatar : AppResources.placeholder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      color: color,
      fit: fit == null ? (isCover ? BoxFit.cover : null) : fit,
      placeholder: (context, url) => Image.asset(
        placeholderAsset,
        // fit: BoxFit.cover,
        fit: fit == null ? (isCover ? BoxFit.cover : null) : fit,
        color: color,
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => Image.asset(
        errorAsset,
        // fit: BoxFit.cover,
        fit: fit == null ? (isCover ? BoxFit.cover : null) : fit,
        width: width,
        height: height,
      ),
    );
  }
}
