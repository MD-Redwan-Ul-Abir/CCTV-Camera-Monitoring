import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/networkImageFormating.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../model/detailsReportModel.dart';

class DetailsReportController extends GetxController {
  final ApiClient _apiClient = Get.find();
  Rxn<DetailsReportModel> detailsReport = Rxn<DetailsReportModel>();
  String reportID = Get.arguments;
  RxBool isLoading = false.obs;
  RxString profileImageUrl=''.obs;
  String? token;



  void updateProfileImage() {
    try {
      final imageUrl = detailsReport.value?.data?.attributes!.person!.first.personId!.profileImage!.imageUrl;
      profileImageUrl.value = ProfileImageHelper.formatImageUrl(imageUrl);
      print(profileImageUrl.value);
    } catch (e) {
      print("Error updating profile image: $e");
      profileImageUrl.value = "";
    }
  }


  ///-----------------------------get data-----------------------------------------

  Future<void> getReportDetails() async {
    isLoading.value = true;
    /// -----------------site ID Found----------------------
    print(reportID);
    try {
      token = await SecureStorageHelper.getString("accessToken");
      final response = await _apiClient.getData(ApiConstants.getAReportByReportID(reportID: reportID),
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        detailsReport.value = DetailsReportModel.fromJson(response.body);
        updateProfileImage();
        // CustomSnackbar.show(
        //   title: "Success",
        //   message: "Site Data found",
        // );
      }
      /// -----------------more task to be needed----------------------
      else if(response.statusCode == 400){
        if((!Get.isSnackbarOpen)){

          CustomSnackbar.show(
            title: "Error!",
            message: "Report Could not be faced",
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
