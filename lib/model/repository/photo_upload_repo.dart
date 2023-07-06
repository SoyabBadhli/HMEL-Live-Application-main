import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'base_repo.dart';

class PhotoUploadRepo {
  List dataList = [];
  Future<List?> getPendingApi() async {
    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/LECVisitDocuments";
      var lecVisitDocumentsApi = "$baseURL$endPoint";
      var headers = {'Authorization': 'Basic YWRtaW46MTIzNA=='};
      var request = http.MultipartRequest(
          'POST', Uri.parse('$lecVisitDocumentsApi'));
      request.fields.addAll({
        'lec_id': '78912',
        'application_id': '54',
        'lec_doc_latitude': '3254653423',
        'lec_doc_longitude': '34256754',
        'lec_document_id': ''
      });
      request.files.add(
          await http.MultipartFile.fromPath('lec_documents', '/path/to/file'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      // if (response.statusCode == 200) {
      //   print(await response.stream.bytesToString());
      // } else {
      //   print(response.reasonPhrase);
      // }

      // var request = http.Request(
      //   'GET',
      //   Uri.parse('http://49.50.107.91/hmel/api/lecRecord/0'),
      // );
      // http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        debugPrint("dataList: $dataList");
        var data = await response.stream.bytesToString();
        debugPrint("data : $data");
        var map = json.decode(data);
        // Iterate the data
        map['data'].forEach((element) {
          debugPrint("element: $element");
          // store the data into the list after interation
          dataList.add(element);
        });
        // var model = PhotoModel.fromJson(map);
        debugPrint(dataList.toString());
        print('Pending list data ${dataList}');
        // return model;
        return dataList;
      } else {
        debugPrint(response.reasonPhrase);
        return dataList;
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

// var headers = {
//   'Authorization': 'Basic YWRtaW46MTIzNA=='
// };
// var request = http.MultipartRequest('POST', Uri.parse('http://49.50.107.91/hmel/api/LECVisitDocuments'));
// request.fields.addAll({
//   'lec_id': '78912',
//   'application_id': '54',
//   'lec_doc_latitude': '3254653423',
//   'lec_doc_longitude': '34256754',
//   'lec_document_id': ''
// });
// request.files.add(await http.MultipartFile.fromPath('lec_documents', '/path/to/file'));
// request.headers.addAll(headers);

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }
