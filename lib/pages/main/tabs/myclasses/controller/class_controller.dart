import 'package:get/get.dart';

class ClassController extends GetxController {
  RxBool isLoading = false.obs;
  setIsLoading(bool val) {
    isLoading.value = val;
  }
}
