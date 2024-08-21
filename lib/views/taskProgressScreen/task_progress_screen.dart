import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/app_paths.dart';
import '../../utils/all_color.dart';
import '../../utils/app_strings_and_api.dart';
import '../../viewModels/task_view_model.dart';
import '../../viewModels/user_view_model.dart';
import '../widgets/fallback_widget.dart';
import '../widgets/loading_layout.dart';
import '../widgets/task_list_card.dart';

class TaskProgressScreen extends StatefulWidget {
  const TaskProgressScreen({super.key});

  @override
  State<TaskProgressScreen> createState() => _TaskProgressScreenState();
}

class _TaskProgressScreenState extends State<TaskProgressScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(8),
        child: RefreshIndicator(
          color: AppColor.appPrimaryColor,
          onRefresh: () async {
            await fetchListData();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(5),
              GetBuilder<TaskViewModelClass>(builder: (viewModel) {
                if (viewModel.taskDataByStatus[AppStrings.taskStatusProgress] ==
                    null) {
                  return const LoadingLayout();
                }
                if (viewModel
                    .taskDataByStatus[AppStrings.taskStatusProgress]!.isEmpty) {
                  return const FallbackWidget(
                    noDataMessage: AppStrings.noProgressTaskData,
                    asset: AppAssets.emptyList,
                  );
                }
                return TaskListCard(
                  screenWidth: screenWidth,
                  taskData: viewModel
                      .taskDataByStatus[AppStrings.taskStatusProgress]!,
                  chipColor: AppColor.progressChipColor,
                  currentScreen: AppStrings.taskStatusProgress,
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchListData() async {
    await Get.find<TaskViewModelClass>()
        .fetchTaskList(Get.find<UserViewModelClass>().token);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
