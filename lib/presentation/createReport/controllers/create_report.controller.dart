import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../../shared/widgets/imagePicker/imagePickerController.dart';
import '../../home/controllers/home.controller.dart'; // Import HomeController

class CreateReportController extends GetxController {

  // Add controllers for text fields
  final ApiClient _apiClient = Get.find<ApiClient>();
  final imageController = Get.find<imagePickerController>();
  final HomeController homeController = Get.find<HomeController>(); // Add HomeController reference
  final isLoading = false.obs;
  String? token;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var selectedCustomer = Rxn<String>();
  var selectedReportTemplate = Rxn<String>();
  var selectedSeverity = Rxn<String>();
  var selectedSite = Rxn<String>();

  var customerList = <DropdownMenuItem<String>>[].obs;
  var reportTemplateList = <DropdownMenuItem<String>>[].obs;
  var severityList = <DropdownMenuItem<String>>[].obs;
  var siteList = <DropdownMenuItem<String>>[].obs;

  var formData;
  var message;

  @override
  void onInit() {
    super.onInit();
    // Initialize dropdown data
    loadReportTemplate();
    loadCustomer();
    loadSite();
    loadSeverity();
  }

  ///-------------------------sending data to server-----------------------------------
  Future<bool> createReport() async {
    isLoading.value = true;
    try {
      token = await SecureStorageHelper.getString("accessToken");

      print("---------------reset value--------------");
      print(formData);

      // Prepare files for multipart if images exist
      List<MultipartBody>? files;
      if (imageController.selectedImages.isNotEmpty) {
        files = imageController.selectedImages.map((file) =>
            MultipartBody('attachments', file)
        ).toList();
      }

      // Create the form data - now using the selected site ID
      final Map<String, String> createReport = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'reportType': selectedReportTemplate.value ?? '',
        'incidentSevearity': selectedSeverity.value ?? '',
        'siteId': selectedSite.value ?? '', // This will now contain the actual site ID
      };

      // Add video if exists
      if (imageController.selectedVideo.value != null) {
        files ??= [];
        files.add(MultipartBody('video', imageController.selectedVideo.value!));
      }

      print("---------------create report data--------------");
      print(createReport);
      print("Files count: ${files?.length ?? 0}");

      final response = await _apiClient.postData(
        ApiConstants.createReport,
        createReport,
        headers: {"Authorization": "Bearer $token"},
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;

        // Clear form after successful submission
        titleController.clear();
        descriptionController.clear();
        resetAllSelections();
        imageController.selectedImages.clear();
        imageController.clearVideo();

        Get.snackbar(
            "Report Added",
            message ?? response.body["message"],
            backgroundColor: AppColors.primaryNormal,
            colorText: AppColors.primaryLighthover
        );
        return true; // Success
      } else {
        try {
          isLoading.value = false;
          CustomSnackbar.show(
            title: "Failed!",
            message: response.body['message'],
          );
        } catch (e) {
          isLoading.value = false;
          CustomSnackbar.show(
            title: "Error",
            message: "An error occurred during submission",
          );
        }
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      CustomSnackbar.show(
        title: "Error",
        message: "An error occurred: ${e.toString()}",
      );
      return false;
    }
  }

  ///-------------------------data selection and validation--------------------------
  void updateReportTemplate(String? value) {
    selectedReportTemplate.value = value;
  }

  void updateCustomer(String? value) {
    selectedCustomer.value = value;
  }

  void updateSeverity(String? value) {
    selectedSeverity.value = value;
  }

  void updateSite(String? value) {
    selectedSite.value = value;
  }

  // Method to load categories dynamically
  void loadCustomer() {
    List<String> categories = [
      'Customer A',
      'Customer B',
      'Customer C',
    ];

    customerList.value = categories.map((category) {
      return DropdownMenuItem<String>(
        value: category.toLowerCase().replaceAll(' ', '_'),
        child: Text(category),
      );
    }).toList();
  }

  void loadReportTemplate() {
    List<String> categories = [
      'alarmPatrol',
      'patrolReport',
      'Service',
      'emergency_call_out',
    ];

    reportTemplateList.value = categories.map((category) {
      return DropdownMenuItem<String>(
        value: category.toLowerCase().replaceAll(' ', '_'),
        child: Text(category),
      );
    }).toList();
  }

  void loadSeverity() {
    List<String> categories = [
      'low',
      'medium',
      'high',
    ];

    severityList.value = categories.map((category) {
      return DropdownMenuItem<String>(
        value: category.toLowerCase().replaceAll(' ', '_'),
        child: Text(category),
      );
    }).toList();
  }

  // Updated loadSite method to use actual site data from HomeController
  void loadSite() {
    try {
      // Get sites from HomeController
      final sites = homeController.getallSiteBySiteID.value?.data?.attributes?.results;

      if (sites != null && sites.isNotEmpty) {
        siteList.value = sites.where((site) =>
        site.siteId?.name != null &&
            site.siteId?.siteId != null
        ).map((site) {
          return DropdownMenuItem<String>(
            value: site.siteId!.siteId!, // Use the actual site ID as value
            child: Text(site.siteId!.name!), // Display the site name
          );
        }).toList();
      } else {
        // Fallback to hardcoded values if no sites available
        List<String> categories = [
          'Site A',
          'Site B',
          'Site C',
        ];

        siteList.value = categories.map((category) {
          return DropdownMenuItem<String>(
            value: category.toLowerCase().replaceAll(' ', '_'),
            child: Text(category),
          );
        }).toList();
      }
    } catch (e) {
      print("Error loading sites: $e");

      // Fallback to hardcoded values in case of error
      List<String> categories = [
        'Site A',
        'Site B',
        'Site C',
      ];

      siteList.value = categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.toLowerCase().replaceAll(' ', '_'),
          child: Text(category),
        );
      }).toList();
    }
  }

  // Method to refresh site data (call this when site data is updated)
  void refreshSiteData() {
    loadSite();
  }

  // Method to get site name by ID (useful for display purposes)
  String? getSiteNameById(String siteId) {
    try {
      final sites = homeController.getallSiteBySiteID.value?.data?.attributes?.results;
      if (sites != null) {
        final site = sites.firstWhere(
              (site) => site.siteId?.siteId == siteId,
          orElse: () => throw Exception('Site not found'),
        );
        return site.siteId?.name;
      }
    } catch (e) {
      print("Error getting site name: $e");
    }
    return null;
  }

  // Method to reset all selections
  void resetAllSelections() {
    selectedReportTemplate.value = null;
    selectedCustomer.value = null;
    selectedSeverity.value = null;
    selectedSite.value = null;
  }

  // Method to validate selections
  bool validateSelections() {
    return selectedCustomer.value != null &&
        selectedReportTemplate.value != null &&
        selectedSeverity.value != null &&
        selectedSite.value != null;
  }

  // Method to get form data
  Map<String, String?> getFormData() {
    return {
      'customer': selectedCustomer.value,
      'reportTemplate': selectedReportTemplate.value,
      'severity': selectedSeverity.value,
      'site': selectedSite.value, // This will contain the site ID
      'siteName': getSiteNameById(selectedSite.value ?? ''), // Helper to get site name
    };
  }
}