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
  var selectedCustomer = Rxn<String>();

  var reportTemplateList = <DropdownMenuItem<String>>[].obs;
  var severityList = <DropdownMenuItem<String>>[].obs;
  var siteList = <DropdownMenuItem<String>>[].obs;
  var customerList = <DropdownMenuItem<String>>[].obs;
  var role = "".obs;

  RxList<Customer> overviewDataList = <Customer>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    role.value = await SecureStorageHelper.getString(AppContents.role);
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

      LoggerHelper.info('Fetching customers for site: ${selectedSite.value}');

      // Make API call to get customers by site ID
      final response = await _apiClient.getData(
        ApiConstants.getCustomersAndAdminWithSiteID(siteID: selectedSite.value),
        headers: {"Authorization": "Bearer $token"},
      );

      LoggerHelper.info('Customer API Response Status: ${response.statusCode}');
      LoggerHelper.info('Customer API Response Body: ${response.body}');

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {

        // Parse the response with defensive error handling
        try {
          // response.body is already a Map, not a String
          final responseData = response.body is String
              ? jsonDecode(response.body)
              : response.body;

          LoggerHelper.info('Response data type: ${responseData.runtimeType}');

          if (responseData is Map<String, dynamic>) {

            // Check if response has the expected structure
            if (responseData['data'] != null &&
                responseData['data']['attributes'] != null &&
                responseData['data']['attributes']['customers'] != null) {

              final customersJson = responseData['data']['attributes']['customers'] as List;

              LoggerHelper.info('Found ${customersJson.length} customers in response');

              // Clear existing data
              overviewDataList.clear();
              customerList.clear();

              if (customersJson.isNotEmpty) {
                // Parse each customer manually to avoid model parsing issues
                for (var customerJson in customersJson) {
                  try {
                    LoggerHelper.info('Processing customer: $customerJson');

                    // Extract personId data safely
                    var personIdData = customerJson['personId'];

                    LoggerHelper.info('PersonId data: $personIdData');

                    if (personIdData != null && personIdData is Map<String, dynamic>) {
                      String customerId = personIdData['_userId'] ?? '';
                      String customerName = personIdData['name'] ?? 'Unknown';

                      LoggerHelper.info('Extracted - ID: $customerId, Name: $customerName');

                      // Only add if we have valid data
                      if (customerId.isNotEmpty && customerName.isNotEmpty) {
                        customerList.add(
                          DropdownMenuItem<String>(
                            value: customerId,
                            child: Text(customerName),
                          ),
                        );

                        LoggerHelper.info('Added customer to dropdown: $customerName (ID: $customerId)');
                      } else {
                        LoggerHelper.warn('Skipping customer due to empty ID or name');
                      }
                    } else {
                      LoggerHelper.warn('PersonId is null or not a Map');
                    }
                  } catch (customerError) {
                    LoggerHelper.warn('Error parsing individual customer: ${customerError.toString()}');
                    // Continue to next customer
                    continue;
                  }
                }

                LoggerHelper.info('Successfully loaded ${customerList.length} customers into dropdown');

                // Force UI update
                customerList.refresh();

                // Try to parse the full model for overviewDataList (optional)
                try {
                  CustomberBySiteIdModel responseModel = CustomberBySiteIdModel.fromJson(responseData);
                  if (responseModel.data.attributes.hasCustomers &&
                      responseModel.data.attributes.customers.isNotEmpty) {
                    overviewDataList.addAll(responseModel.data.attributes.customers);
                    LoggerHelper.info('Also populated overviewDataList with ${overviewDataList.length} customers');
                  }
                } catch (modelError) {
                  LoggerHelper.warn('Model parsing failed but dropdown populated: ${modelError.toString()}');
                  // This is okay - we already have the dropdown populated
                }

              } else {
                LoggerHelper.warn('No customers found for this site');
              }
            } else {
              LoggerHelper.warn('Response missing expected data structure');
            }
          } else {
            LoggerHelper.warn('Invalid response format - not a Map');
          }
        } catch (parseError) {
          LoggerHelper.debug('Error parsing customer list response: ${parseError.toString()}');
          customerList.clear();
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

      // For "user" role, add customerId to the report data
      if (role.value == AppContents.userRole && selectedCustomer.value != null) {
        createReportData['customerId'] = selectedCustomer.value ?? '';
      }

      LoggerHelper.warn(createReportData);

      // Add video if exists
      if (imageController.selectedVideo.value != null) {
        files ??= [];
        files.add(MultipartBody('video', imageController.selectedVideo.value!));
      }

      //  determine which API endpoint to use

      String apiEndpoint = role.value == AppContents.userRole
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

  /// Updates the selected customer
  void updateCustomer(String? value) {
    selectedCustomer.value = value;
    LoggerHelper.info('Selected customer ID: $value');
  }

  /// Updates the selected site
  void updateSite(String? value) {
    selectedSite.value = value;
    // Reset selected customer when site changes
    selectedCustomer.value = null;
    customerList.clear(); // Clear customer list immediately
    // Load customer list when site is selected for "user" role
    if (role.value == AppContents.userRole && value != null) {
      getCustomerList();
    }
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
    selectedCustomer.value = null;
  }
}