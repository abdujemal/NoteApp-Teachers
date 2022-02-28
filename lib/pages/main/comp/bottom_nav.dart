import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/main/controller/tabs_controller.dart';

class BottomNav extends StatelessWidget {
  BottomNav({Key? key}) : super(key: key);

  TabsController tabsController = Get.put(TabsController());
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() {
            bool isZero = tabsController.selectedIndex.value == 0;
            return IconButton(
                onPressed: () {
                  tabsController.setSellectedTab(0);
                },
                icon: Icon(
                  Icons.filter_list,
                  color: isZero ? mainColor : Colors.black,
                ));
          }),
          const SizedBox(
            width: 48,
          ),
          Obx(() {
            bool isOne = tabsController.selectedIndex.value == 1;
            return IconButton(
                icon: Icon(
                  Icons.chat,
                  color: isOne ? mainColor : Colors.black,
                ),
                onPressed: () {
                  tabsController.setSellectedTab(1);
                });
          })
        ],
      ),
    );
  }
}
