import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/lec_completed_list.dart';
import 'package:lec/view/screens/lec_pending_list.dart';
import 'package:lec/view/widgets/custom_buttom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class PendComp extends StatefulWidget {
  const PendComp({Key? key}) : super(key: key);

  @override
  State<PendComp> createState() => _PendCompState();
}

class _PendCompState extends State<PendComp> {
  double? _height, _width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
      ]);
  }
  //
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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,

          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SizedBox(
              height: _height,
              width: _width,
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20,top: 20),
                    child: Container(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('LOG OUT......');
                              getloginInfoToLocalDataBase();
                              },
                            child: Container(
                              child:  Icon(Icons.logout,color: Colors.orange,),
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Container(
                        height: 100,
                        child: Image.asset("assets/images/hmel_logo.png")),
                  ),
                  Card(
                    elevation: 8,
                    margin: EdgeInsets.only(bottom: 30, top: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: CustomButton(
                        buttonHeight: 80,
                        buttonWidth: 180,
                        buttonColor: AppColors.orange,
                        onClick: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new LecPendingList(),
                            ),
                          );
                          // Navigator.pushNamed(
                          //     context, AppStrings.routeToLecPendingList);
                        },
                        text: Text(
                          AppStrings.txtLECPendingList,
                          style: AppTextStyle.font12OpenSansRegularWhiteTextStyle,
                        )),
                  ),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: CustomButton(
                        buttonHeight: 80,
                        buttonWidth: 180,
                        buttonColor: AppColors.orange,
                        onClick: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new LecCompletedList(),
                            ),
                          );
                          // Navigator.pushNamed(
                          //     context, AppStrings.routeToLecCompletedList);
                          //CompleteListProvider
                        },
                        text: Text(AppStrings.txtLECCompletedList,
                            style:
                                AppTextStyle.font12OpenSansRegularWhiteTextStyle)),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  getloginInfoToLocalDataBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    String? loginEmail = prefs.getString('loginEmail');
    print('-----LoginEmail----124---$loginEmail');
    //Remove String
    prefs.remove("loginEmail");
    setState(() {
    });
    print('-----LoginEmail----127---$loginEmail');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );

   /* prefs.remove("stringValue");
    //Remove bool
    prefs.remove("boolValue");
    //Remove int
    prefs.remove("intValue");
    //Remove double
    prefs.remove("doubleValue");*/
  }
}
