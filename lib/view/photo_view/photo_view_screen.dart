import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/view_model/photo_view_model.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class PhotoViewScreen extends GetView<PhotoViewModel> {
  const PhotoViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: myAppBar(title: "preview"),
      body: _buildBody(),
    );
  }

  Center _buildBody() {
    return Center(
      child: FutureBuilder<Size>(
        future: controller.getImageSize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final size = snapshot.data!;
            final aspectRatio = size.width / size.height;
            return AspectRatio(
              aspectRatio: aspectRatio,
              child: controller.isNetworkImage
                  ? CachedNetworkImage(
                      imageUrl:
                          "${FlavorConfig.storageUrl}${controller.imagePath}",
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Image.asset(
                          AppResources.placeholder,
                          fit: BoxFit.cover),
                      errorWidget: (_, __, ___) => Image.asset(
                          AppResources.placeholder,
                          fit: BoxFit.cover))
                  : Image.file(File(controller.imagePath)),
            );
          } else {
            return CircularProgressIndicator(color: themeViewModel.color);
          }
        },
      ),
    );
  }
}
