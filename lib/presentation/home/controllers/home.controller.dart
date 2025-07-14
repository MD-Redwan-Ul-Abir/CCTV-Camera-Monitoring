import 'package:get/get.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../model/profileDetails.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find();
  Rxn<ProfileDetailsModel> profileDetails = Rxn<ProfileDetailsModel>();
  RxString profileImageUrl = "".obs;
  RxBool isLoading = false.obs;
   var token;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  void updateProfileImage() {
    try {
      final imageUrl = profileDetails.value?.data?.attributes?.profileImage?.imageUrl;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        if (imageUrl.startsWith('http')) {
          profileImageUrl.value = imageUrl;
        } else {
          profileImageUrl.value = "${ApiConstants.dummyImageUrl}$imageUrl";
        }
      } else {
        profileImageUrl.value = "";
        print("No profile image URL available");
      }
    } catch (e) {
      print("Error updating profile image: $e");
      profileImageUrl.value = "";
    }
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    update();
    try {
       token = await SecureStorageHelper.getString("accessToken");
      final response = await _apiClient.getData(
        ApiConstants.getUserInfo,
        headers: token != '' ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        update();
        profileDetails.value = ProfileDetailsModel.fromJson(response.body);
        updateProfileImage();
        // print("------------------------profile response from server-------------------------");
        // print(response.statusCode);
        // print("------------------------profile image-------------------------");
        // print(profileImageUrl.value);



      }else{
        CustomSnackbar.show(
          title: "Oops!",
          message: "Connection error",
        );
        isLoading.value=false;
        update();

        Get.snackbar("Error", "Unable to get data");
      }


    } catch (e) {
      isLoading.value = false;
      update();
      print("Error getting profile: $e");
    }
  }
}
