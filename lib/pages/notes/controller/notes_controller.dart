import 'package:get/get.dart';

class NoteController extends GetxController {
  RxBool isLoading = false.obs;
  setIsLoading(bool val) {
    isLoading.value = val;
  }
}
