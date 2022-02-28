import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/send_notification.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/add_note.dart/add_note.dart';
import 'package:note_app_teachers/pages/main/comp/bottom_nav.dart';
import 'package:note_app_teachers/pages/main/controller/tabs_controller.dart';
import 'package:note_app_teachers/pages/main/drawer/main_drawer.dart';
import 'package:note_app_teachers/pages/main/tabs/chat/chat.dart';
import 'package:note_app_teachers/pages/main/tabs/myclasses/myclasses.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  List<String> tabNames = ["My Classes", "Chat"];

  TabsController tabsController = Get.put(TabsController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> tabs = [
    MyClasses(),
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        centerTitle: true,
        backgroundColor: mainColor,
        title: Obx(
          () => Text(
            tabNames[tabsController.selectedIndex.value],
          ),
        ),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
          Get.to(() =>AddNote(grade: "",));
          
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() => tabs[tabsController.selectedIndex.value]),
    );
  }
}
