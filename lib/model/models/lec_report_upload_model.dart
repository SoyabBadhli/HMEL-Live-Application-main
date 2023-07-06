
class LecReportUploadModel {
  // final int id;
  //final String title
  final String lec_id;
  final String application_id;
  final List lec_report_upload;
  final String lec_remaks;

  const LecReportUploadModel({required this.lec_id, required this.application_id,
    required this.lec_report_upload,required this.lec_remaks,
   });

  factory LecReportUploadModel.fromJson(Map<String,dynamic> json) {
    return LecReportUploadModel(

      lec_id: json['lec_id'] ?? '',
      application_id: json['application_id'] ?? '',
      lec_report_upload: json['lec_report_upload'],
      lec_remaks: json['lec_remaks'] ?? '',
    );
  }
}