import 'package:get/get.dart';

class ToggleButtonVisibility extends GetxController {
  bool isLoading = false;

  void startLoading(bool) {
    isLoading = true;
    update();
  }

  void stopLoading() {
    isLoading = false;
    update();
  }
}
