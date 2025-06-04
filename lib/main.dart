import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'infrastructure/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initialRoute = await Routes.initialRoute;

  final window = WidgetsBinding.instance.window;
  final physicalSize = window.physicalSize;
  final devicePixelRatio = window.devicePixelRatio;

  final logicalWidth = physicalSize.width / devicePixelRatio;
  final logicalHeight = physicalSize.height / devicePixelRatio;

  runApp(Main(initialRoute, Size(logicalWidth, logicalHeight)));
}

class Main extends StatelessWidget {
  final String initialRoute;
  final Size designSize;
  Main(this.initialRoute, this.designSize);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          getPages: Nav.routes,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.secondaryDark ,
            appBarTheme: AppBarTheme(backgroundColor: AppColors.secondaryDark),
          ),
        );
      },
    );
  }
}
