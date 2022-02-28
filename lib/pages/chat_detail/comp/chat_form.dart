import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_app_teachers/comp/msg_snack.dart';
import 'package:note_app_teachers/model/chat.dart';
import 'package:note_app_teachers/model/student.dart';
import 'package:note_app_teachers/pages/main/drawer/controller/drawer_controller.dart';

class ChatForm extends StatefulWidget {
  Student student;
  ChatForm({Key? key, required this.student}) : super(key: key);

  @override
  _ChatFormState createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  TextEditingController _chatTC = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference chatRef = FirebaseDatabase.instance.ref().child("Chats");
  DController dController = Get.put(DController());

  sendChat() async {
    var now = DateTime.now();
    var formatterDate = DateFormat('dd/MM/yy');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    if (_chatTC.text.isNotEmpty) {
      chatRef = FirebaseDatabase.instance
          .ref()
          .child("Chats")
          .child(uid + widget.student.uid);

      final Map<String, Object> chatInfo = {
        
        "studentName": widget.student.name,
        "teacherName": dController.myInfo.value.name,
        "lastMsg": _chatTC.text
      };
      chatRef.update(chatInfo);

      chatRef = chatRef.child("chats").push();

      Chat chat = Chat(_chatTC.text, actualDate, actualTime, uid,
          widget.student.uid, chatRef.key.toString());
      final Map<String, Object> map = chat.toFirebaseMap(chat);
      try {
        await chatRef.update(map);
        _chatTC.text = "";
      } catch (e) {
        MSGSnack msgSnack =
            MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);
        msgSnack.show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Row(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    controller: _chatTC,
                    decoration: const InputDecoration.collapsed(
                      hintText: "",
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: const Chip(
                label: Text("Send"),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              onTap: () {
                sendChat();
              },
            )
          ],
        ));
  }
}
