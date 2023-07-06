import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lec/view/widgets/loader_services.dart';

import 'base_repo.dart';

class LoginRepo {

  Future authenticate(BuildContext context, String email, String pass) async {

    try {

      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/login";
      var loginApi = "$baseURL$endPoint";

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '$loginApi')); //  http://49.50.107.91/hmel/api/login //  https://49.50.77.135/api/login
      request.body = json.encode({"email": email, "password": pass});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---LOGINaPI RESPONSE----$map');
      if (response.statusCode == 200) {
        hideLoader();
        print("map: $map");
        print("map1: $map");

        print('----------22-----$map');
        return map;
      } else {
        print('----------29---LOGINaPI RESPONSE----$map');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }
}
