import 'package:get/get.dart';

class TabsController extends GetxController {
  var selectedIndex = 0.obs;

  void setSellectedTab(int index) {
    selectedIndex.value = index;
  }
}
