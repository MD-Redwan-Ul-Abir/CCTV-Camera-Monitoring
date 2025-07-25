import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../live_view.screen.dart';
import '../model/cameraListModel.dart';

class LiveViewController extends GetxController {
  final ApiClient _apiClient = Get.find();
  RxString profileImageUrl = "".obs;
  RxBool isLoading = false.obs;

  String siteId = '';
  RxString siteName = ''.obs;
  String date = '';

  RxString personId = "".obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      siteId = arguments['siteId'] ?? '';
      siteName.value = arguments['siteName'] ?? '';
      date = arguments['date'] ?? '';
    }

    // Load cameras after receiving arguments
    if (siteId.isNotEmpty) {
      getAllCamera();
    }
  }

  RxList<Map<String, String>> cameraList = <Map<String, String>>[].obs;

  RxList<CameraListBySiteIdModel> productSubCategoryList =
      <CameraListBySiteIdModel>[].obs;

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

  Future<void> getAllCamera() async {
    isLoading.value = true;
    try {
      personId.value = await SecureStorageHelper.getString("id");
      final response = await _apiClient.getData(
        ApiConstants.getCameraBySiteIdandPersonId(
          personId: personId.value,
          siteId: siteId,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response.body is already a Map or needs to be decoded
        dynamic responseData;
        if (response.body is String) {
          responseData = json.decode(response.body);
        } else {
          responseData = response.body;
        }

        final cameraResponse = CameraListBySiteIdModel.fromJson(responseData);

        // Extract the list of cameras and update your RxList
        if (cameraResponse.data?.attributes != null) {
          List<Map<String, String>> apiCameraList = [];

          for (var attribute in cameraResponse.data!.attributes!) {
            if (attribute.cameraId?.cameraName != null &&
                attribute.cameraId?.rtspUrl != null) {
              apiCameraList.add({
                'camera': attribute.cameraId!.cameraName!,
                'url': attribute.cameraId!.rtspUrl!,
              });
            }
          }

          // Update your existing camera list with API data
          cameraList.value = apiCameraList;

          // Also store the full model list if needed elsewhere
          productSubCategoryList.clear();
          productSubCategoryList.add(cameraResponse);

          // Debug print to verify cameras are loaded
          print("Loaded ${apiCameraList.length} cameras:");
          for (var camera in apiCameraList) {
            print("Camera: ${camera['camera']}, URL: ${camera['url']}");
          }

          // Auto-select first camera after loading
          checkAndSelectFirstCamera();
        } else {
          print("No camera attributes found in response");
        }
      } else if (response.statusCode == 400) {
        CustomSnackbar.show(title: "Oops!", message: "Session Expired");
        Get.toNamed(Routes.ERROR_PAGE);
      } else {
        print("API request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getting cameras: $e");
      print("Stack trace: ${StackTrace.current}");
    } finally {
      isLoading.value = false;
    }
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
        rtp: VlcRtpOptions([VlcRtpOptions.rtpOverRtsp(true), ":rtsp-tcp"]),
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
      print(
        'Auto-selected first camera: ${cameraList[0]['camera']} with URL: ${selectedCameraUrl.value}',
      );
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
      print(
        'Selected camera: ${cameraList[index]['camera']} with URL: ${selectedCameraUrl.value}',
      );
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
          rtp: VlcRtpOptions([VlcRtpOptions.rtpOverRtsp(true), ":rtsp-tcp"]),
        ),
      );

      newController.addListener(() {
        if (newController.value.hasError) {
          print(
            "Fullscreen VLC Error: ${newController.value.errorDescription}",
          );
        }
      });

      // Navigate to fullscreen with the new controller
      Get.to(
        () => FullScreenVideoPlayer(
          vlcController: newController,
          controller: this,
        ),
      );
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

