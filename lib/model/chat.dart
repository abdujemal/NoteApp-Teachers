class Chat {
  String text, date, time, from, to, cid;
  Chat(this.text, this.date, this.time, this.from, this.to, this.cid);
  Chat.fromFirebaseMap(Map<dynamic, dynamic> data)
      : cid = data["cid"],
        text = data["text"],
        date = data["date"],
        time = data["time"],
        from = data["from"],
        to = data["to"];
  Map<String, Object> toFirebaseMap(Chat chat){
    return <String,Object>{
      "text": chat.text,
      "date": chat.date,
      "time": chat.time,
      "from": chat.from,
      "to": chat.to,
      "cid": chat.cid
    };
  }
}
