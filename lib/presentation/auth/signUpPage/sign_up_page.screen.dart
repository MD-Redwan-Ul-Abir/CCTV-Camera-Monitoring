import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/sign_up_page.controller.dart';

class SignUpPageScreen extends GetView<SignUpPageController> {
  const SignUpPageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUpPageScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SignUpPageScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
