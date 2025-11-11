import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:skt_sikring/infrastructure/utils/app_contents.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';

import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/customSnakBar.dart';
import '../../shared/widgets/imagePicker/imagePickerController.dart';
import '../../home/controllers/home.controller.dart';
import '../model/customersBySiteIDModel.dart';

class CreateReportController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final imagePickerController imageController = Get.find<imagePickerController>();
  final HomeController homeController = Get.find<HomeController>();

  final isLoading = false.obs;
  String? token;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  var selectedReportTemplate = Rxn<String>();
  var selectedSeverity = Rxn<String>();
  var selectedSite = Rxn<String>();

  var reportTemplateList = <DropdownMenuItem<String>>[].obs;
  var severityList = <DropdownMenuItem<String>>[].obs;
  var siteList = <DropdownMenuItem<String>>[].obs;
  String role ="";

  RxList<Customer> overviewDataList = <Customer>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
     role = await SecureStorageHelper.getString(AppContents.role);
    loadReportTemplate();
    loadSite();
    loadSeverity();
  }

  //
  /// Fetches the list of customers and admins for the selected site
  Future<void> getCustomerList() async {
    try {
      // Get auth token
      token = await SecureStorageHelper.getString(AppContents.token);

      // Validate that a site is selected
      if (selectedSite.value == null || selectedSite.value!.isEmpty) {
        LoggerHelper.warn('No site selected');
        return;
      }

      // Make API call to get customers by site ID
      final response = await _apiClient.getData(
        ApiConstants.getCustomersAndAdminWithSiteID(siteID: selectedSite.value),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {

        // Parse the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        CustomberBySiteIdModel responseModel = CustomberBySiteIdModel.fromJson(responseData);

        // Clear existing data and populate with new customers
        overviewDataList.clear();

        if (responseModel.data.attributes.hasCustomers &&
            responseModel.data.attributes.customers.isNotEmpty) {
          overviewDataList.addAll(responseModel.data.attributes.customers);
          LoggerHelper.warn('Loaded ${overviewDataList.first.personId.userId} customers for site');
        } else {
          LoggerHelper.warn('No customers found for this site');
        }

      } else {
        LoggerHelper.debug('Failed to fetch customers: ${response.statusCode}');
        CustomSnackbar.show(
          title: "Error",
          message: "Failed to load customers for this site",
        );
      }

    } catch (e) {
      LoggerHelper.debug('Error fetching customer list: ${e.toString()}');
      CustomSnackbar.show(
        title: "Error",
        message: "An error occurred while loading customers",
      );
    }
  }

  /// MARK: - Report Creation Function
  /// Handles the submission of a new report to the server
  Future<bool> createReport() async {
    isLoading.value = true;
    try {
      token = await SecureStorageHelper.getString(AppContents.token);

      // Prepare files for multipart if images exist
      List<MultipartBody>? files;
      if (imageController.selectedImages.isNotEmpty) {
        files = imageController.selectedImages.map((file) =>
            MultipartBody('attachments', file)
        ).toList();
      }

      // Prepare report data for submission
      final Map<String, String> createReportData = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'reportType': selectedReportTemplate.value ?? '',
        'incidentSevearity': selectedSeverity.value ?? '',
        'siteId': selectedSite.value ?? '',
      };

      LoggerHelper.warn(createReportData);

      // Add video if exists
      if (imageController.selectedVideo.value != null) {
        files ??= [];
        files.add(MultipartBody('video', imageController.selectedVideo.value!));
      }

      //  determine which API endpoint to use

      String apiEndpoint = role == AppContents.userRole 
          ? ApiConstants.createReportAsUser 
          : ApiConstants.createReportAsCustomer;

      final response = await _apiClient.postData(
        apiEndpoint,
        createReportData,
        headers: {"Authorization": "Bearer $token"},
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;

        // Refresh home screen data after successful submission
        homeController.fetchedData.value = false;
        
        // Clear form after successful submission
        titleController.clear();
        descriptionController.clear();
        resetAllSelections();
        imageController.selectedImages.clear();
        imageController.clearVideo();

        // Refresh home screen data again to show the new report
        homeController.fetchedData.value = false;

        // Show success message
        String successMessage = response.body["message"] ?? "Report created successfully";
        Get.snackbar(
            "Report Added",
            successMessage,
            backgroundColor: AppColors.primaryNormal,
            colorText: AppColors.primaryLighthover
        );
        return true; // Success
      } else {
        isLoading.value = false;
        try {
          String errorMessage = response.body['message'] ?? "Submission failed";
          CustomSnackbar.show(
            title: "Failed!",
            message: errorMessage,
          );
        } catch (e) {
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

  /// MARK: - Data Selection Methods
  /// Updates the selected report template
  void updateReportTemplate(String? value) {
    selectedReportTemplate.value = value;
  }

  /// Updates the selected severity level
  void updateSeverity(String? value) {
    selectedSeverity.value = value;
  }

  /// Updates the selected site
  void updateSite(String? value) {
    selectedSite.value = value;
  }

  /// MARK: - Dropdown Data Loading Methods
  
  /// Loads report template options into the dropdown
  void loadReportTemplate() {
    List<String> reportTemplates = [
      'alarmPatrol',
      'patrolReport',
      'service',
      'emergency_call_out',
    ];

    reportTemplateList.value = reportTemplates.map((template) {
      return DropdownMenuItem<String>(
        value: template.replaceAll(' ', '_'),
        child: Text(template),
      );
    }).toList();
  }

  /// Loads severity level options into the dropdown
  void loadSeverity() {
    List<String> severities = [
      'low',
      'medium',
      'high',
    ];

    severityList.value = severities.map((severity) {
      return DropdownMenuItem<String>(
        value: severity.toLowerCase().replaceAll(' ', '_'),
        child: Text(severity),
      );
    }).toList();
  }

  /// MARK: - Site Data Management
  /// Loads site options into the dropdown from HomeController
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
        // Fallback to empty list if no sites available
        siteList.value = [];
      }
    } catch (e) {
      print("Error loading sites: $e");

      // Fallback to empty list in case of error
      siteList.value = [];
    }
  }

  /// Refreshes site data (call this when site data is updated)
  void refreshSiteData() {
    loadSite();
  }

  /// Gets site name by ID (useful for display purposes)
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

  /// Resets all dropdown selections to initial state
  void resetAllSelections() {
    selectedReportTemplate.value = null;
    selectedSeverity.value = null;
    selectedSite.value = null;
  }
}