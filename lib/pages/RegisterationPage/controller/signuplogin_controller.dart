import 'package:get/get.dart';

class SLController extends GetxController {
  RxString regState = RegState.login.obs;

  RxString profileImage = "".obs;

  RxBool isLoading = false.obs;

  void toogleRegState(String state) {
    regState.value = state;
  }

  void setIsLoading(bool val) {
    isLoading.value = val;
  }

  void setProfileImage(String img) {
    profileImage.value = img;
  }
}

class RegState {
  static const login = "Login";
  static const signUp = "SignUp";
}
