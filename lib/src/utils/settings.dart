import 'dart:convert';

import 'package:http/http.dart' as http;

/// Define App ID and Token
const APP_ID = "44d932b5196d43b9b09b5168a55564f9";

Future<String> getToken(String channelName) async {
  String url =
      "https://morning-depths-23050.herokuapp.com/access_token?channelName=${channelName}";
  String responseBody = "";
  try {
    http.Response response = await http.get(Uri.parse(url));
    responseBody = response.body;
  } catch (e) {
    print(e);
  }
  return json.decode(responseBody)["token"];
}
