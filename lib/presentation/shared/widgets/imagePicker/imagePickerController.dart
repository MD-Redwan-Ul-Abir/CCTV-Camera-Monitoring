import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import 'package:flutter/material.dart';

class imagePickerController extends GetxController {
  // Selected license image file
  Rx<File?> selectedLicenseImage = Rx<File?>(null);

  // Selected video file
  Rx<File?> selectedVideo = Rx<File?>(null);

  // List to store multiple images
  RxList<File> selectedImages = <File>[].obs;

  // Path of the picked profile image
  RxString profileImagePath = ''.obs;

  // Path of the picked video
  RxString videoPath = ''.obs;

  // Video name for display
  RxString videoName = ''.obs;

  // Image bytes (if needed for display or upload)
  Rx<List<int>> imageBytes = Rx<List<int>>([]);

  // Video bytes (if needed for upload)
  Rx<List<int>> videoBytes = Rx<List<int>>([]);

  /// Sets license image with compression
  Future<void> setLicenseImage(File image) async {
    try {
      File? compressedImage = await compressImageNative(image);
      File finalImage = compressedImage ?? image;

      selectedLicenseImage.value = finalImage;
      profileImagePath.value = finalImage.path;
      imageBytes.value = finalImage.readAsBytesSync();
      update();
      print('Image path: ${profileImagePath.value}');
      print('Image size: ${finalImage.lengthSync()} bytes');
    } catch (e) {
      print('Error setting license image: $e');
      // Fallback to original image
      selectedLicenseImage.value = image;
      profileImagePath.value = image.path;
      imageBytes.value = image.readAsBytesSync();
      update();
    }
  }

  /// Adds image to the list with native compression
  Future<void> addImage(File image) async {
    if (selectedImages.length < 3) {
      try {
        // Try native compression
        File? compressedImage = await compressImageNative(image);

        if (compressedImage != null) {
          selectedImages.add(compressedImage);
          update();
          print('Added compressed image: ${compressedImage.path}');
          print('Original size: ${image.lengthSync()} bytes');
          print('Compressed size: ${compressedImage.lengthSync()} bytes');
        } else {
          // Fallback: use original image if compression fails
          selectedImages.add(image);
          update();
          print('Added original image (compression failed): ${image.path}');
        }
      } catch (e) {
        print('Error adding image: $e');
        // Fallback: add original image
        selectedImages.add(image);
        update();
      }
    } else {
      print('Maximum of 3 images allowed');
    }
  }

  /// Native image compression using Flutter's built-in capabilities
  Future<File?> compressImageNative(File imageFile, {int maxWidth = 800, int maxHeight = 600}) async {
    try {
      LoggerHelper.debug('Starting native compression for: ${imageFile.path}');
      // Read the image file as bytes
      Uint8List imageBytes = await imageFile.readAsBytes();
      LoggerHelper.debug('Original image size: ${imageBytes.length} bytes');

      // First decode to get original dimensions
      ui.Codec originalCodec = await ui.instantiateImageCodec(imageBytes);
      ui.FrameInfo originalFrameInfo = await originalCodec.getNextFrame();
      ui.Image originalImage = originalFrameInfo.image;

      int originalWidth = originalImage.width;
      int originalHeight = originalImage.height;
      LoggerHelper.debug('Original dimensions: ${originalWidth}x${originalHeight}');

      // Calculate new dimensions while preserving aspect ratio
      double aspectRatio = originalWidth / originalHeight;
      int targetWidth, targetHeight;

      if (originalWidth > maxWidth || originalHeight > maxHeight) {
        if (aspectRatio > 1) {
          // Landscape orientation - width is larger
          targetWidth = maxWidth;
          targetHeight = (maxWidth / aspectRatio).round();

          // If calculated height still exceeds maxHeight, adjust based on height
          if (targetHeight > maxHeight) {
            targetHeight = maxHeight;
            targetWidth = (maxHeight * aspectRatio).round();
          }
        } else {
          // Portrait orientation - height is larger
          targetHeight = maxHeight;
          targetWidth = (maxHeight * aspectRatio).round();

          // If calculated width still exceeds maxWidth, adjust based on width
          if (targetWidth > maxWidth) {
            targetWidth = maxWidth;
            targetHeight = (maxWidth / aspectRatio).round();
          }
        }
      } else {
        // Image is already smaller than max dimensions, keep original size
        targetWidth = originalWidth;
        targetHeight = originalHeight;
      }

      LoggerHelper.debug('Target dimensions: ${targetWidth}x${targetHeight}');
      originalImage.dispose(); // Clean up memory

      // Decode with target dimensions
      ui.Codec codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: targetWidth,
        targetHeight: targetHeight,
      );
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      ui.Image image = frameInfo.image;

      // Convert to byte data with compression
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        LoggerHelper.debug('Failed to convert image to byte data');
        image.dispose();
        return null;
      }

      Uint8List compressedBytes = byteData.buffer.asUint8List();
      LoggerHelper.error('Compressed image size: ${compressedBytes.length} bytes');

      // Create compressed file path
      String directory = imageFile.parent.path;
      String fileName = path.basenameWithoutExtension(imageFile.path);
      String extension = path.extension(imageFile.path);
      String compressedPath = '$directory/compressed_${DateTime.now().millisecondsSinceEpoch}_$fileName$extension';

      // Write compressed bytes to new file
      File compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);

      LoggerHelper.error('Compressed image saved to: ${compressedFile.path}');
      LoggerHelper.error('Compression ratio: ${((imageBytes.length - compressedBytes.length) / imageBytes.length * 100).toStringAsFixed(1)}%');
      LoggerHelper.error('Aspect ratio preserved: ${(targetWidth / targetHeight).toStringAsFixed(3)} vs original: ${aspectRatio.toStringAsFixed(3)}');

      image.dispose(); // Clean up memory
      return compressedFile;

    } catch (e) {
      LoggerHelper.debug('Native compression failed: $e');
      return null;
    }
  }

  /// Alternative compression method with JPEG encoding (requires image package)
  Future<File?> compressImageWithImagePackage(File imageFile) async {
    try {
      // This method requires adding the 'image' package to pubspec.yaml
      // For now, we'll just return null to use the fallback
      LoggerHelper.debug('Image package compression not implemented');
      return null;
    } catch (e) {
      LoggerHelper.debug('Image package compression failed: $e');
      return null;
    }
  }

  /// Simple file size reduction by reducing quality (basic implementation)
  Future<File?> reduceImageQuality(File imageFile) async {
    try {
      // Read original bytes
      Uint8List originalBytes = await imageFile.readAsBytes();

      // Create a new file with reduced quality (this is a basic approach)
      String directory = imageFile.parent.path;
      String fileName = path.basenameWithoutExtension(imageFile.path);
      String extension = path.extension(imageFile.path);
      String reducedPath = '$directory/reduced_${DateTime.now().millisecondsSinceEpoch}_$fileName$extension';

      // For now, just copy the file (you can implement actual quality reduction here)
      File reducedFile = File(reducedPath);
      await reducedFile.writeAsBytes(originalBytes);

      return reducedFile;
    } catch (e) {
      LoggerHelper.debug('Quality reduction failed: $e');
      return null;
    }
  }

  /// Removes image from the list at specific index
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      update();
    }
  }

  /// Sets selected video
  void setVideo(File video) {
    selectedVideo.value = video;
    videoPath.value = video.path;
    videoName.value = path.basename(video.path);
    videoBytes.value = video.readAsBytesSync();
    update();
    print('Video path: ${videoPath.value}');
    print('Video name: ${videoName.value}');
  }

  /// Picks an image from the specified source (camera or gallery)
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1920, // Limit image width
      maxHeight: 1080, // Limit image height
      imageQuality: 85, // Set quality (0-100)
    );
    if (pickedFile == null) return;

    final File imageFile = File(pickedFile.path);
    addImage(imageFile);
  }

  /// Picks a video from the specified source (camera or gallery)
  Future<void> pickVideo(ImageSource source) async {
    final pickedFile = await ImagePicker().pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 5), // Optional: set max duration
    );
    if (pickedFile == null) return;

    final File videoFile = File(pickedFile.path);
    setVideo(videoFile);
  }

  /// Picks a video from gallery specifically
  Future<void> pickVideoFromGallery() async {
    await pickVideo(ImageSource.gallery);
  }

  /// Picks a video from camera specifically
  Future<void> pickVideoFromCamera() async {
    await pickVideo(ImageSource.camera);
  }

  /// Clear selected image
  void clearImage() {
    selectedLicenseImage.value = null;
    profileImagePath.value = '';
    imageBytes.value = [];
    update();
  }

  /// Clear all selected images
  void clearAllImages() {
    selectedImages.clear();
    update();
  }

  /// Clear selected video
  void clearVideo() {
    selectedVideo.value = null;
    videoPath.value = '';
    videoName.value = '';
    videoBytes.value = [];
    update();
  }

  /// Clear all selections
  void clearAll() {
    clearImage();
    clearAllImages();
    clearVideo();
  }
}