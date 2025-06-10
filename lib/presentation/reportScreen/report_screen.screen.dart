import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/report_screen.controller.dart';

class ReportScreen extends GetView<ReportScreenController> {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReportScreenScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReportScreenScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
