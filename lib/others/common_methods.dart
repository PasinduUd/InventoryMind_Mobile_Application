import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:inventory_mind/others/token_role_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:inventory_mind/widgets/widget_methods.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<Map> getReq(BuildContext context, Client client, String url) async {
  Response response = await client.get(Uri.parse(url),
      headers: {"cookie": "auth-token=" + TokenRolePreferences.getToken()});
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    alertDialogBox(
      context,
      AlertType.error,
      "Something Went Wrong!",
      "Please check your internet connection and try again.",
    ).show();
    throw Exception("Loading Failed");
  }
}

Future<Map> postReqWithoutBody(Client client, String url) async {
  Response response = await client.post(
    Uri.parse(url),
    headers: {"cookie": "auth-token=" + TokenRolePreferences.getToken()},
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    Fluttertoast.showToast(
      msg: "Something Went Wrong! Please Try Again",
      gravity: ToastGravity.BOTTOM,
    );
    throw Exception("Loading Failed");
  }
}

Future<Map> postReqWithBody(Client client, String url, Map body) async {
  Response response = await client.post(
    Uri.parse(url),
    headers: {"cookie": "auth-token=" + TokenRolePreferences.getToken()},
    body: body,
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    Fluttertoast.showToast(
      msg: "Something Went Wrong! Please Try Again",
      gravity: ToastGravity.BOTTOM,
    );
    throw Exception("Loading Failed");
  }
}

Future<Map> postReqWithEncodedBody(Client client, String url, Map body) async {
  Response response = await client.post(
    Uri.parse(url),
    headers: {
      "cookie": "auth-token=" + TokenRolePreferences.getToken(),
      "Content-Type": "application/json;charset=UTF-8",
      "Charset": "utf-8",
    },
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    Fluttertoast.showToast(
      msg: "Something Went Wrong! Please Try Again",
      gravity: ToastGravity.BOTTOM,
    );
    throw Exception("Loading Failed");
  }
}

Future<Map> postReqWithoutToken(Client client, String url, Map body) async {
  Response response = await client.post(Uri.parse(url), body: body);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    Fluttertoast.showToast(
      msg: "Something Went Wrong! Please Try Again",
      gravity: ToastGravity.BOTTOM,
    );
    throw Exception("Loading Failed");
  }
}
