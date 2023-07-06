import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lec/controller/providers/login_provider.dart';
import 'package:lec/model/repository/login_repo.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/widgets/custom_buttom.dart';
import 'package:path/src/context.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_data/app_colors.dart';
import '../app_data/app_strings.dart';
import '../app_data/app_text_style.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
  get(Context context) {}
}
class _LoginState extends State<Login> {
  double? _height;
  double? _width;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginProvider? loginProvider;
  // String? userName, password;
  bool value = false;
  bool loginLoading = false;
  Icon? visibleIcon;
  final FocusNode unameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        content: new Text('Do you want to exit app',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
            //  goToHomePage();
              // exit the app
              exit(0);
            }, //Navigator.of(context).pop(true), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  goToHomePage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PendComp()),
    );
  }
  // loader  code

  void configLoading() {
    EasyLoading.instance

      ..displayDuration = const Duration(milliseconds: 2000)

      ..indicatorType = EasyLoadingIndicatorType.fadingCircle

      ..loadingStyle = EasyLoadingStyle.custom

      ..indicatorSize = 45.0

      ..radius = 10.0

      ..progressColor = Colors.white

      ..backgroundColor = Colors.black

      ..indicatorColor = Colors.white

      ..textColor = Colors.white

      ..maskColor = Colors.blue.withOpacity(0.5)

      ..userInteractions = false

      ..dismissOnTap = false;

  }


  @override
  void initState() {
    // isVisible = true;
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    visibleIcon = loginProvider!.isPasswordVisible == true
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off);
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      requestLocationPermission();

      setState(() {
        // Here you can write your code for open new view
      });

    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }
  // CAMERA PERMISSION
  Future<void> requestCameraPermission() async {

    final status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }
  // location Permission
  Future<void> requestLocationPermission() async {

    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }


  @override
  void dispose() {
    getloginInfoToLocalDataBase();
    // TODO: implement dispose
    super.dispose();
  }
  getloginInfoToLocalDataBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginEmail = prefs.getString('loginEmail');
    //Remove String
    prefs.remove("loginEmail");
    setState(() {});
    print('-----LoginEmail---93---$loginEmail');

  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<LoginProvider>(builder: (context, provider, child) {
            return Container(
              height: _height,
              width: _width,
              // margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.only(top: 70),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: _height! * 0.01),
                    appLogoWidget(),
                    SizedBox(height: _height! * 0.04),
                    userNamePasswordWidget(),
                    SizedBox(height: _height! * 0.01),
                    forgotPassword(),
                    SizedBox(height: _height! * 0.06),
                    CustomButton(
                      text: provider.loginStatus == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.txtLogin,
                                  style: AppTextStyle
                                      .font14OpenSansBoldWhiteTextStyle,
                                ),
                                Image.asset(
                                  "assets/icons/click_ic.png",
                                  height: 35,
                                ),
                              ],
                            )
                          : CircularProgressIndicator(),
                      // buttonHeight: 45,
                      buttonColor: AppColors.orange,
                      onClick: () async {
                        // HERE YOU SHOLD APPLY LOGIC
                        if (userNameController.text == "") {
                          toastCode("Please enter valid emil");
                        } else if (passwordController.text == "") {
                          toastCode("Please enter valid PassWord");
                        }
                        else {}
                        debugPrint(
                            "username: ${provider.email} password: ${provider
                                .password}");
                        // if (_formKey.currentState!.validate()) {
                        //   print('Validated');
                        // }
                        if (provider.email != null &&
                            provider.password != null) {
                          var loginMap = await LoginRepo().authenticate(
                              context, provider.email!, provider.password!);

                          print('----150--------$loginMap');
                          var status2 = "${loginMap['status']}";
                          var msg2 = "${loginMap['message']}";
                          if(status2 == 'true'){

                            var id = "${loginMap['data']['id']}";
                            var status = "${loginMap['status']}";

                            SharedPreferences prefs = await SharedPreferences
                                .getInstance();
                            prefs.setString('loginEmail', "${provider.email}");
                            prefs.setString('loginPassword', "${provider
                                .password}");
                            prefs.setString('id', id);
                            prefs.setString('status', status);
                            prefs.setString(
                                'accessToken', "${loginMap['access_token']}");
                           // toastCode("User login successful");
                            print('-------------154----');
                          }else{
                            toastCode("Wrong email or password.");
                          }

                          print(
                              "loginMap-----144--: ${loginMap['access_token']}");
                          print("loginMap-----145--: $loginMap");
                          print(
                              "loginMap-----146--: ${loginMap['data']['id']}");
                          print("loginMap-----147--: ${loginMap['status']}");

                          //  --------------------

                          if (loginMap['status'] == true) {
                            // here you should check parameter fiel is null or not
                            if (userNameController.text == '' &&
                                passwordController.text == '') {
                              print('Enter user name or password---------');
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, AppStrings.routeToPendComp);
                            }
                          } else if (loginMap['status'] == false) {
                            toastCode("Wrong email or password");
                            print('------------login false----');

                            //   final snackBar = SnackBar(
                            //     content: Text(
                            //       AppStrings.txtPleaseCheckUsernameOrPassword,
                            //       style: AppTextStyle.font12OpenSansRegularRedTextStyle,
                            //     ),
                            //     backgroundColor: (AppColors.black),
                            //     duration: const Duration(seconds: 1),
                            //     action: SnackBarAction(
                            //       label: AppStrings.txtDismiss,
                            //       textColor: AppColors.red,
                            //       onPressed: () {},
                            //     ),
                            //   );
                            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            // }
                          }
                          else {
                            print('------------login false----');
                            toastCode("Wrong email or password");
                            //     final snackBar = SnackBar(
                            //       content: Text(
                            //         AppStrings.txtPleaseCheckUsernameOrPassword,
                            //         style:
                            //             AppTextStyle.font12OpenSansRegularRedTextStyle,
                            //       ),
                            //       backgroundColor: (AppColors.black),
                            //       duration: const Duration(seconds: 1),
                            //       action: SnackBarAction(
                            //         label: AppStrings.txtDismiss,
                            //         textColor: AppColors.red,
                            //         onPressed: () {},
                            //       ),
                            //     );
                            //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            //   }
                          };
                        }
                      }
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
  // tost code
  void toastCode(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Widget appLogoWidget() {
    return SizedBox(
      height: 150,
      width: 150,
      child: Image.asset(
        "assets/images/hmel_logo.png",
        // color: AppColors.red,
      ),
    );
  }
  Widget userNamePasswordWidget() {
    return Consumer<LoginProvider>(builder: (context, provider, child) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(AppStrings.txtEmail),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 5, bottom: 10, left: 20, right: 20),
              height: 48,
              child: TextFormField(
                controller: userNameController,
                focusNode: unameFocus,
                validator: (value) {
                  if (value!.isEmpty)
                  {
                    return 'Email is required';
                  }if(value.length<1){
                    return 'Please enter Valid emial';
                  }
                  return null;
                  // if (value == null || value.isEmpty) {
                  //   // Request focus in case of error
                  //   unameFocus.requestFocus();
                  //   return "Username can't be null";
                  // }
                  // return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.orange,
                  ),
                  labelText: AppStrings.txtPleaseEnterYourUserEmail,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10)),
                  border: const OutlineInputBorder(),
                ),

                onChanged: (input) {
                  // here data is insert provider setEmail ()
                  provider.setEmail(input);
                  // setState(() {
                  //   userName = input;
                  // });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(AppStrings.txtPassword),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
              height: 48,
              child: TextFormField(
                controller: passwordController,
                focusNode: passwordFocus,
                validator: (value) {

                  if (value == null || value.isEmpty) {
                    // Request focus in case of error
                    passwordFocus.requestFocus();
                    return "Password can't be null";
                  }
                  return null;
                },
                obscureText: !provider.isPasswordVisible,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColors.orange,
                    ),
                    labelText: AppStrings.txtPassword,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10)),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      color: AppColors.grey,
                      icon: visibleIcon!,
                      onPressed: () {
                        provider.setPasswordVisible();
                        // setState(() {
                        //   isVisible = !isVisible;
                        visibleIcon = provider.isPasswordVisible == true
                            ? const Icon(
                                Icons.visibility,
                                color: AppColors.orange,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: AppColors.grey,
                              );
                        // });
                      },
                    )),
                //data insert provider setPassword ()
                onChanged: (input) {
                  provider.setPassword(input);
                  // setState(() {
                  //   password = input;
                  // });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
  // email validation
  Widget forgotPassword() {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPassWord()),
        );

      },
      child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            AppStrings.txtForgotPassword,
            style: AppTextStyle.font12OpenSansBoldBlueTextStyle,
          )),
    );
  }
}
