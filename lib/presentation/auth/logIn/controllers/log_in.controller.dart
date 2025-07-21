import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/app_colors.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import 'package:skt_sikring/presentation/home/controllers/home.controller.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../../../../infrastructure/utils/secure_storage_helper.dart';
import '../../../shared/networkImageFormating.dart';
import '../../../shared/widgets/customSnakBar.dart';
import '../model/logInModel.dart';

class LogInController extends GetxController with GetSingleTickerProviderStateMixin {
  final ApiClient _apiClient = Get.find<ApiClient>();
  Rxn<LogInModel> loginResponse = Rxn<LogInModel>();
  //final HomeController homeController= Get.find<HomeController>();
  // Make tabController nullable initially

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  RxBool isLoading = false.obs;
  final isPasswordVisible = false.obs;

  // Form validation errors
  final emailError = ''.obs;
  final passwordError = ''.obs;
  var message;
  RxString profileImageUrl = "".obs;


  // void dosposeController () {
  //   tabController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }

  // Reset controller state when navigating back
  @override
  void onReady() {
    super.onReady();
    // Clear form fields when screen is ready
    emailController.clear();
    passwordController.clear();
  }
  void updateProfileImage(String initialImageUrl) {
    try {
      final imageUrl = initialImageUrl;
      profileImageUrl.value = ProfileImageHelper.formatImageUrl(imageUrl);
    } catch (e) {
      print("Error updating profile image: $e");
      profileImageUrl.value = "";
    }
  }
  Future<bool> login() async {
    isLoading.value = true;
    update();

    try {
      final Map<String, String> loginData = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      final response = await _apiClient.postData(ApiConstants.logInUrl, loginData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        loginResponse.value = LogInModel.fromJson(response.body);
        message = loginResponse.value?.message;
        isLoading.value = false;

        // print("-----------------------------storing data started-------------------------------------");
        // var storedData = await getStoredUserData();
        // print("------------------------------storing complete and viewed------------------------------------");
        // storedData.forEach((key, value) {
        //   print("$key: $value");
        // });




        // Store all user data in secure storage
       // homeController.token=loginResponse.value!.data!.attributes!.tokens!.accessToken;
        await addDataInSecureStorage();

       Get.snackbar(
            "Log In Successful!",
            message ?? "Welcome back!",
            backgroundColor: AppColors.primaryNormal,
            colorText: AppColors.primaryLighthover
        );
        Get.offAllNamed(Routes.MAIN_NAVIGATION_SCREEN);
        // Future.microtask(() async {
        //   await addDataInSecureStorage();
        //
        //   Get.snackbar(
        //       "Log In Successful!",
        //       message ?? "Welcome back!",
        //       backgroundColor: AppColors.primaryNormal,
        //       colorText: AppColors.primaryLighthover
        //   );
        // });


        return true;
      } else {
        try {
          final errorResponse = LogInModel.fromRawJson(response.body);
          isLoading.value = false;
          update();
          Get.snackbar("Log In Failed!", errorResponse.message ?? "Unknown error");
        } catch (e) {
          isLoading.value = false;
          update();
          CustomSnackbar.show(
            title: "Log In Failed!",
            message:response.body["message"],
          );

        }
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      update();
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDataInSecureStorage() async {
    if (loginResponse.value?.data?.attributes?.userWithoutPassword == null) {
      print("No user data available to store");
      return;
    }

    final user = loginResponse.value!.data!.attributes!.userWithoutPassword!;
    final tokens = loginResponse.value!.data!.attributes!.tokens;

    try {
      // Store user basic info
      if (user.id != null && user.id!.isNotEmpty) {
        await SecureStorageHelper.setString("id", user.id!);
      }

      if (user.userCustomId != null && user.userCustomId!.isNotEmpty) {
        await SecureStorageHelper.setString("userCustomId", user.userCustomId!);
      }

      if (user.email != null && user.email!.isNotEmpty) {
        await SecureStorageHelper.setString("email", user.email!);
      }

      if (user.name != null && user.name!.isNotEmpty) {
        await SecureStorageHelper.setString("name", user.name!);
      }

      // Store user preferences and settings
      await SecureStorageHelper.setBool("canMessage", user.canMessage ?? false);

      if (user.role != null && user.role!.isNotEmpty) {
        await SecureStorageHelper.setString("role", user.role!);
      }

      if (user.address != null && user.address!.isNotEmpty) {
        await SecureStorageHelper.setString("address", user.address!);
      }

      if (user.fcmToken != null && user.fcmToken.toString().isNotEmpty) {
        await SecureStorageHelper.setString("fcmToken", user.fcmToken.toString());
      }

      // Store profile image URL
      if (user.profileImage?.imageUrl != null && user.profileImage!.imageUrl!.isNotEmpty) {
        updateProfileImage(user.profileImage!.imageUrl!);
        await SecureStorageHelper.setString("profileImageUrl", profileImageUrl.value);

         // LoggerHelper.error(profileImageUrl.value);
      }

      if (user.profileImage?.id != null && user.profileImage!.id!.isNotEmpty) {
        await SecureStorageHelper.setString("profileImageId", user.profileImage!.id!);
      }

      // Store user status and subscription info
      if (user.status != null && user.status!.isNotEmpty) {
        await SecureStorageHelper.setString("status", user.status!);
      }


      // Store tokens
      if (tokens?.accessToken != null && tokens!.accessToken!.isNotEmpty) {
        await SecureStorageHelper.setString("accessToken", tokens.accessToken!);
      }

      if (tokens?.refreshToken != null && tokens!.refreshToken!.isNotEmpty) {
        await SecureStorageHelper.setString("refreshToken", tokens.refreshToken!);
      }

      print("All user data stored successfully in secure storage");

    } catch (e) {
      print("Error storing data in secure storage: $e");
      Get.snackbar("Storage Error", "Failed to store user data securely");
    }
  }

  Future<Map<String, dynamic>> getStoredUserData() async {
    try {
      return {
        'id': await SecureStorageHelper.getString("id"),
        'userCustomId': await SecureStorageHelper.getString("userCustomId"),
        'email': await SecureStorageHelper.getString("email"),
        'name': await SecureStorageHelper.getString("name"),
        'canMessage': await SecureStorageHelper.getBool("canMessage"),
        'role': await SecureStorageHelper.getString("role"),
        'address': await SecureStorageHelper.getString("address"),
        'fcmToken': await SecureStorageHelper.getString("fcmToken"),
        'profileImageUrl': await SecureStorageHelper.getString("profileImageUrl"),
        'profileImageId': await SecureStorageHelper.getString("profileImageId"),
        'status': await SecureStorageHelper.getString("status"),
        'subscriptionType': await SecureStorageHelper.getString("subscriptionType"),
        'isEmailVerified': await SecureStorageHelper.getBool("isEmailVerified"),
        'isDeleted': await SecureStorageHelper.getBool("isDeleted"),
        'isResetPassword': await SecureStorageHelper.getBool("isResetPassword"),
        'isGoogleVerified': await SecureStorageHelper.getBool("isGoogleVerified"),
        'isAppleVerified': await SecureStorageHelper.getBool("isAppleVerified"),
        'authProvider': await SecureStorageHelper.getString("authProvider"),
        'failedLoginAttempts': await SecureStorageHelper.getInt("failedLoginAttempts"),
        'stripeCustomerId': await SecureStorageHelper.getString("stripeCustomerId"),
        'conversationRestrictWith': await SecureStorageHelper.getString("conversationRestrictWith"),
        'createdAt': await SecureStorageHelper.getString("createdAt"),
        'updatedAt': await SecureStorageHelper.getString("updatedAt"),
        'accessToken': await SecureStorageHelper.getString("accessToken"),
        'refreshToken': await SecureStorageHelper.getString("refreshToken"),
      };
    } catch (e) {
      print("Error retrieving stored user data: $e");
      return {};
    }
  }

  Future<void> clearStoredUserData() async {
    try {
      final keysToDelete = [
        "id", "userCustomId", "email", "name", "canMessage", "role", "address",
        "fcmToken", "profileImageUrl", "profileImageId", "status", "subscriptionType",
        "isEmailVerified", "isDeleted", "isResetPassword", "isGoogleVerified",
        "isAppleVerified", "authProvider", "failedLoginAttempts", "stripeCustomerId",
        "conversationRestrictWith", "createdAt", "updatedAt", "accessToken", "refreshToken"
      ];

      for (String key in keysToDelete) {
        await SecureStorageHelper.remove(key);
      }

      print("All stored user data cleared successfully");
    } catch (e) {
      print("Error clearing stored user data: $e");
    }
  }
}