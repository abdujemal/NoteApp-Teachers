import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/comp/msg_snack.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/btn.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/input.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/txt_btns.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  TextEditingController emailTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();
  TextEditingController comfirmPasswordTC = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTC.dispose();
    passwordTC.dispose();
    comfirmPasswordTC.dispose();
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
              "Sign Up",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: _signUpKey,
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
                      height: 20,
                    ),
                    Input(
                        textEditingController: comfirmPasswordTC,
                        hinttxt: "********",
                        title: "Re-write your Password",
                        keyboardType: TextInputType.visiblePassword),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        TxtBtns(
                          type: "signUp",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BTN(
                        text: "Sign Up",
                        action: () {
                          if (_signUpKey.currentState!.validate()) {
                            if (passwordTC.text == comfirmPasswordTC.text) {
                              Get.find<UserService>().signUpWEmailNPW(
                                  emailTC.text, passwordTC.text,context);
                            } else {
                              MSGSnack errorMSG = MSGSnack(
                                  color: Colors.red,
                                  msg: "Please write the correct password!",
                                  title: "Error!");
                              errorMSG.show();
                            }
                          }
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                      child: Text(
                        "OR",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                      child: Text(
                        "Sign Up with",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Icon(
                        FontAwesomeIcons.google,
                        color: mainColor,
                        size: 40,
                      ),
                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
