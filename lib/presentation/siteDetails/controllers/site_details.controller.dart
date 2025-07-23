import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';

import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/networkImageFormating.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../model/siteDetailsModel.dart';

class SiteDetailsController extends GetxController {
  final ApiClient _apiClient = Get.find();
  String siteID = Get.arguments;
  RxBool isLoading = false.obs;
  RxString role = "manager".obs;
  String? token;
  Rxn<SiteDetailsModel> siteDetails = Rxn<SiteDetailsModel>();
  RxString profileImageUrl=''.obs;


  List<String> getCarouselImages() {
    if (siteDetails.value?.data?.attributes?.results
        ?.isNotEmpty == true) {
      final siteData =siteDetails.value!.data!
          .attributes!.results!.first.siteId;
      if (siteData?.attachments?.isNotEmpty == true) {
        return siteData!.attachments!
            .map((attachment) => attachment.attachment ?? '')
            .where((url) => url.isNotEmpty)
            .toList();
      }
    }
    // Return default images if no attachments found
    return [
      "https://dzinejs.lv/wp-content/plugins/lightbox/images/No-image-found.jpg",
      "https://dzinejs.lv/wp-content/plugins/lightbox/images/No-image-found.jpg",
    ];
  }

  ///-------------------------------Image ReFormating---------------------------

  void updateProfileImage() {
    try {
      final imageUrl = siteDetails.value?.data?.attributes?.userInfo?.first.personId!.profileImage!.imageUrl;
      profileImageUrl.value = ProfileImageHelper.formatImageUrl(imageUrl);
      print(profileImageUrl.value);
    } catch (e) {
      print("Error updating profile image: $e");
      profileImageUrl.value = "";
    }
  }



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
