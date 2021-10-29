import 'package:http/http.dart';
import 'package:inventory_mind/others/token_role_preferences.dart';
import 'dart:convert';

Future<Map> getReq(Client client, String url) async {
  Response response = await client.get(Uri.parse(url),
      headers: {"cookie": "auth-token=" + TokenRolePreferences.getToken()});
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load the Dashboard");
  }
}

// Future<Map> postReturn(Client client, String url) async {
//   Response response = await client.post(Uri.parse(url),
//       headers: {"cookie": "auth-token=" + TokenRolePreferences.getToken()});
//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception("Loading Failed");
//   }
// }

Future<Map> postReqWithBody(Client client, String url, Map body) async {
  Response response = await client.post(
    Uri.parse(url),
    headers: {"cookie": "auth-token=" + TokenRolePreferences.getToken()},
    body: body,
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Loading Failed");
  }
}