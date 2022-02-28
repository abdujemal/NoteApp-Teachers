import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_teachers/pages/main/tabs/myclasses/comp/class_item.dart';
import 'package:note_app_teachers/pages/main/tabs/myclasses/controller/class_controller.dart';

import '../../../../model/class.dart';

class MyClasses extends StatelessWidget {
  MyClasses({Key? key}) : super(key: key);

  ClassController classController = Get.put(ClassController());

  Widget _getClassesList() {
    DController dController = Get.put(DController());
    DatabaseReference classesRef =
        FirebaseDatabase.instance.ref().child("Grades");
        

    return StreamBuilder(
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
            if (dController.myInfo.value.classes.toLowerCase().contains(classItem["grade"].toString().toLowerCase())) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());
    Get.find<UserService>().getUserInfo();
    return _getClassesList();
  }
}
