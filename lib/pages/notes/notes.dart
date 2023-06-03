import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/model/note.dart';
import 'package:note_app_teachers/pages/add_note.dart/add_note.dart';
import 'package:note_app_teachers/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_teachers/pages/notes/comp/note_item.dart';
import 'package:note_app_teachers/pages/notes/controller/notes_controller.dart';

class NotesPage extends StatelessWidget {
  String grade;
  NotesPage({Key? key, required this.grade}) : super(key: key);

  DatabaseReference notesRef = FirebaseDatabase.instance.ref().child("Notes");

  NoteController noteController = Get.put(NoteController());

  DController dController = Get.put(DController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Text("Grade $grade"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
          Get.to(() => AddNote(grade: grade));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: notesRef.onValue,
        builder: (context, snapshot) {
          noteController.setIsLoading(true);
          List<Note> noteList = [];
          if (snapshot.hasData) {
            final notesdata = Map<String, Object>.from(
                (snapshot.data as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);
            notesdata.forEach((key, value) {
              final note =
                  Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);
              final noteModel = Note.fromFirebaseMap(note);
              if (note["subject"] == dController.myInfo.value.subject.toLowerCase()) {
                if (note["grade"].toString().toLowerCase() ==
                    grade.toLowerCase()) {
                  noteList.add(noteModel);
                }
              }
            });
            noteList.sort(((a, b) => a.nid.compareTo(b.nid)));
            noteController.setIsLoading(false);
          }
          if (noteList.isEmpty) {
            return const Center(
              child: Text("No Notes"),
            );
          }
          return Obx(
            () => noteController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  )
                : ListView.builder(
                    itemCount: noteList.length,
                    itemBuilder: (context, index) =>
                        NoteItem(note: noteList[index])),
          );
        },
      ),
    );
  }
}
