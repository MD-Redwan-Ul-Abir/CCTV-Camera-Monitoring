import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../../languageChanging/appString.dart';
import '../model/privacyModel.dart';

class PrivacySettingsController extends GetxController {
  final ApiClient _apiClient = Get.find();
  RxBool isLoading = false.obs;
  String? token;
  Rxn<PrivacySettingsModel> privacySettings = Rxn<PrivacySettingsModel>();
  RxList<Attribute> privacyAttributes = <Attribute>[].obs;
  //Rxn<List<PrivacySettingsModel>> privacySettings = Rxn<List<PrivacySettingsModel>>();
  RxDouble rating = 0.0.obs;

  void updateRating(double newRating) {
    rating.value = newRating;
  }



  Future<void> getPrivacyData() async {
    isLoading.value = true;
    try {
      token = await SecureStorageHelper.getString("accessToken");


      final response = await _apiClient.getData(ApiConstants.getPrivacyData,
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        privacySettings.value = PrivacySettingsModel.fromJson(response.body);

        if (privacySettings.value?.data?.attributes != null) {
          privacyAttributes.value = privacySettings.value!.data!.attributes!;
        }

      }
      /// -----------------more task to be needed----------------------
      else if(response.statusCode == 400){
        if(!Get.isSnackbarOpen){
          CustomSnackbar.show(
            title: AppStrings.oopsTitle.tr,
            message: AppStrings.sessionExpiredMessage.tr,
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



  Attribute? getAttributeByType(String type) {
    return privacyAttributes.firstWhereOrNull((attr) => attr.type == type);
  }

  // Get all attribute details
  List<String> getAllAttributeDetails() {
    return privacyAttributes
        .where((attr) => attr.details != null)
        .map((attr) => attr.details!)
        .toList();
  }

}
