import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DocumentDownlodeTestApi
{
  Future documentUplodeTesting(BuildContext context, String lecid, String applicationid) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
      http.Request('POST', Uri.parse('https://dealerselection.hmel.in/api/getLECdoc'));
      request.body = json.encode({"lec_id": lecid, "application_id": applicationid});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      if(response.statusCode == 200)
      {
        print("map: $map");
        return map;
      } else {
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      debugPrint("exception: $e");
      throw e;
    }
  }
}
