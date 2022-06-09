class LiveChat {
  String img_url, userName, text, cid;
  LiveChat(this.img_url, this.userName, this.text, this.cid);

  toFirebaseMap(LiveChat liveChat) {
    return {
      "img_url": liveChat.img_url,
      "userName": liveChat.userName,
      "text": liveChat.text,
      "cid": liveChat.cid
    };
  }

  LiveChat.fromFirebase(Map<dynamic, dynamic> data)
      : img_url = data["img_url"],
        userName = data["userName"],
        text = data["text"],
        cid = data["cid"];
}
