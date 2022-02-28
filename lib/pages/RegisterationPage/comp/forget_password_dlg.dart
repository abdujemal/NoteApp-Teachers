import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/btn.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/input.dart';

class ForgetPasswordDlg extends StatefulWidget {
  const ForgetPasswordDlg({Key? key}) : super(key: key);

  @override
  _ForgetPasswordDlgState createState() => _ForgetPasswordDlgState();
}

class _ForgetPasswordDlgState extends State<ForgetPasswordDlg> {
  TextEditingController emailTC = TextEditingController();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());

    return Padding(
      padding:
          const EdgeInsets.only(top: 200, bottom: 280, right: 27, left: 27),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              color: whiteColor, borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Forget Password?",
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    width: 214,
                    child: Text(
                      "Enter registeration Email Address to recover password.",
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 112, 112),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                      key: _emailKey,
                      child: Column(
                        children: [
                          Input(
                            textEditingController: emailTC,
                            hinttxt: "johnDoe@myapp.com",
                            title: "Email",
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  BTN(
                      text: "Reset Password",
                      action: () {
                        if (_emailKey.currentState!.validate()) {
                          Get.put(UserService()).forgetPassword(emailTC.text, context);
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
