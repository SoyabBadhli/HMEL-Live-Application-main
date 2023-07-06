
class UplodeDocTestingModel {
  // final int id;
  //final String title
  final String lec_id;
  final String application_id;

  const UplodeDocTestingModel({required this.lec_id, required this.application_id});

  factory UplodeDocTestingModel.fromJson(Map<String,dynamic> json) {
    return UplodeDocTestingModel(
      lec_id: json['lec_id'] == null ? '' : json['lec_id'],
      application_id: json['application_id'] == null ? '' : json['application_id'],
     );
  }
}