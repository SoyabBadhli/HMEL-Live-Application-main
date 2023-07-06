import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'base_repo.dart';

class GetLecParameter
{
  Future getLecParameter(BuildContext context,String lecid,String applicationid) async {
    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getLECParameters";
      var getlecParameterApi = "$baseURL$endPoint";
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$getlecParameterApi'));
      request.body = json.encode({"lecid": lecid, "applicationid": applicationid});
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
