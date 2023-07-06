import 'package:flutter/cupertino.dart';
import '../../model/repository/login_repo.dart';

class LoginProvider with ChangeNotifier {

  bool isLoaded = false;
  bool isUsernameEmpty = true;
  bool isPasswordEmpty = true;
  String? email, password;
  bool isPasswordVisible = false;
  bool loginStatus = false;

  Future<void> authenticateUser(BuildContext context, String email, String pass) async {
    Map map = await LoginRepo().authenticate(context, email, pass);
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

  ///Username
  String? getEmail() {
    return email;
  }

  void setEmail(String value) {
    email = value;
    isUsernameEmpty = false;
    notifyListeners();
  }

  ///Password
  String? getPassword() {
    return password;
  }

  void setPassword(String value) {
    password = value;
    isPasswordEmpty = false;
    notifyListeners();
  }

  bool getPasswordVisible() {
    return isPasswordVisible;
  }

  void setPasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
}
