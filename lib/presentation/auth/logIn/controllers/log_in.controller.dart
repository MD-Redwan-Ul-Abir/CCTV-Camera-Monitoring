import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/app_colors.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../../../../infrastructure/utils/secure_storage_helper.dart';
import '../model/logInModel.dart';

class LogInController extends GetxController with GetSingleTickerProviderStateMixin {
  final ApiClient _apiClient = Get.put(ApiClient());
  Rxn<LogInModel> loginResponse = Rxn<LogInModel>();

  // Make tabController nullable initially
  TabController? tabController;
  final tabIndex = 0.obs;
  final role = 'user'.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  // Form validation errors
  final emailError = ''.obs;
  final passwordError = ''.obs;
  var message;

  @override
  void onInit() {
    super.onInit();

    // Initialize TabController and add null check
    try {
      tabController = TabController(length: 2, vsync: this);
      tabController?.addListener(() {
        if (tabController != null && !tabController!.indexIsChanging) {
          tabIndex.value = tabController!.index;
          role.value = tabIndex.value == 0 ? 'user' : 'customer';
          print(role.value);
        }
      });
    } catch (e) {
      print('Error initializing TabController: $e');
    }
  }

  void changeTab(int index) {
    tabIndex.value = index;
    tabController?.animateTo(index);
  }

  @override
  void onClose() {
    tabController?.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Reset controller state when navigating back
  @override
  void onReady() {
    super.onReady();
    // Clear form fields when screen is ready
    emailController.clear();
    passwordController.clear();
    isLoading.value = false;
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
        // print("-----------------------------storing data started-------------------------------------");
        // var storedData = await getStoredUserData();
        // print("------------------------------storing complete and viewed------------------------------------");
        // storedData.forEach((key, value) {
        //   print("$key: $value");
        // });

        Get.snackbar(
            "Log In Successful!",
            message ?? "Welcome back!",
            backgroundColor: AppColors.primaryNormal,
            colorText: AppColors.primaryLighthover
        );

        // Store all user data in secure storage
        await addDataInSecureStorage();
        await Get.offAllNamed(Routes.MAIN_NAVIGATION_SCREEN);


        return true;
      } else {
        try {
          final errorResponse = LogInModel.fromRawJson(response.body);
          Get.snackbar("Log In Failed!", errorResponse.message ?? "Unknown error");
        } catch (e) {
          Get.snackbar("Log In Failed!", "Failed with status code: ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
      return false;
    } finally {
      isLoading.value = false;
      update();
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
        await SecureStorageHelper.setString("profileImageUrl", user.profileImage!.imageUrl!);
      }

      if (user.profileImage?.id != null && user.profileImage!.id!.isNotEmpty) {
        await SecureStorageHelper.setString("profileImageId", user.profileImage!.id!);
      }

      // Store user status and subscription info
      if (user.status != null && user.status!.isNotEmpty) {
        await SecureStorageHelper.setString("status", user.status!);
      }

      if (user.subscriptionType != null && user.subscriptionType!.isNotEmpty) {
        await SecureStorageHelper.setString("subscriptionType", user.subscriptionType!);
      }

      // Store boolean flags
      await SecureStorageHelper.setBool("isEmailVerified", user.isEmailVerified ?? false);
      await SecureStorageHelper.setBool("isDeleted", user.isDeleted ?? false);
      await SecureStorageHelper.setBool("isResetPassword", user.isResetPassword ?? false);
      await SecureStorageHelper.setBool("isGoogleVerified", user.isGoogleVerified ?? false);
      await SecureStorageHelper.setBool("isAppleVerified", user.isAppleVerified ?? false);

      // Store auth provider
      if (user.authProvider != null && user.authProvider!.isNotEmpty) {
        await SecureStorageHelper.setString("authProvider", user.authProvider!);
      }

      // Store failed login attempts
      if (user.failedLoginAttempts != null) {
        await SecureStorageHelper.setInt("failedLoginAttempts", user.failedLoginAttempts!);
      }

      // Store Stripe customer ID if available
      if (user.stripeCustomerId != null && user.stripeCustomerId.toString().isNotEmpty) {
        await SecureStorageHelper.setString("stripeCustomerId", user.stripeCustomerId.toString());
      }

      // Store conversation restrictions (as JSON string)
      if (user.conversationRestrictWith != null && user.conversationRestrictWith!.isNotEmpty) {
        await SecureStorageHelper.setString("conversationRestrictWith", user.conversationRestrictWith.toString());
      }

      // Store timestamps
      if (user.createdAt != null) {
        await SecureStorageHelper.setString("createdAt", user.createdAt!.toIso8601String());
      }

      if (user.updatedAt != null) {
        await SecureStorageHelper.setString("updatedAt", user.updatedAt!.toIso8601String());
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