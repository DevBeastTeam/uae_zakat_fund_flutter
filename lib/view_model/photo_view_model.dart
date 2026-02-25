import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';

class PhotoViewModel extends GetxController {
  late String imagePath;
  late ImageProvider imageProvider;
  bool isNetworkImage = true;

  ImageStream? _imageStream;
  ImageStreamListener? _listener;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  void _initializeData() {
    imagePath = Get.arguments;
    imageProvider = isNetworkImage
        ? NetworkImage("${FlavorConfig.storageUrl}$imagePath")
        : FileImage(File(imagePath)) as ImageProvider;
  }

  Future<Size> getImageSize() async {
    final Completer<Size> completer = Completer();
    _imageStream = imageProvider.resolve(const ImageConfiguration());

    _listener = ImageStreamListener((ImageInfo info, bool _) {
      final myImage = info.image;
      if (!completer.isCompleted) {
        completer.complete(Size(
          myImage.width.toDouble(),
          myImage.height.toDouble(),
        ));
      }
      _removeListener();
    });

    _imageStream?.addListener(_listener!);
    return completer.future;
  }

  void _removeListener() {
    if (_imageStream != null && _listener != null) {
      _imageStream!.removeListener(_listener!);
      _listener = null;
      _imageStream = null;
    }
  }

  @override
  void onClose() {
    _removeListener();
    super.onClose();
  }
}
