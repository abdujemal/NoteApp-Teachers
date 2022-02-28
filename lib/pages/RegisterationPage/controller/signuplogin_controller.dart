import 'package:get/get.dart';

class SLController extends GetxController {
  RxString regState = RegState.login.obs;

  RxBool isLoading = false.obs;

  void toogleRegState(String state) {
    regState.value = state;
  }

  void setIsLoading(bool val) {
    isLoading.value = val;
  }
}

class RegState {
  static const login = "Login";
  static const signUp = "SignUp";
  
}
