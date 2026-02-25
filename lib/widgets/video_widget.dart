import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String video;
  final bool isAsset;

  const VideoPlayerWidget(
      {super.key, required this.video, required this.isAsset});

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerWidgetState();
  }
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
   VideoPlayerController? playerController;
  ChewieController? chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    playerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    widget.isAsset ? fileVideoPlayer() : await networkVideoPlayer();

    await Future.wait([
      playerController!.initialize()
    ]);
    _createChewieController();
    if (mounted) setState(() {});
  }

  networkVideoPlayer() async {
    File fileStream = await DefaultCacheManager().getSingleFile("${FlavorConfig.storageUrl}${widget.video}");

    playerController = VideoPlayerController.file(fileStream);
    // playerController = VideoPlayerController.networkUrl(
    //     Uri.parse("${ApiConstant.imageUrl}${widget.video}"));
  }

  fileVideoPlayer() {
    playerController = VideoPlayerController.file(File(widget.video));
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: playerController!,
      autoPlay: false,
      looping: false,
        deviceOrientationsAfterFullScreen:[DeviceOrientation.portraitUp],
      controlsSafeAreaMinimum:
          EdgeInsets.only(bottom: 8.h),
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.black,
      child: chewieController != null &&
              chewieController!.videoPlayerController.value.isInitialized
          ? Center(child: Chewie(controller: chewieController!))
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
