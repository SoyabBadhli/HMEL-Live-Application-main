class ForgotPassWordModel {
  final int id;
  final String title;

  const ForgotPassWordModel({required this.id, required this.title});

  factory ForgotPassWordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPassWordModel(
      id: json['id'],
      title: json['title'],
    );
  }
}