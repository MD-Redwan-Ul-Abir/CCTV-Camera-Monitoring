import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../model/getAllSiteBySiteIDModel.dart';
import '../model/getRepostByDateModel.dart';
import '../model/profileDetails.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find();
  Rxn<ProfileDetailsModel> profileDetails = Rxn<ProfileDetailsModel>();
  Rxn<GetAllSitesBySiteIdModel> getallSiteBySiteID = Rxn<GetAllSitesBySiteIdModel>();
  Rxn<GetReportByIdModel> getAllReportByDate = Rxn<GetReportByIdModel>();


  RxString profileImageUrl = "".obs;
  RxBool isLoading = false.obs;
  String? token;
  String? localPersonID;

  RxString role = ''.obs;

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
    try {
      token = await SecureStorageHelper.getString("accessToken");
      String? roleString = await SecureStorageHelper.getString("role");
      localPersonID = await SecureStorageHelper.getString("id");
      role.value = roleString;


      final response = await _apiClient.getData(ApiConstants.getUserInfo,
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        profileDetails.value = ProfileDetailsModel.fromJson(response.body);
        updateProfileImage();
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

  Future<void> getAllYourSites() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.getData(ApiConstants.getAllSiteByPersonID(personID: localPersonID,role: role.value,limit: 300),
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        getallSiteBySiteID.value = GetAllSitesBySiteIdModel.fromJson(response.body);
      }
    /// -----------------more task to be needed----------------------
    else if(response.statusCode == 400){
        CustomSnackbar.show(
          title: "Oops!",
          message: "Session Expired",
        );
        Get.toNamed(Routes.ERROR_PAGE);
      }
    } catch (e) {
      print("Error getting profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllTodaysReportByDate() async {
    isLoading.value = true;
    try {
      //createdAt:'2025-07-12',personID: localPersonID,role: role.value,limit: 300
      final response = await _apiClient.getData(ApiConstants.getAllTodaysReport(createdAt:'2025-07-12',personID: localPersonID,role: role.value,limit: 300),
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        getAllReportByDate.value = GetReportByIdModel.fromJson(response.body);

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