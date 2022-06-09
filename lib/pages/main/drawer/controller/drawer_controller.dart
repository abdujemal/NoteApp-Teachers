import 'package:get/get.dart';
import 'package:note_app_teachers/model/myinfo.dart';

class DController extends GetxController {
  var isLoading = false.obs;
  var isEditable = false.obs;
  var profileImage = "".obs;

  Rx<MyInfo> myInfo = MyInfo("", "", "", "", "").obs;

  void setIsEditable(bool val) {
    isEditable.value = val;
  }

  void setMyInfo(MyInfo newInfo) {
    myInfo.value = newInfo;
  }

  void setIsLoading(bool val) {
    isLoading.value = val;
  }

  void setProfileImage(String img) {
    profileImage.value = img;
  }
}
