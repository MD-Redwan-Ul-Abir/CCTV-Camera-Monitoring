import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../model/privacyModel.dart';

class PrivacySettingsController extends GetxController {
  final ApiClient _apiClient = Get.find();
  RxBool isLoading = false.obs;
  String? token;
  Rxn<PrivacySettingsModel> privacySettings = Rxn<PrivacySettingsModel>();
  RxDouble rating = 0.0.obs;

  void updateRating(double newRating) {
    rating.value = newRating;
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    try {
      token = await SecureStorageHelper.getString("accessToken");
      // String? roleString = await SecureStorageHelper.getString("role");
      // localPersonID = await SecureStorageHelper.getString("id");
      // role.value = roleString;


      final response = await _apiClient.getData(ApiConstants.getUserInfo,
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        privacySettings.value = PrivacySettingsModel.fromJson(response.body);

      }
      /// -----------------more task to be needed----------------------
      else if(response.statusCode == 400){
        if(!Get.isSnackbarOpen){
          CustomSnackbar.show(
            title: "Oops!",
            message: "Session Expired",
          );
        }

        Get.toNamed(Routes.NO_INTERNET);
      }
    } catch (e) {
      print("Error getting profile: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
