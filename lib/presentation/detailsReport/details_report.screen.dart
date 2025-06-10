import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/details_report.controller.dart';

class DetailsReportScreen extends GetView<DetailsReportController> {
  const DetailsReportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailsReportScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailsReportScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
