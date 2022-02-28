class Student {
  String grade, name, uid;
  Student(this.uid, this.name, this.grade);

  Student.fromFireBaseMap(Map<dynamic, dynamic> data)
      : name = data["name"],
        grade = data["grade"],
        uid = data["uid"];

  Map<String, Object> toFirebaseMap(Student student) {
    return <String, Object>{
      "name": student.name,
      "grade": student.grade,
      "uid": student.uid
    };
  }
}
