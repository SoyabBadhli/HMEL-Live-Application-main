/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../view/screens/report_upload.dart';
import '../models/modelclass.dart';


Future<Album> createAlbum(String lec_id, String application_id,
      List lec_documents,
      double lec_doc_latitude, double lec_doc_longitude) async {
    final response = await http.post(
      Uri.parse('http://49.50.107.91/hmel/api/LECVisitDocuments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'lec_id': lec_id,
        'application_id': application_id,
        'lec_documents': lec_documents.toList(),
        'lec_doc_latitude': lec_doc_latitude,
        'lec_doc_longitude': lec_doc_longitude,
      }),
    );
    if (response.statusCode == 200) {
      print('Response body ---23--${response.body}');

      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print('Response code---${response.statusCode}');
      print('xxxxx---24--response...success..');
      // insert data into model class
      return Album.fromJson(jsonDecode(response.body));
      // jump next scren

      */
/* Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => ReportUpload(
          lId: widget.lId,
          lName: widget.lName,
          vDate: widget.vDate,
          applicantId: widget.applicantId,
          applicantname: widget.applicantname,
          mobile_no: widget.mobile_no,
          email_id: widget.email_id,
          type: widget.type,
        )),
      ),
    );*//*


    } else {
      print('xxxxx---24--response...failed..');
      print('Response code---${response.statusCode}');
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create table.');
    }
  }





*/
