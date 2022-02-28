import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/model/class.dart';
import 'package:note_app_teachers/pages/add_note.dart/add_note.dart';
import 'package:note_app_teachers/pages/notes/notes.dart';

class ClassItem extends StatelessWidget {
  Class classs;
  ClassItem({Key? key, required this.classs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => NotesPage(grade: classs.grade));
      },
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black38, width: 1))),
        child: ListTile(
          leading: Image.asset("assets/class.png"),
          title: Text(classs.grade),
          trailing: Chip(
            label: Text("${classs.numOfStudent} students"),
          ),
        ),
      ),
    );
  }
}
