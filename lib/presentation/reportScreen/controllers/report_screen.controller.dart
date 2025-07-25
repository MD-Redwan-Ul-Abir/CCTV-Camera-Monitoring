import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../infrastructure/utils/api_client.dart';
import '../../../infrastructure/utils/api_content.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../model/reportModel.dart';

class ReportScreenController extends GetxController {
  static const Map<String, String> categoryMapping = {
    'Alarm Patrol': 'alarmPatrol',
    'Patrol Report': 'patrolReport',
    'Service': 'service',
    'Emergency Call Out': 'emergency_call_out',
  };

  // Reverse mapping for getting UI names from backend values
  static const Map<String, String> reverseCategoryMapping = {
    'alarmPatrol': 'Alarm Patrol',
    'patrolReport': 'Patrol Report',
    'service': 'Service',
    'emergency_call_out': 'Emergency Call Out',
  };

  var selectedCategory = 'Alarm Patrol'.obs;

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final ApiClient _apiClient = Get.find();
  RxList<Result> allSelectedReport = <Result>[].obs;
  Rxn<ReportModel> allReports = Rxn<ReportModel>();

  String get reportID {
    final args = Get.arguments;
    if (args == null) return '';
    if (args is String) return args;
    if (args is Map && args.containsKey('reportId')) {
      return args['reportId']?.toString() ?? '';
    }
    return args.toString();
  }

  RxBool isLoading = false.obs;
  RxString profileImageUrl = ''.obs;
  String? token;

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = 'Alarm Patrol';
    currentPage.value = 1;
    totalPages.value = 1;
    // Load initial data
    getCategoricalReport();
  }

  // Get backend value from UI display name
  String getBackendCategoryValue(String uiCategory) {
    return categoryMapping[uiCategory] ?? 'alarmPatrol';
  }

  // Get UI display name from backend value
  String getUICategoryName(String backendValue) {
    return reverseCategoryMapping[backendValue] ?? 'Alarm Patrol';
  }

  // Get all available categories for UI
  List<String> get availableCategories => categoryMapping.keys.toList();

  Future<void> getCategoricalReport() async {
    isLoading.value = true;
    print("---------------------------report--------------------------");
    print("Selected UI Category: ${selectedCategory.value}");

    // Convert UI category to backend value
    String backendCategory = getBackendCategoryValue(selectedCategory.value);
    print("Backend Category Value: $backendCategory");

    try {
      token = await SecureStorageHelper.getString("accessToken");
      String id = await SecureStorageHelper.getString("id");

      final response = await _apiClient.getData(
        ApiConstants.getReportsBySelection(
            reportType: backendCategory,
            personID: id,
            page: currentPage.value,
            limit: 5),
        headers: token != null && token!.isNotEmpty
            ? {"Authorization": "Bearer $token"}
            : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        allReports.value = ReportModel.fromJson(response.body);
        final reportModel = allReports.value;
        if (reportModel != null &&
            reportModel.data != null &&
            reportModel.data!.attributes != null) {
          allSelectedReport.value = reportModel.data!.attributes!.results!;
          updateTotalPages(reportModel.data!.attributes!.totalPages!);
        }
      }
    } catch (e) {
      print("Error getting reports: $e");
      allSelectedReport.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    currentPage.value = 1; // Reset to first page when filter changes
    // Automatically fetch new data when category changes
    getCategoricalReport();
  }

  // Filter reports by current selected category
  List<Result> get filteredReports {
    String backendCategory = getBackendCategoryValue(selectedCategory.value);
    return allSelectedReport
        .where((report) => report.reportType == backendCategory)
        .toList();
  }

  // Get reports by specific backend category
  List<Result> getReportsByBackendType(String backendReportType) {
    return allSelectedReport
        .where((report) => report.reportType == backendReportType)
        .toList();
  }

  // Get reports by UI category name
  List<Result> getReportsByUICategory(String uiCategory) {
    String backendCategory = getBackendCategoryValue(uiCategory);
    return getReportsByBackendType(backendCategory);
  }

  void updateTotalPages(int pages) {
    totalPages.value = pages;
    // If current page is greater than total pages, reset to last page
    if (currentPage.value > totalPages.value && totalPages.value > 0) {
      currentPage.value = totalPages.value;
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      getCategoricalReport();
    }
  }

  void goToNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      getCategoricalReport();
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getCategoricalReport();
    }
  }

  // Additional helper methods
  void clearReports() {
    allSelectedReport.clear();
  }

  void addReport(Result report) {
    allSelectedReport.add(report);
  }

  void removeReport(int index) {
    if (index >= 0 && index < allSelectedReport.length) {
      allSelectedReport.removeAt(index);
    }
  }

  void updateReport(int index, Result updatedReport) {
    if (index >= 0 && index < allSelectedReport.length) {
      allSelectedReport[index] = updatedReport;
    }
  }
}