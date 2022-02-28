import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/input.dart';
import 'package:note_app_teachers/pages/main/drawer/controller/drawer_controller.dart';

class Editable extends StatelessWidget {
  TextEditingController nameTC = TextEditingController();
  TextEditingController subjectTC = TextEditingController();
  TextEditingController classessTC = TextEditingController();
  GlobalKey<FormState> accountKey = GlobalKey<FormState>();

  Editable(
      {Key? key,
      required this.nameTC,
      required this.subjectTC,
      required this.accountKey,
      required this.classessTC})
      : super(key: key);

  DController dController = Get.put(DController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: SingleChildScrollView(
        child: Form(
          key: accountKey,
          child: Column(
            children: [
              Input(
                  textEditingController: nameTC,
                  hinttxt: "Abebe Chala",
                  title: "Name",
                  keyboardType: TextInputType.name),
              const SizedBox(
                height: 15,
              ),
              Input(
                  textEditingController: subjectTC,
                  hinttxt: "Chemistry",
                  title: "Subject",
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 15,
              ),
              Input(
                  textEditingController: classessTC,
                  hinttxt: "12A,10B",
                  title: "Your Classes",
                  keyboardType: TextInputType.text),
              const SizedBox(height: 15,),
              Obx(()=>
                 dController.isLoading.value ?
                 CircularProgressIndicator(color: mainColor,) :
                 const SizedBox()
              ),
              const SizedBox(height: 400)
            ],
          ),
        ),
      ),
    );
  }
}
