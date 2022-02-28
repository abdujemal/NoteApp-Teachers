import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/main/drawer/comp/editable.dart';
import 'package:note_app_teachers/pages/main/drawer/comp/non_editable.dart';
import '../../../model/myinfo.dart';
import 'controller/drawer_controller.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  DController drawerController = Get.put(DController());

  TextEditingController nameTC = TextEditingController();
  TextEditingController subjectTC = TextEditingController();
  TextEditingController classessTC = TextEditingController();
  GlobalKey<FormState> _accountKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    nameTC.dispose();
    subjectTC.dispose();
    classessTC.dispose();
  }

  getUserInfo() async {
    await Get.find<UserService>().getUserInfo();

    nameTC.text = drawerController.myInfo.value.name;
    subjectTC.text = drawerController.myInfo.value.subject;
    classessTC.text = drawerController.myInfo.value.classes;
  }

  saveUserInfo() async {
    await Get.find<UserService>()
        .saveUserInfoFromDrawer(
            nameTC.text, subjectTC.text, classessTC.text, context)
        .then((val) {
      drawerController.setIsEditable(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());

    getUserInfo();

    drawerController.setIsEditable(false);

    return Drawer(
      backgroundColor: mainColor,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Positioned(
              bottom: 505,
              right: 45,
              child: Image.asset(
                "assets/noteapp_txt_w.png",
                width: 200,
              )),
          Container(
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            height: 450,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Obx(() => drawerController.isEditable.value
                      ? Editable(
                          nameTC: nameTC,
                          subjectTC: subjectTC,
                          classessTC: classessTC,
                          accountKey: _accountKey,
                        )
                      : NonEditable())
                ],
              ),
            ),
          ),
          Positioned(
              right: 105,
              bottom: 400,
              child: CircleAvatar(
                  radius: 45,
                  backgroundColor: mainColor,
                  child: Icon(
                    Icons.account_circle,
                    color: whiteColor,
                    size: 90,
                  ))),
          Positioned(
            bottom: 395,
            right: 30,
            child: IconButton(
              icon: Obx(() => drawerController.isEditable.value
                  ? const Icon(
                      Icons.check_circle_outlined,
                      color: Color.fromARGB(255, 40, 197, 45),
                    )
                  : const Icon(Icons.edit)),
              onPressed: () {
                if (drawerController.isEditable.isTrue) {
                  if (_accountKey.currentState!.validate()) {
                    saveUserInfo();
                  }
                } else {
                  drawerController.setIsEditable(true);
                }
              },
            ),
          ),
          Obx(() => Align(
                // bottom: 400,
                // right: 130,
                alignment: Alignment.center,
                child: drawerController.isEditable.value
                    ? const SizedBox()
                    : Text(
                        drawerController.myInfo.value.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
              ))
        ],
      ),
    );
  }
}
