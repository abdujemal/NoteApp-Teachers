class MyInfo {
  final String uid, name, subject, classes;

  MyInfo(this.uid, this.name, this.subject, this.classes);

  Map<String, Object?> toFirebaseMap(MyInfo myInfo) {
    return <String, Object>{
      "uid": myInfo.uid,
      "name": myInfo.name,
      "subject": myInfo.subject,
      "classes": myInfo.classes
    };
  }

  MyInfo.fromFirebaseMap(Map<dynamic, dynamic> data)
      : uid = data['uid'].toString(),
        name = data['name'].toString(),
        subject = data['subject'].toString(),
        classes = data['classes'].toString();
}
