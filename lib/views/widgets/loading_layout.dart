import 'package:flutter/material.dart';

import '../../utils/all_color.dart';

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(
          color: AppColor.appPrimaryColor,
        ),
      ),
    );
  }
}
