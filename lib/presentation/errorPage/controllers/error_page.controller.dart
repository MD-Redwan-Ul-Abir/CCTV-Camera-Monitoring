import 'package:get/get.dart';
import 'package:gif/gif.dart';

class ErrorPageController extends GetxController with GetTickerProviderStateMixin {
  late GifController gifController;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize GifController after onInit to ensure TickerProvider is available
    gifController = GifController(vsync: this);

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose the GifController to prevent memory leaks
    gifController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}