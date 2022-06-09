import 'package:get/get.dart';

class CallController extends GetxController{
  var users = <int>[].obs;
  var infoStrings = <String>[].obs;
  var muted = false.obs;
  var isChatEnabled = true.obs;
}