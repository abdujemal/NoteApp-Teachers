import 'package:get/get.dart';

class ACControlelr extends GetxController{
  RxBool isLoading = false.obs;
  setIsLoading(val) {
    isLoading.value = val;
  }
}
