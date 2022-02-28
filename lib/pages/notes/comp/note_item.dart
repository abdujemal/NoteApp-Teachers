import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/model/note.dart';
import 'package:note_app_teachers/pages/note_viewer/note_viewer.dart';
import 'package:path_provider/path_provider.dart';

class NoteItem extends StatelessWidget {
  Note note;
  NoteItem({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        Get.to(() => NoteViewer(note: note));
        // Directory appDocDir = await getApplicationSupportDirectory();
        // print("${appDocDir.path}/${note.nid}.pdf");
      },
      leading: Image.asset("assets/note_icon.png"),
      title: Text(note.title),
      subtitle: Text(
        note.description,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Chip(label: Text("Grade ${note.grade}")),
    );
  }
}
