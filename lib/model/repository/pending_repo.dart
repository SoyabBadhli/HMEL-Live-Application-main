import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lec/view/widgets/loader_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../view/app_data/app_strings.dart';
import '../../controller/providers/pending_provider.dart';
import 'base_repo.dart';

class PendingRepo {

  List dataList = [];

  Future<List?> getPendingApi() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    String? id = prefs.getString('id');
   String? statusfirst = prefs.getString('status');
   String?  accessToken = prefs.getString('accessToken');

    print('-----id----22---$id');
    print('-----id----23---$accessToken');

    showLoader();
    try {
      var headers = {
        'x-api-key': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getAllLecRecord";
      var getAllRecordApi = "$baseURL$endPoint";

      var request = http.Request('POST', Uri.parse('$getAllRecordApi'));
      request.body = json.encode({
        "status": 0,
        "officer_id": id,
        "access_token": accessToken
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------52----${map['status']}');
      var status = "${map['status']}";
      if(status == "false"){
        hideLoader();
      }

      if(response.statusCode == 200)
      {
        hideLoader();
        map['data'].forEach((element) {
          debugPrint("element: $element");
          // store the data into the list after interation
          dataList.add(element);
        });
        // var model = PhotoModel.fromJson(map);
        debugPrint(dataList.toString());
        print('Pending list data ---51---- ${dataList}');
        // return model;
        return dataList;
      } else {
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } on TimeoutException catch (e) {
      hideLoader();
      debugPrint('Timeout Error: $e');
    } on SocketException catch (e) {
      hideLoader();
      debugPrint('Socket Error: $e');
    } on Error catch (e) {
      hideLoader();
      debugPrint('General Error: $e');
    }
  }
}
