import 'package:flutter/material.dart';
import 'package:note_app_teachers/model/chat.dart';

class MyChatItem extends StatelessWidget {
  Chat chat;
  MyChatItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      child: Container(
        width: double.infinity,
        child: Row(
          children: [
            const Spacer(),
            Flexible(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                  Row(
                    children: [
                      const Spacer(),
                      Text(chat.text,style: const TextStyle(fontSize: 18),),
                    ],
                  ),
                  Row(
                    children: [
                      Text("${chat.date} at ${chat.time}", style: const TextStyle(fontSize:10 ,color:  Color.fromARGB(255, 87, 86, 86)),),
                    ],
                  )
                ]),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
