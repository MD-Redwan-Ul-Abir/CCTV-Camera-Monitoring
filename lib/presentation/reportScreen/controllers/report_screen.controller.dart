import 'package:get/get.dart';

class ReportScreenController extends GetxController {
  // Filter related variables
  var selectedCategory = 'Ap'.obs;

  // Pagination related variables
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default category
    selectedCategory.value = 'Ap';
    currentPage.value = 1;
    totalPages.value = 1;
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    currentPage.value = 1; // Reset to first page when filter changes
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
    }
  }

  void goToNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}