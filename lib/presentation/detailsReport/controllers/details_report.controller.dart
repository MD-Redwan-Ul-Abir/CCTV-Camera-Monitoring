import 'dart:convert';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/networkImageFormating.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../model/detailsReportModel.dart';

// CONTROLLER - Updated to handle single object response
class DetailsReportController extends GetxController {
  final ApiClient _apiClient = Get.find();

  Rx<DetailsReportModel?> reportDetails = Rx<DetailsReportModel?>(null);
  String reportID = Get.arguments;
  RxBool isLoading = false.obs;
  RxString profileImageUrl = ''.obs;
  String? token;

  void updateProfileImage() {
    try {
      if (reportDetails.value != null) {
        final imageUrl = reportDetails.value!.data.attributes.creatorId.profileImage.imageUrl;
        if (imageUrl.isNotEmpty) {
          profileImageUrl.value = ProfileImageHelper.formatImageUrl(imageUrl);
          print("Profile image URL: ${profileImageUrl.value}");
        } else {
          profileImageUrl.value = "";
        }
      } else {
        profileImageUrl.value = "";
      }
    } catch (e) {
      print("Error updating profile image: $e");
      profileImageUrl.value = "";
    }
  }

  Future<void> getReportDetails() async {
    isLoading.value = true;
    print("Fetching report with ID: $reportID");

    try {
      token = await SecureStorageHelper.getString("accessToken");

      final response = await _apiClient.getData(
        ApiConstants.getAReportByReportID(reportID: reportID),
        headers: {"Authorization": "Bearer $token"},
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // Check if response.body is already a Map or a String
          final responseJson = response.body is String
              ? jsonDecode(response.body)
              : response.body;

          LoggerHelper.warn("Parsed JSON: $responseJson");

          // Parse the single report object
          final report = DetailsReportModel.fromJson(responseJson);
          reportDetails.value = report;

          print("Report parsed successfully");
          print("Site name: ${report.data.attributes.siteId.name}");
          print("Creator name: ${report.data.attributes.creatorId.name}");
          print("Description: ${report.data.attributes.description}");

          updateProfileImage();

        } catch (e, stackTrace) {
          print("Error parsing JSON response: $e");
          print("Stack trace: $stackTrace");

          if (!Get.isSnackbarOpen) {
            CustomSnackbar.show(
              title: "Error!",
              message: "Failed to parse report data: $e",
            );
          }
        }
      } else if (response.statusCode == 400) {
        if (!Get.isSnackbarOpen) {
          CustomSnackbar.show(
            title: "Error!",
            message: "Report could not be fetched",
          );
        }
        Get.toNamed(Routes.ERROR_PAGE);
      } else {
        print("Unexpected status code: ${response.statusCode}");
        if (!Get.isSnackbarOpen) {
          CustomSnackbar.show(
            title: "Error!",
            message: "Failed to fetch report. Status: ${response.statusCode}",
          );
        }
      }
    } catch (e, stackTrace) {
      print("Error getting report details: $e");
      print("Stack trace: $stackTrace");

      if (!Get.isSnackbarOpen) {
        CustomSnackbar.show(
          title: "Error!",
          message: "Network error: $e",
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}