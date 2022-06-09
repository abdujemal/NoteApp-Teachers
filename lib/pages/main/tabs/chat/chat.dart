import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/main.dart';
import 'package:note_app_teachers/model/indox.dart';
import 'package:note_app_teachers/model/student.dart';
import 'package:note_app_teachers/pages/AddChat/add_chat.dart';
import 'package:note_app_teachers/pages/chat_detail/chat_detail.dart';
import 'package:note_app_teachers/pages/main/tabs/chat/controller/inbox_controller.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);
  DatabaseReference accRef = FirebaseDatabase.instance.ref().child("Chats");
  String uid = FirebaseAuth.instance.currentUser!.uid;
  InboxController inboxController = Get.put(InboxController());

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());
    return Column(
      children: [
        Flexible(
          flex: 12,
          child: StreamBuilder(
            stream: accRef.onValue,
            builder: (context, snapshot) {
              final List<Inbox> inboxList = [];
              inboxController.setIsLoading(true);
              if (snapshot.hasData) {
                if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
                  final data = Map<String, Object>.from(
                      (snapshot.data as DatabaseEvent).snapshot.value
                          as Map<dynamic, dynamic>);
                  data.forEach((key, value) {
                    if (key.contains(uid)) {
                      Map<dynamic, dynamic> inboxData =
                          Map<dynamic, dynamic>.from(
                              value as Map<dynamic, dynamic>);
                      Inbox inbox = Inbox(
                          inboxData["studentName"],
                          inboxData["lastMsg"],
                          inboxData["teacherName"],
                          key.replaceAll(uid, ""));
                      inboxList.add(inbox);
                    }
                  });
                  inboxController.setIsLoading(false);
                }
              }
              
              return inboxController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(color: mainColor),
                    )
                  : inboxList.isEmpty ?
                  const Center(child: Text("No Chats")):
                   ListView.builder(
                      itemCount: inboxList.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(inboxList[index].studentName),
                        subtitle: Text(inboxList[index].lastMsg),
                        onTap: () {
                          Get.to(() => ChatDetail(sid: inboxList[index].sid));
                        },
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.account_circle,
                            size: 40,
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const AddChat());
                  },
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: mainColor),
                      child: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
