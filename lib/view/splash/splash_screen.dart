import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';

class SplashInitPage extends StatefulWidget {
  const SplashInitPage({super.key});

  @override
  State<SplashInitPage> createState() => _SplashInitPageState();
}

class _SplashInitPageState extends State<SplashInitPage> {
  VideoPlayerController? _controller;
  late Timer showBottomLogo;
  @override
  void initState() {
    showBottomLogo = Timer(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {});
      }
    });
    if (uuidBox.isEmpty) {
      uuidBox.add(const Uuid().v4());
    }

    _controller = splashVideoController;
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.setLooping(true);
      _controller!.setVolume(0);
      _controller!.play();
    }

    Future.delayed(Duration(seconds: 6)).then((_) {
      if (appLangBox.isEmpty) {
        Get.offNamed(AppRoutes.splashScreen);
      } else {
        if (onboardingBox.isEmpty) {
          Get.offNamed(AppRoutes.onBoardingScreen);
        } else {
          Get.offNamed(AppRoutes.mainScreen);
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.white,
      body: controller != null && controller.value.isInitialized
          ? Center(
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(
                        controller,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    right: 10,
                    child: Visibility(
                      visible: (!showBottomLogo.isActive),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Image.asset(
                            "assets/images/Logo 3 1.png",
                            width: double.maxFinite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: Image.asset(AppResources.splashGif)),
    );
  }
}
