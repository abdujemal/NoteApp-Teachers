import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/model/note.dart';
import 'package:note_app_teachers/pages/note_viewer/comp/downloading_ui.dart';
import 'package:note_app_teachers/pages/note_viewer/comp/go_to_page_ui.dart';
import 'package:note_app_teachers/pages/note_viewer/controller/pdf_viewer_controller.dart';
import 'package:path_provider/path_provider.dart';

class NoteViewer extends StatefulWidget {
  Note note;
  NoteViewer({Key? key, required this.note}) : super(key: key);

  @override
  _NoteViewerState createState() => _NoteViewerState();
}

class _NoteViewerState extends State<NoteViewer> {
  PVController pvController = Get.put(PVController());
  Directory appDocDir = Directory("");

  int _allPagesCount = 0;

  int _actualPageNumber = 1;

  int initialPage = 1;

  @override
  void initState() {
    Get.lazyPut(() => UserService());
    // TODO: implement initState
    super.initState();
    pvController.setFilePath("");

    checkTheFileExists();
  }

  checkTheFileExists() async {
    String nid = widget.note.nid;
    appDocDir = await getApplicationDocumentsDirectory();
    if (await File('${appDocDir.path}/${nid}.pdf').exists()) {
      print("${appDocDir.path}/${nid}.pdf");
      pvController.setFilePath("${appDocDir.path}/${nid}.pdf");
      pvController.setController(PdfControllerPinch(
          initialPage: initialPage,
          document: PdfDocument.openFile(
              "${appDocDir.path}/${widget.note.nid}.pdf")));
    } else {
      pvController.setFilePath("");
      await Get.find<UserService>().downloadPDF(nid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.note.title),
        ),
        body: Obx(() {
          if (pvController.filePath.value == "") {
            return const DownloadingUi();
          } else {
            return Column(
              children: [
                const GoToPageUi(),
                Flexible(
                  flex: 9,
                  child: PdfViewPinch(
                    documentLoader:
                        const Center(child: CircularProgressIndicator()),
                    pageLoader:
                        const Center(child: CircularProgressIndicator()),
                    controller: pvController.pdfController.value,
                    onDocumentLoaded: (document) {
                      pvController.setAllPageCount(document.pagesCount);
                    },
                    onPageChanged: (page) {
                      setState(() {
                        _actualPageNumber = page;
                      });
                    },
                  ),
                ),
              ],
            );
          }
        }));
  }
}
