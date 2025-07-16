import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    // {
    //   'camera': 'camera 04',
    //   'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/104',
    // },
  ].obs;

  // Selected camera index and URL
  RxInt selectedCameraIndex = (-1).obs;
  RxString selectedCameraUrl = ''.obs;

  // Current time for display
  RxString currentTime = ''.obs;
  Timer? timeTimer;

  @override
  void onInit() {
    super.onInit();
    startTimeTimer();
    checkAndSelectFirstCamera();
  }

  @override
  void onClose() {
    timeTimer?.cancel();
    super.onClose();
  }

  // Check if camera list is not empty and auto-select first camera
  void checkAndSelectFirstCamera() {
    if (cameraList.isNotEmpty) {
      selectedCameraIndex.value = 0;
      selectedCameraUrl.value = cameraList[0]['url']!;
      print('Auto-selected first camera: ${cameraList[0]['camera']} with URL: ${selectedCameraUrl.value}');
    } else {
      selectedCameraIndex.value = -1;
      selectedCameraUrl.value = '';
      print('No cameras available');
    }
  }

  // Select camera by index
  void selectCamera(int index) {
    if (index >= 0 && index < cameraList.length) {
      selectedCameraIndex.value = index;
      selectedCameraUrl.value = cameraList[index]['url']!;
      print('Selected camera: ${cameraList[index]['camera']} with URL: ${selectedCameraUrl.value}');
    }
  }

  // Start time timer for current time display
  void startTimeTimer() {
    timeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
    });
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