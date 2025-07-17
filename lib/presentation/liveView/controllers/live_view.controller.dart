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
      'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/102',
    },
    {
      'camera': 'camera 03',
      'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/103',
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
    disposeVlcController();

    vlcController = VlcPlayerController.network(
      url,
      autoPlay: true,
      options: VlcPlayerOptions(
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
          ":rtsp-tcp",
        ]),
      ),
    );

    // Listen to player state changes
    vlcController!.addListener(() {
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
    if (vlcController != null && hasCameraSelected) {
      isFullScreen.value = true;
      showFullScreenButton.value = false;

      // Navigate to full screen player
      Get.to(() => FullScreenVideoPlayer(
        vlcController: vlcController!,
        controller: this,
      ));
    }
  }

  // Exit full screen mode
  void exitFullScreen() {
    isFullScreen.value = false;
    Get.back();

    // Reinitialize VLC controller to fix potential rendering issues
    if (selectedCameraUrl.value.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 100), () {
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