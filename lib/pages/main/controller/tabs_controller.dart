import 'package:get/get.dart';

class TabsController extends GetxController {
  var isLoading = false.obs;

  var selectedIndex = 0.obs;

  void setSellectedTab(int index) {
    selectedIndex.value = index;
  }

  void setIsLoading(bool val) {
    isLoading.value = val;
  }
}
