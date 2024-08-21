import 'package:get/get.dart';

class CountdownTimerViewModelClass extends GetxController {
  int _resendTimeLeft = 60;

  int get resendTimeLeft => _resendTimeLeft;

  void updateCountdown() {
    _resendTimeLeft--;
    update();
  }

  void resetCountDown() {
    _resendTimeLeft = 60;
  }
}
