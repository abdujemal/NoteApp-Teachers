import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/btn.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/input.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/more_info_sheet.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/txt_btns.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTC.dispose();
    passwordTC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());

    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const SizedBox(
              height: 45,
            ),
            const Text(
              "Log In",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: _loginKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8, left: 34, right: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Input(
                      textEditingController: emailTC,
                      title: "Email",
                      hinttxt: "abc@website.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Input(
                        textEditingController: passwordTC,
                        hinttxt: "********",
                        title: "Password",
                        keyboardType: TextInputType.visiblePassword),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TxtBtns(
                          type: "logIn",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BTN(
                        text: "Login",
                        action: () {
                          if (_loginKey.currentState!.validate()) {
                            Get.find<UserService>()
                                .logInWEmailNPW(emailTC.text, passwordTC.text,context);
                          }
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      "OR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      "Log In with",
                      style: TextStyle(fontSize: 15),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Icon(
                      FontAwesomeIcons.google,
                      color: mainColor,
                      size: 40,
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: 40,
                        height: 2,
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
