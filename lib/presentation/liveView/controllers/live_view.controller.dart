import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';

import '../live_view.screen.dart';

class LiveViewController extends GetxController {
  // Camera list with name and URL
  RxList<Map<String, String>> cameraList = [
    {
      'camera': 'camera 01',
      'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/102',
    },
    {
      'camera': 'camera 02',
      'url': 'rtsp://rtspstream:IvYPUxye7TBTyYkuB_B3e@zephyr.rtsp.stream/movie',
    },
    {
      'camera': 'camera 03',
      'url': 'rtsp://rtspstream:IvYPUxye7TBTyYkuB_B3e@zephyr.rtsp.stream/traffic',
    },
  ].obs;

  // Selected camera index and URL
  RxInt selectedCameraIndex = (-1).obs;
  RxString selectedCameraUrl = ''.obs;

  // VLC Player Controller
  VlcPlayerController? vlcController;

  // Loading state
  RxBool isVideoLoading = false.obs;

  // Full screen button visibility
  RxBool showFullScreenButton = false.obs;
  Timer? fullScreenTimer;

  // Full screen state
  RxBool isFullScreen = false.obs;

  // Add a key to force widget rebuild
  RxInt vlcPlayerKey = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkAndSelectFirstCamera();
  }

  @override
  void onClose() {
    fullScreenTimer?.cancel();
    disposeVlcController();
    super.onClose();
  }

  // Dispose VLC controller properly
  void disposeVlcController() {
    vlcController?.dispose();
    vlcController = null;
  }

  // Create new VLC controller
  void createVlcController(String url) {
    // Force re-creation by disposing any existing controller first
    disposeVlcController();

    isVideoLoading.value = true;

    // Increment key to force widget rebuild
    vlcPlayerKey.value++;

    vlcController = VlcPlayerController.network(
      url,
      autoPlay: true,
      hwAcc: HwAcc.full, // Force hardware acceleration
      options: VlcPlayerOptions(
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
          ":rtsp-tcp",
        ]),
      ),
    );

    vlcController!.addListener(() {
      if (vlcController!.value.hasError) {
        print("VLC Error: ${vlcController!.value.errorDescription}");
      }

      if (vlcController!.value.isInitialized) {
        isVideoLoading.value = false;
      }
    });
  }

  // Check if camera list is not empty and auto-select first camera
  void checkAndSelectFirstCamera() {
    if (cameraList.isNotEmpty) {
      selectedCameraIndex.value = 0;
      selectedCameraUrl.value = cameraList[0]['url']!;
      isVideoLoading.value = true;
      createVlcController(selectedCameraUrl.value);
      print('Auto-selected first camera: ${cameraList[0]['camera']} with URL: ${selectedCameraUrl.value}');
    } else {
      selectedCameraIndex.value = -1;
      selectedCameraUrl.value = '';
      isVideoLoading.value = false;
      print('No cameras available');
    }
  }

  // Select camera by index
  void selectCamera(int index) {
    if (index >= 0 && index < cameraList.length) {
      selectedCameraIndex.value = index;
      selectedCameraUrl.value = cameraList[index]['url']!;
      isVideoLoading.value = true;
      createVlcController(selectedCameraUrl.value);
      print('Selected camera: ${cameraList[index]['camera']} with URL: ${selectedCameraUrl.value}');
    }
  }

  // Show full screen icon for 4 seconds
  void showFullScreenIcon() {
    showFullScreenButton.value = true;

    // Cancel previous timer if exists
    fullScreenTimer?.cancel();

    // Start new timer for 4 seconds
    fullScreenTimer = Timer(Duration(seconds: 4), () {
      showFullScreenButton.value = false;
    });
  }

  // Enter full screen mode
  void enterFullScreen() {
    if (hasCameraSelected) {
      isFullScreen.value = true;
      showFullScreenButton.value = false;

      // Create a new controller for fullscreen
      final newController = VlcPlayerController.network(
        selectedCameraUrl.value,
        autoPlay: true,
        hwAcc: HwAcc.full,
        options: VlcPlayerOptions(
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
            ":rtsp-tcp",
          ]),
        ),
      );

      newController.addListener(() {
        if (newController.value.hasError) {
          print("Fullscreen VLC Error: ${newController.value.errorDescription}");
        }
      });

      // Navigate to fullscreen with the new controller
      Get.to(() => FullScreenVideoPlayer(
        vlcController: newController,
        controller: this,
      ));
    }
  }

  // Exit full screen mode - FIXED VERSION
  void exitFullScreen() {
    isFullScreen.value = false;
    Get.back();

    // Force complete re-initialization of VLC controller
    if (selectedCameraUrl.value.isNotEmpty) {
      // Add a small delay to ensure the UI has settled
      Future.delayed(Duration(milliseconds: 200), () {
        // Force rebuild by incrementing key first
        vlcPlayerKey.value++;

        // Then recreate the controller
        createVlcController(selectedCameraUrl.value);
      });
    }
  }

  // Check if any camera is selected
  bool get hasCameraSelected => selectedCameraIndex.value >= 0;

  // Get selected camera name
  String get selectedCameraName {
    if (hasCameraSelected) {
      return cameraList[selectedCameraIndex.value]['camera']!;
    }
    return 'No camera selected';
  }
}