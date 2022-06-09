import 'package:flutter/material.dart';
import 'package:note_app_teachers/model/live_chat.dart';

class LiveChatItem extends StatelessWidget {
  LiveChat liveChat;
  LiveChatItem({Key? key, required this.liveChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(liveChat.img_url),
          ),
          const SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(liveChat.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white)),
              
              Text(liveChat.text, style: const TextStyle(fontSize: 13, color: Colors.white),)
            ],
            )
        ],
      ),
    );
  }
}
