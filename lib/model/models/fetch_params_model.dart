// To parse this JSON data, do
//
//     final fetchParamsModel = fetchParamsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FetchParamsModel? fetchParamsModelFromJson(String str) =>
    FetchParamsModel.fromJson(json.decode(str));

String fetchParamsModelToJson(FetchParamsModel? data) =>
    json.encode(data!.toJson());

class FetchParamsModel {
  bool? status;
  String? message;
  List<Datum?>? data;

  FetchParamsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FetchParamsModel.fromJson(Map<String, dynamic> json) =>
      FetchParamsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class Datum {
  String? lecParameterId;
  String? lecId;
  String? applicationId;
  String? earthFilling;
  String? earthRockCutting;
  String? ltOHLine;
  String? ohTelLine;
  String? trees;
  String? proximityToCulvert;
  String? soilType;
  String? availabilityPower;
  String? availabilityWater;
  String? visibilityFromRoad;
  String? noPresenceDivider;
  String? outsideOctroiLimits;
  DateTime? createdAt;
  Datum({
    required this.lecParameterId,
    required this.lecId,
    required this.applicationId,
    required this.earthFilling,
    required this.earthRockCutting,
    required this.ltOHLine,
    required this.ohTelLine,
    required this.trees,
    required this.proximityToCulvert,
    required this.soilType,
    required this.availabilityPower,
    required this.availabilityWater,
    required this.visibilityFromRoad,
    required this.noPresenceDivider,
    required this.outsideOctroiLimits,
    required this.createdAt,
  });
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lecParameterId: json["lec_parameter_id"],
        lecId: json["lec_id"],
        applicationId: json["application_id"],
        earthFilling: json["earth_filling"],
        earthRockCutting: json["earth_rock_cutting"],
        ltOHLine: json["LT_O_H_Line"],
        ohTelLine: json["oh_tel_line"],
        trees: json["trees"],
        proximityToCulvert: json["proximity_to_culvert"],
        soilType: json["soil_type"],
        availabilityPower: json["availability_power"],
        availabilityWater: json["availability_water"],
        visibilityFromRoad: json["visibility_from_Road"],
        noPresenceDivider: json["no_presence_divider"],
        outsideOctroiLimits: json["outside_octroi_limits"],
        createdAt: DateTime.parse(json["created_at"]),
      );
  Map<String, dynamic> toJson() => {
        "lec_parameter_id": lecParameterId,
        "lec_id": lecId,
        "application_id": applicationId,
        "earth_filling": earthFilling,
        "earth_rock_cutting": earthRockCutting,
        "LT_O_H_Line": ltOHLine,
        "oh_tel_line": ohTelLine,
        "trees": trees,
        "proximity_to_culvert": proximityToCulvert,
        "soil_type": soilType,
        "availability_power": availabilityPower,
        "availability_water": availabilityWater,
        "visibility_from_Road": visibilityFromRoad,
        "no_presence_divider": noPresenceDivider,
        "outside_octroi_limits": outsideOctroiLimits,
        "created_at": createdAt?.toIso8601String(),
      };
}
