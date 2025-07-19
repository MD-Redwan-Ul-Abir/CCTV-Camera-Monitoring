import 'package:get/get.dart';

import '../modules/noInternet/bindings/no_internet_binding.dart';
import '../modules/noInternet/views/no_internet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.NO_INTERNET
  ;

  static final routes = [
    GetPage(
      name: _Paths.NO_INTERNET,
      page: () => const NoInternetView(),
      binding: NoInternetBinding(),
    ),
  ];
}
