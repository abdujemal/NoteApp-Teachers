import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Note App - Teachers',
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: whiteColor, 
            primaryColor: mainColor),
        home: const SplashScreen());
  }
}
