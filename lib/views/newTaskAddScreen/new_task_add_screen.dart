import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/services/connectivity_checker.dart';
import 'package:task_manager_getx/utils/all_color.dart';
import 'package:task_manager_getx/utils/app_navigator.dart';
import 'package:task_manager_getx/utils/app_strings_and_api.dart';
import 'package:task_manager_getx/views/widgets/fallback_widget.dart';
import 'package:task_manager_getx/views/widgets/loading_layout.dart';
import 'package:task_manager_getx/views/widgets/task_list_card.dart';
import 'package:task_manager_getx/views/widgets/task_status_card.dart';

import '../../utils/app_paths.dart';
import '../../viewModels/task_view_model.dart';
import '../../viewModels/user_view_model.dart';

class NewTaskAddScreen extends StatefulWidget {
  const NewTaskAddScreen({super.key});

  @override
  State<NewTaskAddScreen> createState() => _NewTaskAddScreenState();
}

class _NewTaskAddScreenState extends State<NewTaskAddScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        margin: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          color: AppColor.appPrimaryColor,
          onRefresh: () async {
            await fetchTasksData();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: GetBuilder<ConnectivityCheckerClass>(
                  builder: (connectivityViewModel) {
                    if (connectivityViewModel.isDeviceConnected) {
                      if (Get.find<TaskViewModelClass>()
                              .taskDataByStatus[AppStrings.taskStatusNew] ==
                          null) {
                        fetchTasksData();
                      }
                      return GetBuilder<TaskViewModelClass>(
                        builder: (viewModel) {
                          if (viewModel.taskStatusCount.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Row(
                            children: [
                              TaskStatusCard(
                                  screenWidth: screenWidth,
                                  titleText: (viewModel.taskStatusCount[
                                              AppStrings.taskStatusCanceled] !=
                                          "0")
                                      ? viewModel.taskStatusCount[
                                                  AppStrings.taskStatusCanceled]
                                              ?.padLeft(2, "0") ??
                                          "0"
                                      : "0",
                                  subtitleText: "Canceled"),
                              TaskStatusCard(
                                  screenWidth: screenWidth,
                                  titleText: (viewModel.taskStatusCount[
                                              AppStrings.taskStatusCompleted] !=
                                          "0")
                                      ? viewModel.taskStatusCount[AppStrings
                                                  .taskStatusCompleted]
                                              ?.padLeft(2, "0") ??
                                          "0"
                                      : "0",
                                  subtitleText: AppStrings.taskStatusCompleted),
                              TaskStatusCard(
                                  screenWidth: screenWidth,
                                  titleText: (viewModel.taskStatusCount[
                                              AppStrings.taskStatusProgress] !=
                                          "0")
                                      ? viewModel.taskStatusCount[
                                                  AppStrings.taskStatusProgress]
                                              ?.padLeft(2, "0") ??
                                          "0"
                                      : "0",
                                  subtitleText: AppStrings.taskStatusProgress),
                              TaskStatusCard(
                                  screenWidth: screenWidth,
                                  titleText: (viewModel.taskStatusCount[
                                              AppStrings.taskStatusNew] !=
                                          "0")
                                      ? viewModel.taskStatusCount[
                                                  AppStrings.taskStatusNew]
                                              ?.padLeft(2, "0") ??
                                          "0"
                                      : "0",
                                  subtitleText: AppStrings.taskStatusNew),
                            ],
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const Gap(5),
              GetBuilder<TaskViewModelClass>(builder: (viewModel) {
                if (viewModel.taskDataByStatus[AppStrings.taskStatusNew] ==
                    null) {
                  return const LoadingLayout();
                }
                if (viewModel
                    .taskDataByStatus[AppStrings.taskStatusNew]!.isEmpty) {
                  return const FallbackWidget(
                      noDataMessage: AppStrings.noNewTaskData,
                      asset: AppAssets.emptyList);
                }
                return TaskListCard(
                  screenWidth: screenWidth,
                  taskData:
                      viewModel.taskDataByStatus[AppStrings.taskStatusNew]!,
                  chipColor: AppColor.newTaskChipColor,
                  currentScreen: AppStrings.taskStatusNew,
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addTaskScreen);
        },
        backgroundColor: AppColor.appPrimaryColor,
        child: const Icon(Icons.add, size: 27),
        //params
      ),
    );
  }

  Future<void> fetchTasksData() async {
    if (mounted) {
      await Get.find<TaskViewModelClass>()
          .fetchTaskStatusData(Get.find<UserViewModelClass>().token);
    }
    if (mounted) {
      await Get.find<TaskViewModelClass>()
          .fetchTaskList(Get.find<UserViewModelClass>().token);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
