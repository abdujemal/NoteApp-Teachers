import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/note_viewer/controller/pdf_viewer_controller.dart';

class GoToPageUi extends StatefulWidget {
 
  const GoToPageUi({Key? key}) : super(key: key);

  @override
  _GoToPageUiState createState() => _GoToPageUiState();
}

class _GoToPageUiState extends State<GoToPageUi> {
  TextEditingController _pageTC = TextEditingController();
  PVController pvController = Get.put(PVController());

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: _pageTC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Page number"),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (double.parse(_pageTC.text).round() <= 0) {
                  pvController.pdfController.value.goToPage(pageNumber: 1);
                } else if (double.parse(_pageTC.text).round() >
                    pvController.allPageCount.value) {
                  pvController.pdfController.value
                      .goToPage(pageNumber: pvController.allPageCount.value);
                } else {
                  pvController.pdfController.value
                      .goToPage(pageNumber: double.parse(_pageTC.text).round());
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: mainColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Go",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}
