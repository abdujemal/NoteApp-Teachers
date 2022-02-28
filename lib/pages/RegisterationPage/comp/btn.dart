import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/pages/RegisterationPage/controller/signuplogin_controller.dart';

import '../../../constants/values.dart';

class BTN extends StatelessWidget {
  String text;
  void Function() action;
  BTN({Key? key, required this.text, required this.action}) : super(key: key);

  SLController slController = Get.put(SLController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Center(
          child: slController.isLoading.value
              ? CircularProgressIndicator(
                  color: mainColor,
                )
              : InkWell(
                  onTap: () => action(),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: mainColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Center(
                            child: Text(
                          text,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ),
        );
      }
    );
  }
}
