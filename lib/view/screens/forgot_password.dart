import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lec/controller/providers/login_provider.dart';
import 'package:lec/model/repository/login_repo.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/widgets/custom_buttom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/models/forgot_passwrod_model.dart';
import '../../model/repository/base_repo.dart';
import '../app_data/app_colors.dart';
import '../app_data/app_strings.dart';
import '../app_data/app_text_style.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<ForgotPassWord> {
  double? _height;
  double? _width;
  TextEditingController userEmailController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        content: new Text('Do you want to go Login Page',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              goToHomePage();
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
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  void initState() {
    // isVisible = true;

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
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
                    CustomButton(
                    text: Text(AppStrings.txtForgotPassword,
                        style: AppTextStyle
                            .font14OpenSansBoldWhiteTextStyle),
                      // buttonHeight: 45,
                      buttonColor: AppColors.orange,
                      onClick: () async {
                      print('------107---');
                      print('FORGOT PASSWORD..108--..${userEmailController.text}');
                     // forgotPassWordApi(userEmailController.text);
                     // forgotPassWordApi('soyab.ali@cyfuture.com');
                      forgotPassWordApi(userEmailController.text);

                      },
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
  // forgotApi
  void forgotPassWordApi(email) async {

    var headers = {
      'X-API-KEY': '123456',
      'Authorization': 'Basic YWRtaW46MTIzNA=='
    };
    var baseURL = BaseRepo().baseurl;
    var endPoint = "/api/forgerPassword";
    var forgotPassWordApi = "$baseURL$endPoint";
    var request = http.MultipartRequest('POST', Uri.parse('$forgotPassWordApi'));
    request.fields.addAll({
      'email': '$email'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Toast code
      Fluttertoast.showToast(
          msg: "Password Reset link has been send to registered email !",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      // naviate to login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );

      print('---140----${response.statusCode}');

      var data = await response.stream.bytesToString();
      var map = json.decode(data);
      print('---144----$map');
      // cardtype data

    } else {
      Fluttertoast.showToast(
          msg: "please enter valid email!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print('---148----${response.statusCode}');
    }
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
                controller: userEmailController,


                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // Request focus in case of error
                    return "Email can't be null";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: AppColors.orange,
                  ),
                  labelText: AppStrings.txtForgetPassword,
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
            // const Padding(
            //   padding: EdgeInsets.only(left: 20),
            //   child: Text(AppStrings.txtPassword),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
            //   height: 48,
            //   child: TextFormField(
            //     controller: passwordController,
            //     focusNode: passwordFocus,
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         // Request focus in case of error
            //         passwordFocus.requestFocus();
            //         return "Password can't be null";
            //       }
            //       return null;
            //     },
            //     obscureText: !provider.isPasswordVisible,
            //     decoration: InputDecoration(
            //         filled: true,
            //         fillColor: Colors.white,
            //         prefixIcon: const Icon(
            //           Icons.lock,
            //           color: AppColors.orange,
            //         ),
            //         labelText: AppStrings.txtPassword,
            //         enabledBorder: OutlineInputBorder(
            //             borderSide: const BorderSide(color: Colors.black),
            //             borderRadius: BorderRadius.circular(10)),
            //         focusedBorder: OutlineInputBorder(
            //             borderSide: const BorderSide(color: Colors.orange),
            //             borderRadius: BorderRadius.circular(10)),
            //         border: const OutlineInputBorder(),
            //         suffixIcon: IconButton(
            //           color: AppColors.grey,
            //           icon: visibleIcon!,
            //           onPressed: () {
            //             provider.setPasswordVisible();
            //             // setState(() {
            //             //   isVisible = !isVisible;
            //             visibleIcon = provider.isPasswordVisible == true
            //                 ? const Icon(
            //               Icons.visibility,
            //               color: AppColors.orange,
            //             )
            //                 : const Icon(
            //               Icons.visibility_off,
            //               color: AppColors.grey,
            //             );
            //             // });
            //           },
            //         )),
            //     //data insert provider setPassword ()
            //     onChanged: (input) {
            //       provider.setPassword(input);
            //       // setState(() {
            //       //   password = input;
            //       // });
            //     },
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
