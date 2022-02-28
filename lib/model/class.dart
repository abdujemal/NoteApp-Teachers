class Class {
  String grade, numOfStudent;
  Class({required this.grade, required this.numOfStudent});

  Map<String, Object> toFirebaseMap(Class classs) {
    return {"grade": classs.grade, "numOfStudent": classs.numOfStudent};
  }

  Class.fromFirebaseMap(Map<dynamic, dynamic> data)
      : grade = data["grade"],
        numOfStudent = data["numOfStudent"];
}
