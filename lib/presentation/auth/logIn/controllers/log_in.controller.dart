import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/app_colors.dart';

import '../../../../infrastructure/navigation/routes.dart';
import '../../../../infrastructure/utils/api_client.dart';
import '../../../../infrastructure/utils/api_content.dart';
import '../model/logInModel.dart';

class LogInController extends GetxController with GetSingleTickerProviderStateMixin {


  final ApiClient _apiClient = Get.put(ApiClient());
  Rxn<LogInModel> loginResponse = Rxn<LogInModel>();


  late TabController tabController;
  final tabIndex = 0.obs;
  final role = 'user'.obs; // Initialize with default value

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
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        tabIndex.value = tabController.index;
        role.value = tabIndex.value == 0 ? 'user' : 'customer';
        print(role.value);
      }
    });
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
        message = loginResponse.value!.message;
        Get.snackbar("Log In Successful!", message!,backgroundColor: AppColors.primaryNormal,colorText: AppColors.primaryLighthover);

        await Get.offAllNamed(Routes.MAIN_NAVIGATION_SCREEN);
        return true; // Success
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
    }
  }

  void changeTab(int index) {
    tabIndex.value = index;
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  final count = 0.obs;

  void increment() => count.value++;
}