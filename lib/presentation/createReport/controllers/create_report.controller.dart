import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReportController extends GetxController {
  //TODO: Implement CreateReportController

  //RxString? selectedCustomer;
  var selectedCustomer = Rxn<String>();
  var selectedReportTemplate = Rxn<String>();
  var selectedSeverity = Rxn<String>();
  var selectedSite = Rxn<String>();


  var customerList = <DropdownMenuItem<String>>[].obs;
  var reportTemplateList = <DropdownMenuItem<String>>[].obs;
  var severityList = <DropdownMenuItem<String>>[].obs;
  var siteList = <DropdownMenuItem<String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize dropdown data
    loadReportTemplate();
    loadCustomer();
    loadSite();
    loadSeverity();
  }

  // Methods to update selections

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
      'Ap',
      'Patrol',
      'Service',
      'Emergency call-out',
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
      'Log',
      'Medium',
      'High',
    ];

    severityList.value = categories.map((category) {
      return DropdownMenuItem<String>(
        value: category.toLowerCase().replaceAll(' ', '_'),
        child: Text(category),
      );
    }).toList();
  }

  void loadSite() {
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
      'site': selectedSite.value,
    };
  }
}