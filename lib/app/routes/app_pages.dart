import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../modules/noInternet/bindings/no_internet_binding.dart';
import '../modules/noInternet/views/no_internet_view.dart';


class AppPages {
  AppPages._();

  static const INITIAL = Routes.NO_INTERNET;

  static final routes = [
    GetPage(
      name: Routes.NO_INTERNET,
      page: () => const NoInternetView(),
      binding: NoInternetBinding(),
    ),
  ];
}
