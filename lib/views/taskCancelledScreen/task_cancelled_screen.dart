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

class TaskCancelledScreen extends StatefulWidget {
  const TaskCancelledScreen({super.key});

  @override
  State<TaskCancelledScreen> createState() => _TaskCancelledScreenState();
}

class _TaskCancelledScreenState extends State<TaskCancelledScreen> {
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
                if (viewModel.taskDataByStatus[AppStrings.taskStatusCanceled] ==
                    null) {
                  return const LoadingLayout();
                }
                if (viewModel
                    .taskDataByStatus[AppStrings.taskStatusCanceled]!.isEmpty) {
                  return const FallbackWidget(
                    noDataMessage: AppStrings.noNewCanceledData,
                    asset: AppAssets.emptyList,
                  );
                }
                return TaskListCard(
                  screenWidth: screenWidth,
                  taskData: viewModel
                      .taskDataByStatus[AppStrings.taskStatusCanceled]!,
                  chipColor: AppColor.canceledChipColor,
                  currentScreen: AppStrings.taskStatusCanceled,
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
