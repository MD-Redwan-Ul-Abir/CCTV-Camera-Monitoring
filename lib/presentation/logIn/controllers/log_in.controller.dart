import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInController extends GetxController  with GetSingleTickerProviderStateMixin {

  late TabController tabController;
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        tabIndex.value = tabController.index;
      }
    });
  }

  void changeTab(int index) {
    tabIndex.value = index;
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }



  final count = 0.obs;




  @override
  void onReady() {
    super.onReady();
  }



  void increment() => count.value++;
}
