import 'package:get/get.dart';

class InboxController extends GetxController {
  RxBool isLoading = false.obs;
  setIsLoading(bool val) {
    isLoading.value = val;
  }
}
