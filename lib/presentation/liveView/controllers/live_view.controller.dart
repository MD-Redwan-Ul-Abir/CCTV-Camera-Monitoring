import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class LiveViewController extends GetxController {
  VideoPlayerController? videoPlayerController;
  int selectedCameraIndex = -1;
  bool isLoading = false;
  String currentTime = '';
  Timer? timeTimer;

  @override
  void onInit() {
    super.onInit();
    _startTimeTimer();
  }

  @override
  void onClose() {
    timeTimer?.cancel();
    videoPlayerController?.dispose();
    super.onClose();
  }

  void _startTimeTimer() {
    _updateCurrentTime();
    timeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateCurrentTime();
    });
  }

  void _updateCurrentTime() {
    currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    update();
  }

  void selectCamera(int index, String videoUrl) async {
    if (selectedCameraIndex == index) return; // Already selected

    selectedCameraIndex = index;
    isLoading = true;
    update();

    try {
      // Dispose previous controller if exists
      if (videoPlayerController != null) {
        await videoPlayerController!.dispose();
      }

      // Create new video player controller
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      // Initialize the controller
      await videoPlayerController!.initialize();

      // Start playing the video
      videoPlayerController!.play();

      isLoading = false;
      update();
    } catch (e) {
      print('Error loading video: $e');
      isLoading = false;
      selectedCameraIndex = -1;
      update();

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to load camera feed',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void togglePlayPause() {
    if (videoPlayerController != null &&
        videoPlayerController!.value.isInitialized) {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
      } else {
        videoPlayerController!.play();
      }
      update();
    }
  }
}
