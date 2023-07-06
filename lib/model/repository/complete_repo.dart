import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lec/model/repository/base_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../view/app_data/app_strings.dart';
import '../../controller/providers/pending_provider.dart';
import '../../view/widgets/loader_services.dart';

class CompleRepo {

  List dataList = [];
  String? statusfirst;
  String? accessToken;

  Future<List?> getCompleApi() async {
    // loder star
    showLoader();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    String? id = prefs.getString('id');
    statusfirst = prefs.getString('status');
    accessToken = prefs.getString('accessToken');

    print('-----id----22---$id');
    print('-----status----23---$statusfirst');
    print('-----accessToken----24---$accessToken');

    print('-----id----20---$id');


    try {
      var headers = {
        'x-api-key': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
       var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getAllLecRecord";
      var getallRecordApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$getallRecordApi'));
      request.body = json.encode({
        "status": 1,
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
      print(status);

      if(response.statusCode == 200)
      {
        hideLoader();
        // loder closer
        map['data'].forEach((element) {
          debugPrint("element: $element");
          // store the data into the list after interation
          dataList.add(element);
        });
        // var model = PhotoModel.fromJson(map);
        debugPrint(dataList.toString());
        print('Pending list data ---31 ${dataList}');
        // return model;
        return dataList;
      } else {
        print('----------69----$map');
        print(response.reasonPhrase);
        return map;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
    } on SocketException catch (e) {
      debugPrint('Socket Error: $e');
    } on Error catch (e) {
      debugPrint('General Error: $e');
    }
  }
}
