class Note {
  String nid, title, subject, grade, description;
  Note(this.nid, this.title, this.subject, this.grade, this.description);

  Map<String, Object> toFirebaseMap(Note note) {
    return <String, Object>{
      "nid": note.nid,
      "title": note.title,
      "subject": note.subject,
      "description": note.description,
      "grade": note.grade
    };
  }

  Note.fromFirebaseMap(Map<dynamic, dynamic> data)
      : nid = data["nid"],
        title = data["title"],
        subject = data["subject"],
        description = data["description"],
        grade = data["grade"];
}
