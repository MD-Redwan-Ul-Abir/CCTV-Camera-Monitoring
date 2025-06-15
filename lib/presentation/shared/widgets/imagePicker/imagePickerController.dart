import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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

  /// Sets license image
  void setLicenseImage(File image) {
    selectedLicenseImage.value = image;
    profileImagePath.value = image.path;
    imageBytes.value = image.readAsBytesSync();
    update();
    print('Image path: ${profileImagePath.value}');
  }

  /// Adds image to the list
  void addImage(File image) {
    if (selectedImages.length < 3) {
      selectedImages.add(image);
      update();
      print('Added image: ${image.path}');
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
    final pickedFile = await ImagePicker().pickImage(source: source);
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