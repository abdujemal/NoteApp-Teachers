import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/controller/signuplogin_controller.dart';
import 'package:note_app_teachers/pages/RegisterationPage/registration_page.dart';
import 'package:note_app_teachers/pages/main/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.lazyPut(() => UserService());
        Get.find<UserService>().checkUser(context);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RegistrationPage()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: mainColor,
        image: const DecorationImage(
            fit: BoxFit.cover, image: AssetImage("assets/background.jpg")),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/noteapp_txt.png",
            width: 300,
          ),
          CircularProgressIndicator(color: mainColor,)
        ],
      ),
    ));
  }
}
