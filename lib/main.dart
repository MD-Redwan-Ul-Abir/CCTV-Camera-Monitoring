import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/core/socket/socket_service.dart';
import 'package:skt_sikring/presentation/languageChanging/appConst.dart';
import 'package:skt_sikring/presentation/languageChanging/di.dart' as di;
import 'package:skt_sikring/presentation/languageChanging/localizationController.dart';
import 'package:skt_sikring/presentation/languageChanging/message.dart';
import 'package:skt_sikring/presentation/messaging/common/socket_controller.dart';
import 'package:skt_sikring/presentation/shared/widgets/networkStatus/globalNetworkService.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'infrastructure/theme/app_colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,

  ]);
  // Initialize the global network service first
  await Get.putAsync<GlobalNetworkService>(() async => GlobalNetworkService());

 SocketController.instance.connectSocket();
  Map<String, Map<String, String>> languages = await di.init();


  var initialRoute = await Routes.initialRoute;
  runApp(
    Phoenix(child: Main(initialRoute, Size(375, 812), languages: languages)),
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