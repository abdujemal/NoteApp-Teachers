import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/forget_password_dlg.dart';
import 'package:note_app_teachers/pages/RegisterationPage/controller/signuplogin_controller.dart';

class TxtBtns extends StatelessWidget {
  String type;
  TxtBtns({Key? key, required this.type}) : super(key: key);

  SLController slController = Get.put(SLController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            if (type == "signUp") {
              Get.find<SLController>().toogleRegState(RegState.login);
            } else {
              Get.find<SLController>().toogleRegState(RegState.signUp);
            }
          },
          child: Text(
            type == "signUp"
                ? "Already have an account? Log In"
                : "New to this App? Sign Up",
            style: const TextStyle(
                color: Color.fromARGB(255, 97, 97, 97),
                decoration: TextDecoration.underline,
                fontSize: 12),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        type == "signUp"
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  Get.dialog(const ForgetPasswordDlg());
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                      color: Color.fromARGB(255, 97, 97, 97),
                      decoration: TextDecoration.underline,
                      fontSize: 12),
                ),
              )
      ],
    );
  }
}
