import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/themes/app_theme.dart';
import 'package:task_manager_getx/themes/theme_changer.dart';

import 'package:task_manager_getx/utils/app_navigator.dart';
import 'package:task_manager_getx/utils/initiate_view_model.dart';

import '../utils/app_strings_and_api.dart';

class TaskManager extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final String userTheme;

  const TaskManager({super.key, required this.userTheme});

  @override
  Widget build(BuildContext context) {
    loadUserTheme(userTheme, context);
    return GetBuilder<ThemeChanger>(builder: (viewModel) {
      return GetMaterialApp(
        navigatorKey: navigatorKey,
        initialBinding: InitiateViewModel(),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashScreen,
        onGenerateRoute: (routeSettings) {
          return AppRoutes.generateRoute(routeSettings);
        },
        themeMode: viewModel.themeMode,
        theme: AppTheme.getLightTheme(),
        darkTheme: AppTheme.getDarkTheme(),
      );
    });
  }

  void loadUserTheme(String theme, BuildContext context) {
    switch (theme) {
      case AppStrings.darkMode:
        Get.find<ThemeChanger>().setThemeModeSilent = ThemeMode.dark;

      case AppStrings.lightMode:
        Get.find<ThemeChanger>().setThemeModeSilent = ThemeMode.light;

      case AppStrings.systemMode:
        Get.find<ThemeChanger>().setThemeModeSilent = ThemeMode.system;
    }
  }
}
