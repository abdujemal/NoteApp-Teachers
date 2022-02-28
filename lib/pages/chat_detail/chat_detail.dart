import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/model/chat.dart';
import 'package:note_app_teachers/model/student.dart';
import 'package:note_app_teachers/pages/chat_detail/comp/chat_form.dart';
import 'package:note_app_teachers/pages/chat_detail/comp/my_chat_item.dart';
import 'package:note_app_teachers/pages/chat_detail/comp/sender_chat_item.dart';
import 'package:note_app_teachers/pages/chat_detail/controller/chat_detail_controller.dart';

class ChatDetail extends StatefulWidget {
  String sid;
  ChatDetail({Key? key, required this.sid}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  TextEditingController _chatTC = TextEditingController();

  String uid = FirebaseAuth.instance.currentUser!.uid;

  // Student student = Student("", "", "");

  CDController cdController = Get.put(CDController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cdController.setStudent(Student("", "", ""));

    FirebaseDatabase.instance
        .ref()
        .child("Students")
        .child(widget.sid)
        .once()
        .then((DatabaseEvent event) {
      Map<String, Object> map = Map<String, Object>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      Student student = Student.fromFireBaseMap(map);
      cdController.setStudent(student);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chatTC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference chatRef = FirebaseDatabase.instance
        .ref()
        .child("Chats")
        .child(uid + widget.sid)
        .child("chats");

    CDController cdController = Get.put(CDController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Obx(() {
          if (cdController.student.value != Student("", "", "")) {
            return Text(cdController.student.value.name);
          } else {
            return const Text("Loading");
          }
        }),
      ),
      body: Column(
        children: [
          Flexible(
              flex: 9,
              child: StreamBuilder(
                stream: chatRef.onValue,
                builder: (context, snapshot) {
                  cdController.isLoading(true);
                  List<Chat> chatList = [];
                  if (snapshot.hasData) {
                    if ((snapshot.data as DatabaseEvent).snapshot.value !=
                        null) {
                      final data = Map<String, Object>.from(
                          (snapshot.data as DatabaseEvent).snapshot.value
                              as Map<dynamic, dynamic>);
                      data.forEach((key, value) {
                        final chatData = Map<dynamic, dynamic>.from(
                            value as Map<dynamic, dynamic>);
                        final chatModel = Chat.fromFirebaseMap(chatData);
                        chatList.add(chatModel);
                      });
                      chatList.sort(((a, b) => b.cid.compareTo(a.cid)));
                      cdController.setIsLoading(false);
                    }
                  }

                  if (chatList.isEmpty) {
                    return const Center(
                      child: Text("No chat"),
                    );
                  }
                  return Obx(() => cdController.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(color: mainColor),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: chatList.length,
                          itemBuilder: (context, index) =>
                              chatList[index].from == uid
                                  ? MyChatItem(chat: chatList[index])
                                  : SenderChatItem(chat: chatList[index])));
                },
              )),
          Obx(() {
            if (cdController.student.value != Student("", "", "")) {
              return ChatForm(
                student: cdController.student.value,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })
        ],
      ),
    );
  }
}
