import 'package:flutter/cupertino.dart';

class ReportUploadProvider with ChangeNotifier {
  String? splitedSelected;

  String? getSplitedSelected() {
    return splitedSelected;
  }

  void setSplitedSelected(String value) {
    splitedSelected = value;
    notifyListeners();
  }
}
