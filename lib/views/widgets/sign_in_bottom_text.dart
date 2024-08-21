import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/all_color.dart';
import '../../utils/app_strings_and_api.dart';

class SignInBottomText extends StatelessWidget {
  final Function route;

  const SignInBottomText({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppStrings.signUpBottomTextOne,
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: AppStrings.signUpBottomTextTwo,
              recognizer: TapGestureRecognizer()..onTap = () => route(),
              style: const TextStyle(
                color: AppColor.appPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
