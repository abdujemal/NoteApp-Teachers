import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app_teachers/Firebase%20Services/user_service.dart';
import 'package:note_app_teachers/comp/msg_snack.dart';
import 'package:note_app_teachers/constants/values.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/btn.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/input.dart';

class AddNote extends StatefulWidget {
  String grade;
  AddNote({Key? key, required this.grade}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController noteTitleTC = TextEditingController();
  TextEditingController noteSubjectTC = TextEditingController();
  TextEditingController noteDiscTC = TextEditingController();
  TextEditingController noteGradeTC = TextEditingController();
  GlobalKey<FormState> _addNoteKey = GlobalKey<FormState>();
  String filePath = "";
  String fileName = "Choose the pdf file";
  double fileSize = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteGradeTC.text = widget.grade;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    noteTitleTC.dispose();
    noteGradeTC.dispose();
    noteSubjectTC.dispose();
    noteDiscTC.dispose();
  }

  chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        filePath = result.files.single.path!;
        fileSize = result.files.single.size / 1000000;
      });
    } else {
      MSGSnack errMSG = MSGSnack(
          title: "Error!", msg: "No file is choosen.", color: Colors.red);

      errMSG.show();
      // User canceled the picker
    }
  }

  clearData() {
    noteDiscTC.text = "";
    noteGradeTC.text = "";
    noteSubjectTC.text = "";
    noteTitleTC.text = "";
    fileName = "";
    filePath = "";
    fileSize = 0;
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserService());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Add Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/noteapp_txt.png",
                width: 200,
              ),
              Form(
                key: _addNoteKey,
                child: Column(
                  children: [
                    Input(
                        textEditingController: noteTitleTC,
                        hinttxt: "eg: Note 1",
                        title: "Note Title",
                        keyboardType: TextInputType.text),
                    const SizedBox(
                      height: 15,
                    ),
                    Input(
                        textEditingController: noteSubjectTC,
                        hinttxt: "eg: Chemistry",
                        title: "Subject",
                        keyboardType: TextInputType.text),
                    const SizedBox(
                      height: 15,
                    ),
                    Input(
                        textEditingController: noteGradeTC,
                        hinttxt: "eg: 12N",
                        title: "For Grade",
                        keyboardType: TextInputType.text),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Input(
                  textEditingController: noteDiscTC,
                  hinttxt: "",
                  title: "Description (optional)",
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      fileName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(width: 40, child: Text("${fileSize.round()} mb")),
                  const SizedBox(
                    width: 25,
                  ),
                  InkWell(
                    onTap: () {
                      chooseFile();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "choose file",
                          style: TextStyle(color: whiteColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              BTN(
                  text: "Save",
                  action: () async {
                    if (_addNoteKey.currentState!.validate()) {
                      if (filePath.isEmpty) {
                        MSGSnack errMsg = MSGSnack(
                            title: "Error!",
                            msg: "PDF file is not selected.",
                            color: Colors.red);
                        errMsg.show();
                      } else {
                        if (fileName.contains(".pdf")) {
                          await Get.find<UserService>().uploadNoteData(
                              filePath,
                              context,
                              noteTitleTC.text,
                              noteSubjectTC.text,
                              noteGradeTC.text,
                              noteDiscTC.text);
                          clearData();
                        } else {
                          MSGSnack errMsg = MSGSnack(
                              title: "Error!",
                              msg: "The file you selected is not PDF file.",
                              color: Colors.red);
                          errMsg.show();
                        }
                      }
                    }
                  }),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
