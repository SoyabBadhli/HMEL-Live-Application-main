import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_repo.dart';

class ReportDowwnlodeRepo
{
  List dataList = [];
  // get a token
  Future getReportDownldoeParameter(String lecid, String applicationid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Read data
      String? id = prefs.getString('id');
      String? statusfirst = prefs.getString('status');
      String?  accessToken = prefs.getString('accessToken');

      print('-----id----498---$id');
      print('-----status----499---$statusfirst');
      print('-----accessToken----500---$accessToken');

      var headers = {
        'Content-Type': 'application/json',
        'x-api-key': '123456',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getLECdoc";
      var getlecDocApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$getlecDocApi'));
      request.body = json.encode({
        "lec_id": lecid,
        "application_id": applicationid,
        "access_token": accessToken
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);

      // print('------10--lecId-------$lecid');
      // print('------11--applicationid-------$applicationid');
      // var headers = {'Content-Type': 'application/json'};
      // var request =
      // http.Request('POST', Uri.parse('http://49.50.107.91/hmel/api/getLECdoc'));
      // request.body = json.encode({"lec_id": lecid, "application_id": applicationid});
      // request.headers.addAll(headers);
      // http.StreamedResponse response = await request.send();
      // var map;
      // var data = await response.stream.bytesToString();
      // map = json.decode(data);


      if(response.statusCode == 200)
      {
        print('Status code------20--${response.statusCode}');

        map['data'].forEach((element) {
          debugPrint("element: $element");
          // store the data into the list after interation
          dataList.add(element);
        });
        // var model = PhotoModel.fromJson(map);
        debugPrint(dataList.toString());
        print('-------30--- ${dataList}');
        // return model;
        return dataList;
      } else {
        print('Status code------20--${response.statusCode}');
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      debugPrint("exception: $e");
      throw e;
    }
  }
}
