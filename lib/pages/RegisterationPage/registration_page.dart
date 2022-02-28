// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/login.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/signup.dart';
import 'package:note_app_teachers/pages/RegisterationPage/controller/signuplogin_controller.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  SLController slController = Get.put(SLController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/noteapp_txt_w.png",
                width: 250,
              ),
              Obx(() {
                switch (slController.regState.value) {
                  case (RegState.login):
                    return const LogIn();
                  case (RegState.signUp):
                    return const SignUp();
                 
                }
                if (slController.regState.value.isEmpty) {
                  return const LogIn();
                } else {
                  return const SignUp();
                }
              }),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
