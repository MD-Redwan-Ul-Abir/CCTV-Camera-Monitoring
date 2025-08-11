import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../../../../infrastructure/utils/secure_storage_helper.dart';
import '../../../shared/widgets/customSnakBar.dart';
import '../model/allUserModel.dart';

class AddConversationsController extends GetxController {
  final ApiClient _apiClient = Get.find();
  RxBool isLoading = false.obs;
  String? token;

  RxList<Attribute> userAttributes = <Attribute>[].obs;

  Future<void> getAllTakeablePeople() async {
    isLoading.value = true;
    try {
      token = await SecureStorageHelper.getString("accessToken");
      String? roles = await SecureStorageHelper.getString("role");
     String? localPersonID = await SecureStorageHelper.getString("id");

      final response = await _apiClient.getData(ApiConstants.getAddConversations(personID: localPersonID,role: roles),
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {

        AllConversationsBetweenTwoUserModel responseModel = AllConversationsBetweenTwoUserModel.fromJson(response.body);
        if (responseModel.data != null && responseModel.data!.attributes != null) {
          userAttributes.value = responseModel.data!.attributes!;
        }
        LoggerHelper.warn("Successfully loaded ${userAttributes.length} users\n ${userAttributes.value}");
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
