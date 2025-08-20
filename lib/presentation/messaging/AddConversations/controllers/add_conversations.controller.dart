import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../../../../infrastructure/utils/secure_storage_helper.dart';
import '../../../shared/widgets/customSnakBar.dart';
import '../model/allUserModel.dart';

class AddConversationsController extends GetxController {
  final sendMessageController = TextEditingController();
  final ApiClient _apiClient = Get.find();
  RxBool isLoading = false.obs;
  String? token;
  RxString? localPersonID;
  RxString siteID="".obs;

  RxList<Attribute> userAttributes = <Attribute>[].obs;

  Future<void> getAllTakeablePeople() async {
    isLoading.value = true;
    try {
      token = await SecureStorageHelper.getString("accessToken");
      String? roles = await SecureStorageHelper.getString("role");
     localPersonID?.value = await SecureStorageHelper.getString("id");

      final response = await _apiClient.getData(ApiConstants.getAddConversations(personID: localPersonID?.value,role: roles),
        headers: token != null && token!.isNotEmpty  ? {"Authorization": "Bearer $token"} : null,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {

        AllConversationsBetweenTwoUserModel responseModel = AllConversationsBetweenTwoUserModel.fromJson(response.body);
        if (responseModel.data != null && responseModel.data!.attributes != null) {
          userAttributes.value = responseModel.data!.attributes!;
        }
        LoggerHelper.warn("Successfully loaded ${userAttributes.length} users\n ${userAttributes.map((attr) => attr.toJson()).toList()}");
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


  Future<bool> startChat({required List<String> participants, required String siteId}) async {
    isLoading.value = true;
    update();

    try {
      final Map<String, dynamic> startConversation = {
        "siteId": siteId,
        "participants": participants,  // This is now a List<String>
        "message": sendMessageController.text.trim()  // Optional string
      };


      final response = await _apiClient.postData(ApiConstants.startConversation, startConversation);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // loginResponse.value = LogInModel.fromJson(response.body);
        // message = loginResponse.value?.message;
        isLoading.value = false;
        CustomSnackbar.show(
          title: "You can message",
          message: response.body["message"],
        );



        return true;
      } else {
        try {
           // final errorResponse = LogInModel.fromRawJson(response.body);
           // isLoading.value = false;
           // update();
           // Get.snackbar("Log In Failed!", errorResponse.message ?? "Unknown error");
           LoggerHelper.error(response.body.toString());
        } catch (e) {
          isLoading.value = false;
          update();


          // CustomSnackbar.show(
          //   title: "Log In Failed!",
          //   message:response.body["message"],
          // );

        }
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      update();
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
      LoggerHelper.error(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

}
