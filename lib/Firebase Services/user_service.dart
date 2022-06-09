import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:note_app_teachers/Firebase%20Services/send_notification.dart';
import 'package:note_app_teachers/comp/msg_snack.dart';
import 'package:note_app_teachers/model/myinfo.dart';
import 'package:note_app_teachers/model/note.dart';
import 'package:note_app_teachers/pages/RegisterationPage/comp/more_info_sheet.dart';
import 'package:note_app_teachers/pages/RegisterationPage/controller/signuplogin_controller.dart';
import 'package:note_app_teachers/pages/RegisterationPage/registration_page.dart';
import 'package:note_app_teachers/pages/main/controller/tabs_controller.dart';
import 'package:note_app_teachers/pages/main/drawer/controller/drawer_controller.dart';
import 'package:note_app_teachers/pages/main/main_page.dart';
import 'package:note_app_teachers/pages/note_viewer/controller/pdf_viewer_controller.dart';
import 'package:path_provider/path_provider.dart';

class UserService extends GetxService {
  SLController slcontroller = Get.put(SLController());

  DController dController = Get.put(DController());

  PVController pvController = Get.put(PVController());

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseDatabase datebase = FirebaseDatabase.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> downloadPDF(String nid) async {
    pvController.setIsDownloading(true);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/${nid}.pdf');

    try {
      await storage.ref('Notes/${nid}').writeToFile(downloadToFile);

      pvController.setIsDownloading(false);

      pvController.setController(PdfControllerPinch(
          initialPage: 1,
          document: PdfDocument.openFile("${appDocDir.path}/${nid}.pdf")));

      pvController.setFilePath("${appDocDir.path}/${nid}.pdf");
    } catch (e) {
      pvController.setIsDownloading(false);

      MSGSnack errorMsg =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errorMsg.show();
    }
  }

  uploadNoteData(String filePath, BuildContext context, String title,
      String subject, String grade, String description) async {
    slcontroller.setIsLoading(true);

    DatabaseReference noteRef = datebase.ref().child("Notes").push();

    Note note = Note(noteRef.key!, title, subject, grade, description);
    Map<String, Object> data = note.toFirebaseMap(note);

    try {
      await noteRef.update(data);

      SendNotification sendNotification = SendNotification(
          title: subject, body: "${title} is uploaded.", topic: "11S");
      sendNotification.send();

      uploadNotePDF(filePath, noteRef.key!, context);
    } catch (e) {
      slcontroller.setIsLoading(false);

      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  uploadNotePDF(String filePath, String id, BuildContext context) async {
    File file = File(filePath);

    try {
      await storage.ref('Notes/${id}').putFile(file);

      slcontroller.setIsLoading(false);

      MSGSnack successMsg = MSGSnack(
          title: "Success!",
          msg: "You have successfully uploaded.",
          color: Colors.green);
      successMsg.show();
    } catch (e) {
      slcontroller.setIsLoading(false);

      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  getUserInfo() async {
    try {
      DatabaseEvent event = await datebase
          .ref()
          .child("Teachers")
          .child(auth.currentUser!.uid)
          .once();

      if (event.snapshot.exists) {
        var datas = event.snapshot.value as Map<dynamic, dynamic>;

        print(datas["name"]);
        dController.setMyInfo(MyInfo.fromFirebaseMap(datas));

        // return MyInfo(datas![""], "name", "subject", "classes");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  saveUserInfo(String name, String subject, String classes,
      BuildContext context, File file) async {
    try {
      slcontroller.setIsLoading(true);

      TaskSnapshot taskSnapshot =
          await storage.ref("Teachers/${auth.currentUser!.uid}").putFile(file);

      String img_url = await taskSnapshot.ref.getDownloadURL();

      MyInfo myInfo =
          MyInfo(auth.currentUser!.uid, name, subject, classes, img_url);
      Map<String, Object?> mydata = myInfo.toFirebaseMap(myInfo);

      await datebase
          .ref()
          .child("Teachers")
          .child(auth.currentUser!.uid)
          .update(mydata);

      slcontroller.setIsLoading(false);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    } catch (e) {
      slcontroller.setIsLoading(false);

      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  startLive(String title) async {
    try {
      TabsController tabsController = Get.put(TabsController());

      tabsController.setIsLoading(true);

      await datebase.ref().child("LiveStream").child(dController.myInfo.value.uid).update({
        "title": title,
        "numOfUser": "0",
        "lid": dController.myInfo.value.uid,
        "tid": auth.currentUser!.uid,
        "t_name": dController.myInfo.value.name,
        "t_img": dController.myInfo.value.img_url
      });

      

      tabsController.setIsLoading(false);
    } catch (e) {
      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  stopLive(String channelName) async {
    try {
      await datebase.ref().child("LiveStream").child(channelName).remove();
      await datebase.ref().child("LiveStreamChat").child(channelName).remove();
    } catch (e) {
      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  

  saveUserInfoFromDrawer(String name, String subject, String classes,
      BuildContext context, File? file) async {
    try {
      dController.setIsLoading(true);

      Map<String, Object?> mydata;

      if (file == null) {
        MyInfo myInfo = MyInfo(auth.currentUser!.uid, name, subject, classes,
            dController.myInfo.value.img_url);
        mydata = myInfo.toFirebaseMap(myInfo);
      } else {
        TaskSnapshot taskSnapshot = await storage
            .ref("Teachers/${auth.currentUser!.uid}")
            .putFile(file);

        String img_url = await taskSnapshot.ref.getDownloadURL();

        MyInfo myInfo =
            MyInfo(auth.currentUser!.uid, name, subject, classes, img_url);
        mydata = myInfo.toFirebaseMap(myInfo);
      }

      await datebase
          .ref()
          .child("Teachers")
          .child(auth.currentUser!.uid)
          .update(mydata);

      dController.setIsLoading(false);

      getUserInfo();
    } catch (e) {
      dController.setIsLoading(false);

      MSGSnack errMSG =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);

      errMSG.show();
    }
  }

  Future<bool?> doesUserExist() async {
    try {
      final event = await datebase
          .ref()
          .child("Teachers")
          .child(auth.currentUser!.uid)
          .once();

      if (event.snapshot.exists) return true;
      return false;
    } catch (e) {
      MSGSnack errorMsg =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);
      return null;
    }
  }

  logInWEmailNPW(String email, String password, BuildContext context) async {
    try {
      slcontroller.setIsLoading(true);
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) async {
        await checkUser(context);
        slcontroller.setIsLoading(false);
      });
    } catch (e) {
      slcontroller.setIsLoading(false);
      MSGSnack errorMSG =
          MSGSnack(color: Colors.red, title: "Error!", msg: e.toString());
      errorMSG.show();
    }
  }

  checkUser(context) async {
    final doesuserExist = await doesUserExist();
    if (doesuserExist == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationPage()),
          (route) => false);
    } else {
      if (doesuserExist) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false);
      } else {
        Get.bottomSheet(const MoreInfo(), isDismissible: false);
      }
    }
  }

  signUpWEmailNPW(String email, String password, BuildContext context) async {
    try {
      slcontroller.setIsLoading(true);

      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) async {
        await checkUser(context);
        slcontroller.setIsLoading(false);
      });
    } catch (e) {
      slcontroller.setIsLoading(false);
      MSGSnack errorMSG =
          MSGSnack(color: Colors.red, title: "Error!", msg: e.toString());
      errorMSG.show();
    }
  }

  signInWGoogleAccount() {}

  forgetPassword(String email, BuildContext context) async {
    try {
      slcontroller.setIsLoading(true);
      await auth.sendPasswordResetEmail(email: email);

      MSGSnack successMSG = MSGSnack(
          title: "Success!",
          msg: "We successfully sent you an email.",
          color: Colors.green);
      successMSG.show();

      slcontroller.setIsLoading(false);
    } catch (e) {
      slcontroller.setIsLoading(false);

      MSGSnack errorMSG =
          MSGSnack(color: Colors.red, title: "Error!", msg: e.toString());
      errorMSG.show();
    }
  }
}
