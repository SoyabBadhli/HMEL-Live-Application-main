// To parse this JSON data, do
//
//     final pendingModel = pendingModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PendingModel? pendingModelFromJson(String str) =>
    PendingModel.fromJson(json.decode(str));

String pendingModelToJson(PendingModel? data) => json.encode(data!.toJson());

class PendingModel {
  PendingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool? status;
  String? message;
  List<Datum?>? data;

  factory PendingModel.fromJson(Map<String, dynamic> json) => PendingModel(
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
  Datum({
    required this.lecId,
    required this.lecVisitDate,
    required this.applicantId,
    required this.applicationId,
    required this.locationId,
    required this.locationName,
    required this.applicantName,
    required this.mobileNo,
    required this.emailId,
    required this.applicationRefNo,
    required this.applicationType,
  });

  String? lecId;
  DateTime? lecVisitDate;
  String? applicantId;
  String? applicationId;
  String? locationId;
  String? locationName;
  String? applicantName;
  String? mobileNo;
  String? emailId;
  String? applicationRefNo;
  String? applicationType;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lecId: json["lec_id"],
        lecVisitDate: DateTime.parse(json["lec_visit_date"]),
        applicantId: json["applicant_id"],
        applicationId: json["application_id"],
        locationId: json["location_id"],
        locationName: json["location_name"],
        applicantName: json["applicant_name"],
        mobileNo: json["mobile_no"],
        emailId: json["email_id"],
        applicationRefNo: json["application_ref_no"],
        applicationType: json["application_type"],
      );

  Map<String, dynamic> toJson() => {
        "lec_id": lecId,
        "lec_visit_date":
            "${lecVisitDate!.year.toString().padLeft(4, '0')}-${lecVisitDate!.month.toString().padLeft(2, '0')}-${lecVisitDate!.day.toString().padLeft(2, '0')}",
        "applicant_id": applicantId,
        "application_id": applicationId,
        "location_id": locationId,
        "location_name": locationName,
        "applicant_name": applicantName,
        "mobile_no": mobileNo,
        "email_id": emailId,
        "application_ref_no": applicationRefNo,
        "application_type": applicationType,
      };
}
