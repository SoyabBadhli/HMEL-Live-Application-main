import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lec/model/models/fetch_params_model.dart';
import 'package:lec/view/widgets/loader_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_repo.dart';

class ParamsRepo {
  Map? map;
  String? lecid;
  String? appllicationId;
  int? lecid2 = 78912;
  int? appllicationId2 = 96;
  int? lecParameterId;
  String?  accessToken;

  @override
  void initState() {
    print('-------19 initState() call---');
    getlocal();
  }

  void getlocal() async {
    // fetch local data base
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringlecId = prefs.getString('lecid');
    String? stringApplicationid = prefs.getString('applicationid');
     accessToken = prefs.getString('accessToken');
    lecParameterId = prefs.getInt('lecParameterId');
    print('lecid------27--$stringlecId');
    print('applicationId...xxxx----28 $stringApplicationid');
    print('lecParameterID ------xxxx  -29- $lecParameterId');
    print('access token ----------------xxxx  -34- $accessToken');
  }

  Future postParamsApi(

    String lec_id,
    String application_id,
    String accessToken,
    String earth_filling,
    String earth_rock_cutting,
    String LT_O_H_Line,
    String oh_tel_line,
    String trees,
    String proximity_to_culvert,
    String soil_type,
    String availability_power,
    String availability_water,
    String visibility_from_Road,
    String no_presence_divider,
    String outside_octroi_limits,
    String lec_param_id

  ) async {
    try {
      showLoader();
      print(' ------58---lec_id---- $lec_id');
      print(' ------59---application_id---- $application_id');
      print(' ------60---accessToken---- $accessToken');
      print(' ------61---earth_filling---- $earth_filling');
      print(' ------62---earth_rock_cutting---- $earth_rock_cutting');
      print(' ------63---LT_O_H_Line---- $LT_O_H_Line');
      print(' ------64---oh_tel_line---- $oh_tel_line');
      print(' ------65---trees---- $trees');
      print(' ------66---proximity_to_culvert---- $proximity_to_culvert');
      print(' ------67---soil_type---- $soil_type');
      print(' ------68---availability_power---- $availability_power');
      print(' ------69---availability_water---- $availability_water');
      print(' ------70---visibility_from_Road---- $visibility_from_Road');
      print(' ------71---no_presence_divider---- $no_presence_divider');
      print(' ------72---outside_octroi_limits---- $outside_octroi_limits');
      print(' ------73---lec_param_id---- $lec_param_id');

      var headers = {
        'X-API-KEY': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/LECParameters";
      var lecParameterApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$lecParameterApi'));
      request.body = json.encode({
        "lec_id": lec_id,
        "application_id": application_id,
        "earth_filling": earth_filling,
        "earth_rock_cutting": earth_rock_cutting,
        "LT_O_H_Line": LT_O_H_Line,
        "oh_tel_line": oh_tel_line,
        "trees": trees,
        "proximity_to_culvert": proximity_to_culvert,
        "soil_type": soil_type,
        "availability_power": availability_power,
        "availability_water": availability_water,
        "visibility_from_Road": visibility_from_Road,
        "no_presence_divider": no_presence_divider,
        "outside_octroi_limits": outside_octroi_limits,
        "lec_parameter_id": lec_param_id,
        "access_token": accessToken
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------179----$map');

      if (response.statusCode == 200) {
        hideLoader();
        print('------------108-----${response.statusCode}');
        var data = await response.stream.bytesToString();
        print('-----------------110------>$data');
        map = json.decode(data);
        print('----------------112---------$map');
        print(map);
        print('Inserted data---109--${map}');
        return map;
      } else {
        hideLoader();
        print('------------112-----${response.statusCode}');
        debugPrint(response.reasonPhrase);
        return map;
      }
    } on TimeoutException catch (e) {
      hideLoader();
      debugPrint('Timeout Error: $e');
    } on SocketException catch (e) {
      debugPrint('Socket Error: $e');
      hideLoader();
    } on Error catch (e) {
      debugPrint('General Error: $e');
      hideLoader();
    }
    // catch (e) {
    //   debugPrint("exception: $e");
    //   // throw (e);
    // }
  }


  ///Fetch Params getLecParameter api
  ///
  Future fetchParamsApi(String lec_id, String application_id, String accessToken) async {
    try {
      showLoader();
      var headers = {
        'X-API-KEY': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getLECParameters";
      var getlecParameterApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$getlecParameterApi'));
      request.body = json.encode({
        "lec_id": lec_id,
        "application_id": application_id,
        "access_token":accessToken
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //
        hideLoader();
        print('---------------156---getParameter----${response.statusCode}');
        var data = await response.stream.bytesToString();
        debugPrint("data: $data");
        print('----------xx---------159------$data');



        var fpmap = json.decode(data);
        print('---------------164---getParameter----$fpmap');
        debugPrint("fpmap: $fpmap");
        return fpmap;

      } else {
        debugPrint(response.reasonPhrase);
        hideLoader();
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
      hideLoader();
    } on SocketException catch (e) {
      debugPrint('Socket Error: $e');
      hideLoader();
    } on Error catch (e) {
      debugPrint('General Error: $e');
      hideLoader();
    }
    // catch (e) {
    //   debugPrint("exception: $e");
    //   // throw (e);
    // }
  }




  ///Update Params
  Future updateParamsApi(
      String lec_id,
      String application_id,
      String earth_filling,
      String earth_rock_cutting,
      String LT_O_H_Line,
      String oh_tel_line,
      String trees,
      String proximity_to_culvert,
      String soil_type,
      String availability_power,
      String availability_water,
      String visibility_from_Road,
      String no_presence_divider,
      String outside_octroi_limits,
      String lec_parameter_id,
      ) async {
    String baseUrl;

    try {
      print(' ------207---lec_id---- $lec_id');
      print(' ------208---application_id---- $application_id');
      print(' ------209---earth_filling---- $earth_filling');
      print(' ------210---earth_rock_cutting---- $earth_rock_cutting');
      print(' ------211---LT_O_H_Line---- $LT_O_H_Line');
      print(' ------212---oh_tel_line---- $oh_tel_line');
      print(' ------213---trees---- $trees');
      print(' ------214---proximity_to_culvert---- $proximity_to_culvert');
      print(' ------215---soil_type---- $soil_type');
      print(' ------216---availability_power---- $availability_power');
      print(' ------217---availability_water---- $availability_water');
      print(' ------218---visibility_from_Road---- $visibility_from_Road');
      print(' ------219---no_presence_divider---- $no_presence_divider');
      print(' ------220---outside_octroi_limits---- $outside_octroi_limits');
      print(' ------221---lec_param_id---- $lec_parameter_id');

      showLoader();



      //here lecId and Application id is a static
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/LECParameters";
      var lecParameterApi = "$baseURL$endPoint";

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('$lecParameterApi'));
      request.body = json.encode({
        "lec_id": lec_id,
        "application_id": application_id,
        "earth_filling": earth_filling,
        "earth_rock_cutting": earth_rock_cutting,
        "LT_O_H_Line": LT_O_H_Line,
        "oh_tel_line": oh_tel_line,
        "trees": trees,
        "proximity_to_culvert": proximity_to_culvert,
        "soil_type": soil_type,
        "availability_power": availability_power,
        "availability_water": availability_water,
        "visibility_from_Road": visibility_from_Road,
        "no_presence_divider": no_presence_divider,
        "outside_octroi_limits": outside_octroi_limits,
        "lec_parameter_id": lec_parameter_id,
        "access_token": accessToken
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------253----$map');


      if (response.statusCode == 200) {
        hideLoader();
        print('------------242-----${response.statusCode}');
        var data = await response.stream.bytesToString();
        debugPrint("data ---------241-----: $data");
        map = json.decode(data);
        print('--------243-------data---$data');

        // var model = PhotoModel.fromJson(map);
        // return model;
       // print(map);
        return map;
      } else {
        hideLoader();
        debugPrint(response.reasonPhrase);
        print('173 updated response---$response.reasonPhrase');
        return map;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
      hideLoader();
    } on SocketException catch (e) {
      debugPrint('Socket Error: $e');
      hideLoader();
    } on Error catch (e) {
      debugPrint('General Error: $e');
    }
  }
}
