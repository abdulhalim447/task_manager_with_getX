import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_getx/services/connectivity_checker.dart';
import 'package:task_manager_getx/themes/theme_changer.dart';
import 'package:task_manager_getx/utils/app_paths.dart';
import 'package:task_manager_getx/utils/all_color.dart';
import 'package:task_manager_getx/utils/app_strings_and_api.dart';
import 'package:task_manager_getx/viewModels/dashboard_view_model.dart';
import 'package:task_manager_getx/viewModels/task_view_model.dart';
import 'package:task_manager_getx/views/taskCancelledScreen/task_cancelled_screen.dart';
import 'package:task_manager_getx/views/taskCompletedScreen/task_completed_screen.dart';
import 'package:task_manager_getx/views/taskProgressScreen/task_progress_screen.dart';
import 'package:task_manager_getx/views/widgets/fallback_widget.dart';

import '../newTaskAddScreen/new_task_add_screen.dart';
import '../widgets/app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController pageController;
  late SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  List<Widget> screens = const [
    NewTaskAddScreen(),
    TaskProgressScreen(),
    TaskCompletedScreen(),
    TaskCancelledScreen(),
  ];

  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getApplicationAppBar(context: context, disableNavigation: false),
      body: GetBuilder<ConnectivityCheckerClass>(
        builder: (viewModel) {
          if (viewModel.isDeviceConnected) {
            return PageView.builder(
              onPageChanged: (int value) {
                Get.find<DashboardViewModelClass>().setIndex = value;
                Get.find<TaskViewModelClass>()
                    .removeBadgeCount(value, Get.find<DashboardViewModelClass>());
              },
              controller: pageController,
              itemCount: screens.length,
              itemBuilder: (context, index) {
                return screens[index];
              },
            );
          }
          return const Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    FallbackWidget(
                        noDataMessage: AppStrings.noInternetText,
                        asset: AppAssets.noInternet),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: GetBuilder<DashboardViewModelClass>(
        builder: (viewModel) {
          return SalomonBottomBar(
            currentIndex: viewModel.index,
            onTap: (index) {
              if (Get.find<ConnectivityCheckerClass>().isDeviceConnected) {
                pageController.jumpToPage(index);
              }
              viewModel.setIndex = index;
              Get.find<TaskViewModelClass>().removeBadgeCount(index, viewModel);
            },
            items: [
              SalomonBottomBarItem(
                  icon: Badge(
                    backgroundColor: AppColor.appPrimaryColor,
                    textColor: Colors.white,
                    isLabelVisible: (Get.find<TaskViewModelClass>()
                            .getBadgeCount(AppStrings.taskStatusNew)! >
                        0),
                    label: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(Get.find<TaskViewModelClass>()
                          .getBadgeCount(AppStrings.taskStatusNew)
                          .toString()),
                    ),
                    child: const Icon(Icons.add),
                  ),
                  title: const Text(AppStrings.taskStatusNew),
                  selectedColor: AppColor.appPrimaryColor,
                  unselectedColor:
                      (Get.find<ThemeChanger>().getThemeMode(context) ==
                              ThemeMode.dark)
                          ? Colors.white
                          : Colors.black),
              SalomonBottomBarItem(
                  icon: Badge(
                    backgroundColor: AppColor.appPrimaryColor,
                    textColor: Colors.white,
                    isLabelVisible: (Get.find<TaskViewModelClass>()
                            .getBadgeCount(AppStrings.taskStatusProgress)! >
                        0),
                    label: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(Get.find<TaskViewModelClass>()
                          .getBadgeCount(AppStrings.taskStatusProgress)
                          .toString()),
                    ),
                    child: const Icon(Icons.watch_later_outlined),
                  ),
                  title: const Text(AppStrings.taskStatusProgress),
                  selectedColor: AppColor.appPrimaryColor,
                  unselectedColor:
                      (Get.find<ThemeChanger>().getThemeMode(context) ==
                              ThemeMode.dark)
                          ? Colors.white
                          : Colors.black),
              SalomonBottomBarItem(
                  icon: Badge(
                    backgroundColor: AppColor.appPrimaryColor,
                    textColor: Colors.white,
                    isLabelVisible: (Get.find<TaskViewModelClass>()
                            .getBadgeCount(AppStrings.taskStatusCompleted)! >
                        0),
                    label: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(Get.find<TaskViewModelClass>()
                          .getBadgeCount(AppStrings.taskStatusCompleted)
                          .toString()),
                    ),
                    child: const Icon(Icons.done_outline_rounded),
                  ),
                  title: const Text(AppStrings.taskStatusCompleted),
                  selectedColor: AppColor.appPrimaryColor,
                  unselectedColor:
                      (Get.find<ThemeChanger>().getThemeMode(context) ==
                              ThemeMode.dark)
                          ? Colors.white
                          : Colors.black),
              SalomonBottomBarItem(
                  icon: Badge(
                    backgroundColor: AppColor.appPrimaryColor,
                    textColor: Colors.white,
                    isLabelVisible: (Get.find<TaskViewModelClass>()
                            .getBadgeCount(AppStrings.taskStatusCanceled)! >
                        0),
                    label: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(Get.find<TaskViewModelClass>()
                          .getBadgeCount(AppStrings.taskStatusCanceled)
                          .toString()),
                    ),
                    child: const Icon(Icons.cancel_outlined),
                  ),
                  title: const Text(AppStrings.taskStatusCanceled),
                  selectedColor: AppColor.appPrimaryColor,
                  unselectedColor:
                      (Get.find<ThemeChanger>().getThemeMode(context) ==
                              ThemeMode.dark)
                          ? Colors.white
                          : Colors.black),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    Get.find<ConnectivityCheckerClass>().disableInternetConnectionChecker();
    super.dispose();
  }
}
