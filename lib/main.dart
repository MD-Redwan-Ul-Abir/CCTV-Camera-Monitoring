import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/languageChanging/appConst.dart';
import 'package:skt_sikring/presentation/languageChanging/di.dart' as di;
import 'package:skt_sikring/presentation/languageChanging/localizationController.dart';
import 'package:skt_sikring/presentation/languageChanging/message.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'infrastructure/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, Map<String, String>> languages = await di.init();

  var initialRoute = await Routes.initialRoute;

  final window = WidgetsBinding.instance.window;
  final physicalSize = window.physicalSize;
  final devicePixelRatio = window.devicePixelRatio;

  final logicalWidth = physicalSize.width / devicePixelRatio;
  final logicalHeight = physicalSize.height / devicePixelRatio;

  runApp(
    // Main(initialRoute, Size(logicalWidth, logicalHeight), languages: languages),
    Main(initialRoute, Size(375, 812), languages: languages),
  );
}

class Main extends StatelessWidget {
  final String initialRoute;
  final Size designSize;
  final Map<String, Map<String, String>> languages;

  const Main(
    this.initialRoute,
    this.designSize, {
    super.key,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizeController) {
        return ScreenUtilInit(
          designSize: designSize,
          builder: (context, child) {
            return GetMaterialApp(
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode,
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute,
              getPages: Nav.routes,
              theme: ThemeData(
                scaffoldBackgroundColor: AppColors.secondaryDark,
                appBarTheme: AppBarTheme(
                  backgroundColor: AppColors.secondaryDark,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
