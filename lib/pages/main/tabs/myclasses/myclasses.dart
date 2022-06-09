import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/btn.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/input.dart';
import 'package:note_app_teachers/pages/main/controller/tabs_controller.dart';
import 'package:note_app_teachers/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_teachers/pages/main/tabs/myclasses/comp/class_item.dart';
import 'package:note_app_teachers/pages/main/tabs/myclasses/controller/class_controller.dart';
import 'package:note_app_teachers/src/pages/call.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../model/class.dart';

class MyClasses extends StatelessWidget {
  MyClasses({Key? key}) : super(key: key);

  ClassController classController = Get.put(ClassController());
  UserService userService = Get.put(UserService());
  TabsController tabsController = Get.put(TabsController());

  Widget _getClassesList(BuildContext context) {
    DController dController = Get.put(DController());
    DatabaseReference classesRef =
        FirebaseDatabase.instance.ref().child("Grades");

    return Stack(
      children: [
        StreamBuilder(
          stream: classesRef.onValue,
          builder: (context, snapshot) {
            classController.setIsLoading(true);
            final List<Class> classesList = [];
            if (snapshot.hasData) {
              final classesMap = Map<String, Object>.from(
                  (snapshot.data as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);
              classesMap.forEach((key, value) {
                final classItem =
                    Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);
                final classModel = Class.fromFirebaseMap(classItem);
                if (dController.myInfo.value.classes
                    .toLowerCase()
                    .contains(classItem["grade"].toString().toLowerCase())) {
                  classesList.add(classModel);
                }
              });
              classController.setIsLoading(false);
            }
            return Obx(
              () => classController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    )
                  : ListView.builder(
                      itemCount: classesList.length,
                      itemBuilder: (context, index) {
                        return ClassItem(classs: classesList[index]);
                      },
                    ),
            );
          },
        ),
        Positioned(
          bottom: 5,
          right: 0,
          child: RawMaterialButton(
              onPressed: () async {
                var titleTC = TextEditingController();
                Get.bottomSheet(Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(children: [
                    const SizedBox(height: 20,),
                    Input(
                        hinttxt: "Chapter 6",
                        title: "Title",
                        textEditingController: titleTC,
                        keyboardType: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() => !tabsController.isLoading.value
                        ? BTN(
                            text: "Start",
                            action: () async {
                              await userService.startLive(titleTC.text);
                              // await for camera and mic permissions before pushing video page
                              await [Permission.microphone, Permission.camera]
                                  .request();
                              // push video page with given channel name
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallPage(
                                      channelName: dController.myInfo.value.uid,
                                      role: ClientRole.Broadcaster),
                                ),
                              );
                            })
                        : const CircularProgressIndicator())
                  ]),
                ));
              },
              shape: const CircleBorder(),
              fillColor: mainColor,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.video_call_outlined,
                  size: 40,
                  color: Colors.red,
                ),
              )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());
    Get.find<UserService>().getUserInfo();
    return _getClassesList(context);
  }
}
