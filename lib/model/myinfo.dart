class MyInfo {
  final String uid, name, subject, classes, img_url;

  MyInfo(this.uid, this.name, this.subject, this.classes, this.img_url);

  Map<String, Object?> toFirebaseMap(MyInfo myInfo) {
    return <String, Object>{
      "uid": myInfo.uid,
      "name": myInfo.name,
      "subject": myInfo.subject,
      "classes": myInfo.classes,
      "img_url": myInfo.img_url
    };
  }

  MyInfo.fromFirebaseMap(Map<dynamic, dynamic> data)
      : uid = data['uid'].toString(),
        name = data['name'].toString(),
        subject = data['subject'].toString(),
        classes = data['classes'].toString(),
        img_url = data["img_url"].toString();
}
