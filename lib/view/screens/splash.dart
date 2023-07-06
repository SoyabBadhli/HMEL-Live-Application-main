import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_data/app_colors.dart';
import '../app_data/app_strings.dart';
import '../app_data/app_text_style.dart';

class Splash extends StatefulWidget {

  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}
class SplashState extends State<Splash> {
  String? loginEmail;
  @override
   initState()  {
    super.initState();

    loginFetchDetail();

    Future.delayed(const Duration(seconds: 1), () {

      if(loginEmail !=null){
        Navigator.pushNamedAndRemoveUntil(context, AppStrings.routeToPendComp, (route) => false);
      }else{
        Navigator.pushNamedAndRemoveUntil(context, AppStrings.routeToLogin, (route) => false);
      }
    //  Navigator.pushNamedAndRemoveUntil(context, AppStrings.routeToLogin, (route) => false);
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }
  loginFetchDetail() async {
    // to fetch login detail
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    loginEmail = prefs.getString('loginEmail');
    String? loginPassword = prefs.getString('loginPassword');
    print('------loginEmail-----28--$loginEmail');
    print('------loginPassword-----29--$loginPassword');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Image.asset(
            "assets/images/hmel_logo.png",
            // color: Colors.transparent,
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.orange, AppColors.lightGreen],
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                AppStrings.txtCopyright,
                style: AppTextStyle.font12OpenSansRegularBlackTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
