import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';

class ProfileController extends GetxController {

  final ApiClient _apiClient = Get.find();
  RxBool isLoading = false.obs;
  String? token;

  @override
  void onInit() {
    super.onInit();
    rating.value = 0.0;
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
      token = await SecureStorageHelper.getString("accessToken");


      final response = await _apiClient.getData(ApiConstants.postReviewAndRatings,
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {



      }
      /// -----------------more task to be needed----------------------
      else if(response.statusCode == 400){
        if(!Get.isSnackbarOpen){
          CustomSnackbar.show(
            title: "Oops!",
            message: "Session Expired",
          );
        }

        Get.toNamed(Routes.ERROR_PAGE);
      }
    } catch (e) {
      print("Error getting profile: $e");
    } finally {
      isLoading.value = false;
    }
  }


}