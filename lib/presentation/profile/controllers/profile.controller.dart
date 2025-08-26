import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/home/controllers/home.controller.dart';
import 'package:skt_sikring/presentation/languageChanging/appConst.dart';
import 'package:skt_sikring/presentation/languageChanging/languageModel.dart';
import 'package:skt_sikring/presentation/languageChanging/localizationController.dart';

import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../../shared/widgets/imagePicker/imagePickerController.dart';
import '../../languageChanging/appString.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = Get.find();
  final imageController = Get.put(imagePickerController());
  final commentController = TextEditingController();
  final userNameController = TextEditingController();
  final addressController = TextEditingController();
  final HomeController homeController = Get.find<HomeController>();
  final GlobalKey<FormState> reviewFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  String? token;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString address = "".obs;
  RxString selectedImage = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    rating.value = 0.0;
    token = await SecureStorageHelper.getString("accessToken");
    name.value = await SecureStorageHelper.getString("name");
    email.value = await SecureStorageHelper.getString("email");
    address.value = await SecureStorageHelper.getString("address");
  }

  final count = 0.obs;
  RxDouble rating = 0.0.obs;

  void updateRating(double newRating) {
    rating.value = newRating;
  }

  // Add this method to reset rating
  void resetRating() {
    rating.value = 0.0;
  }

  Future<void> getPrivacyData() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.getData(
        ApiConstants.postReviewAndRatings,
        headers: token != null && token!.isNotEmpty
            ? {"Authorization": "Bearer $token"}
            : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
      }

      /// -----------------more task to be needed----------------------
      else if (response.statusCode == 400) {
        if (!Get.isSnackbarOpen) {
          CustomSnackbar.show(title: "Oops!", message: "Session Expired");
        }

        Get.toNamed(Routes.ERROR_PAGE);
      }
    } catch (e) {
      print("Error getting profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitReview() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> ratingsData = {
        'rating': rating.value,
        'comment': commentController.text,
      };

      final response = await _apiClient.postData(
        ApiConstants.postReviewAndRatings,
        ratingsData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;

        Get.snackbar(
          AppStrings.submittedTitle.tr,
          response.body["message"],
          backgroundColor: AppColors.primaryNormal,
          colorText: AppColors.primaryLighthover,
        );
        return true;
      } else {
        isLoading.value = false;

        CustomSnackbar.show(
          title: AppStrings.failedTitle.tr,
          message: response.body["message"],
        );

        return false;
      }
    } catch (e) {
      CustomSnackbar.show(title: AppStrings.errorTitle.tr, message: e.toString());

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfilePicture() async {
    try {

      if (imageController.selectedImages.isEmpty) {
        CustomSnackbar.show(
            title: "Error", message: "Please select an image first");
        return false;
      }

      isLoading.value = true;

      List<MultipartBody> files = imageController.selectedImages
          .map((file) => MultipartBody('profileImage', file))
          .toList();

      final response = await _apiClient.putData(
        ApiConstants.updateProfilePicture,
        null,
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Picture updated",
          response.body["message"] ?? "Profile picture updated successfully",
          backgroundColor: AppColors.primaryNormal,
          colorText: AppColors.primaryLighthover,
        );
        homeController.getProfile();
        homeController.fetchedData.value = false;
        if (response.body != null &&
            response.body["data"] != null &&
            response.body["data"]["profileImageUrl"] != null) {
          homeController.profileImageUrl.value =
              response.body["data"]["profileImageUrl"];
          await SecureStorageHelper.setString(
              "profileImageUrl", response.body["data"]["profileImageUrl"]);
        }
        String imageURL =
            await SecureStorageHelper.getString("profileImageUrl");

        return true;
      } else {
        CustomSnackbar.show(
          title: AppStrings.failedTitle.tr,
          message:
              response.body?["message"] ?? "Failed to update profile picture",
        );
        return false;
      }
    } catch (e) {
      CustomSnackbar.show(title: AppStrings.errorTitle.tr, message: e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> editProfile() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> updatedUserData = {
        'name':
            userNameController.text.isEmpty ? name.value : userNameController.text,
        'address': addressController.text.isEmpty
            ? address.value
            : addressController.text,
      };

      final response = await _apiClient.putData(
        ApiConstants.updateUserProfile,
        updatedUserData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        name.value = userNameController.text;
        homeController.fetchedData.value = false;
        await SecureStorageHelper.setString("name",
            userNameController.text.isEmpty ? name.value : userNameController.text);
        await SecureStorageHelper.setString(
            "address",
            addressController.text.isEmpty
                ? address.value
                : addressController.text);

        Get.snackbar(
          "Info updated",
          response.body["message"],
          backgroundColor: AppColors.primaryNormal,
          colorText: AppColors.primaryLighthover,
        );
        return true;
      } else {
        isLoading.value = false;

        CustomSnackbar.show(
          title: AppStrings.failedTitle.tr,
          message: response.body["message"],
        );

        return false;
      }
    } catch (e) {
      CustomSnackbar.show(title: AppStrings.errorTitle.tr, message: e.toString());

      return false;
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> changeLanguage(String languageName) async {
    try {
      final localizationController = Get.find<LocalizationController>();

      for (int index = 0; index < AppConstants.languages.length; index++) {
        var language = AppConstants.languages[index];
        if (language.languageName == languageName) {
          // Use the LocalizationController's setLanguage method which handles saving
          localizationController.setLanguage(
              Locale(language.languageCode, language.countryCode)
          );
          // Also update the selected index
          localizationController.setSelectIndex(index);

          print("Language changed and saved: $languageName (${language.languageCode}-${language.countryCode})");
          break;
        }
      }
    } catch (e) {
      print("Error changing language: $e");
    }
  }


  List<LanguageModel> getAvailableLanguages() {
    return AppConstants.languages;
  }
}