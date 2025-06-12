import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class imagePickerController extends GetxController {
  // Selected license image file
  Rx<File?> selectedLicenseImage = Rx<File?>(null);

  // Path of the picked profile image
  RxString profileImagePath = ''.obs;

  // Image bytes (if needed for display or upload)
  Rx<List<int>> imageBytes = Rx<List<int>>([]);

  /// Sets license image
  void setLicenseImage(File image) {
    selectedLicenseImage.value = image;
    profileImagePath.value = image.path;
    imageBytes.value = image.readAsBytesSync();
    update();
    print('Image path: ${profileImagePath.value}');
  }

  /// Picks an image from the specified source (camera or gallery)
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    final File imageFile = File(pickedFile.path);
    setLicenseImage(imageFile);
  }
}
