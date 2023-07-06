
class Album {
 // final int id;
  //final String title
  final String lec_id;
  final String application_id;
  final List lec_documents;
  final String lec_doc_latitude;
  final String lec_doc_longitude;

  const Album({required this.lec_id, required this.application_id,
  required this.lec_documents,required this.lec_doc_latitude,
  required this.lec_doc_longitude});

  factory Album.fromJson(Map<String,dynamic> json) {
    return Album(

      lec_id: json['lec_id'] == null ? '' : json['lec_id'],
      application_id: json['application_id'] == null ? '' : json['application_id'],
      lec_documents: json['lec_documents'],
      lec_doc_latitude: json['lec_doc_latitude']== null ? '' : json['lec_doc_latitude'],
      lec_doc_longitude: json['lec_doc_longitude']== null ? '' : json['lec_doc_longitude'],
    );
  }
}