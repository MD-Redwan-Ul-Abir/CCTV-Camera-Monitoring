import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = Get.find();
  final commentController = TextEditingController();
  final GlobalKey<FormState> reviewFormKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  String? token;

  @override
  Future<void> onInit() async {
    super.onInit();
    rating.value = 0.0;
    token = await SecureStorageHelper.getString("accessToken");
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
        headers:
            token != null && token!.isNotEmpty
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
      print("--------------------------ratings data------------------------");
      print(ratingsData);
      final response = await _apiClient.postData(
        ApiConstants.postReviewAndRatings,
        ratingsData,
        // headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;

        Get.snackbar(
          "Submitted",
          response.body["message"],
          backgroundColor: AppColors.primaryNormal,
          colorText: AppColors.primaryLighthover,
        );
        return true;
      } else {
        isLoading.value = false;

        CustomSnackbar.show(
          title: "Failed!",
          message: response.body["message"],
        );

        return false;
      }
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: e.toString());

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
