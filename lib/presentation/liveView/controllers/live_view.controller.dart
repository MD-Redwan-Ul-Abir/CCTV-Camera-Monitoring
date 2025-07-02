import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LiveViewController extends GetxController {
  RxList<Map<String, String>> cameraList = [
    {
      'camera': 'camera 01',
      'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/101',
    },
    {
      'camera': 'camera 02',
      'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/102',
    },
    {
      'camera': 'camera 03',
      'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/103',
    },
    {
      'camera': 'camera 04',
      'url': 'rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/104',
    },
  ].obs;

  VlcPlayerController? vlcPlayerController;
  int selectedCameraIndex = -1;
  bool isLoading = false;
  var isInitialized = false.obs;
  String currentTime = '';
  Timer? timeTimer;

  @override
  void onInit() {
    super.onInit();
    startTimeTimer();
    // Auto-select first camera
    if (cameraList.isNotEmpty && selectedCameraIndex == -1) {
      selectCamera(0, cameraList[0]['url']!);
      isInitialized(true);
      var x=isInitialized.value;
    }
  }

  @override
  void onClose() {
    timeTimer?.cancel();
    vlcPlayerController?.dispose();
    super.onClose();
  }

  void selectCamera(int index, String videoUrl) async {
    if (selectedCameraIndex == index) return; // Already selected

    // Set loading state
    isLoading = true;
    isInitialized(false);
    selectedCameraIndex = index;
    update();

    try {
      // Dispose previous controller if exists
      if (vlcPlayerController != null) {
        await vlcPlayerController!.dispose();
      }

      // Create new controller
      vlcPlayerController = VlcPlayerController.network(
        videoUrl,
        hwAcc: HwAcc.full,
        autoPlay: true,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(2000),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
          ]),
        ),
      );

      // Add initialization listener
      vlcPlayerController!.addOnInitListener(() async {
        print('VLC Player initialized');
        isInitialized(true);
        isLoading = false;
        update();
      });

      // Add error listener
      // vlcPlayerController!.addOnErrorListener(() {
      //   print('VLC Player error occurred');
      //   isLoading = false;
      //   isInitialized = false;
      //   update();
      // });

      // Initialize the controller
      await vlcPlayerController!.initialize();

    } catch (e) {
      print('Error loading video: $e');
      isLoading = false;
      isInitialized(false);
      selectedCameraIndex = -1;
      update();
    }
  }

  Widget playVideo() {
    if (vlcPlayerController == null) {
      return Center(
        child: Text(
          'No camera selected',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return VlcPlayer(
      controller: vlcPlayerController!,
      aspectRatio: 16 / 9,
      placeholder: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  void startTimeTimer() {
    timeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      update();
    });
  }

  void togglePlayPause() {
    if (vlcPlayerController != null && isInitialized.value) {
      if (vlcPlayerController!.value.isPlaying) {
        vlcPlayerController!.pause();
      } else {
        vlcPlayerController!.play();
      }
      update();
    }
  }

  void stopPlayer() {
    if (vlcPlayerController != null && isInitialized.value) {
      vlcPlayerController!.stop();
      update();
    }
  }
}