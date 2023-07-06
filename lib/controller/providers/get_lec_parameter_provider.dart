import 'package:flutter/cupertino.dart';
import '../../model/repository/get_lec_parameters_repo.dart';

class GetLecParametersProvider with ChangeNotifier {

  bool isLoaded = false;
  String? lecId,applicationId;
  bool loginStatus = false;

  Future<void> getLecParameters(BuildContext context, String lecId,String applicationId) async {
    Map map = await GetLecParameter().getLecParameter(context,lecId, applicationId);
    print("map['status']: ${map['status']}");
   // loginStatus = map['status'];
    loginStatus = map['data'];
    notifyListeners();
  }

  String? getLecId() {
    return lecId;
  }

  void setLecId(String value) {
    lecId = value;
    notifyListeners();
  }
  String? getApplicationId() {
    return applicationId;
  }

  void setApplicationId(String value) {
    applicationId = value;
    notifyListeners();
  }

}
