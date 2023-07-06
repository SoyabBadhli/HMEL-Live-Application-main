import 'package:flutter/cupertino.dart';
import '../../model/repository/document_uplode_test_repo.dart';
import '../../model/repository/login_repo.dart';

class DocumentUplodeTestingProvider with ChangeNotifier {
  bool isLoaded = false;
  bool isUsernameEmpty = true;
  bool isPasswordEmpty = true;
  String? email, password;
  bool isPasswordVisible = false;
  bool loginStatus = false;

  Future<void> documentUplodeTesting(
      BuildContext context, String lecid, String applicationid) async {
    Map map = await DocumentDownlodeTestApi().documentUplodeTesting(context, lecid, applicationid);
    print("map['status']: ${map['status']}");
    loginStatus = map['status'];
    notifyListeners();
  }

  void setLoginStatus(bool value) {
    loginStatus = value;
    notifyListeners();
  }
  ///isLoaded
  bool getIsLoaded() {
    return isLoaded;
  }
  void setIsLoaded(bool value) {
    isLoaded = value;
    notifyListeners();
  }
}
