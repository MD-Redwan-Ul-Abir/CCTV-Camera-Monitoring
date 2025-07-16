import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/app_images.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../model/siteDetailsModel.dart';

class SiteDetailsController extends GetxController {
  final ApiClient _apiClient = Get.find();
  String siteID = Get.arguments;
  RxBool isLoading = false.obs;
  RxString role = "manager".obs;
  String? token;
  Rxn<SiteDetailsModel> siteDetails = Rxn<SiteDetailsModel>();



  Future<void> getSiteDetails() async {
    isLoading.value = true;
    /// -----------------site ID Found----------------------
    print(siteID);
    try {
      token = await SecureStorageHelper.getString("accessToken");
      final response = await _apiClient.getData(ApiConstants.getASiteBySiteID(siteID: siteID,role: role.value),
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        siteDetails.value = SiteDetailsModel.fromJson(response.body);
        CustomSnackbar.show(
          title: "Success",
          message: "Site Data found",
        );
      }
      /// -----------------more task to be needed----------------------
      else if(response.statusCode == 400){
        if((!Get.isSnackbarOpen)){

          CustomSnackbar.show(
            title: "Error!",
            message: "Report Could not be fached",
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
