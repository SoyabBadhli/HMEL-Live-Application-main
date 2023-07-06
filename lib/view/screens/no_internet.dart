import 'package:flutter/material.dart';
import 'package:lec/main.dart';

import '../app_data/app_colors.dart';
import '../app_data/app_strings.dart';
import '../app_data/app_text_style.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoInternetState();
  }
}

class NoInternetState extends State<NoInternet> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 4), () {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, AppStrings.routeToLogin, (route) => false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(
                "assets/images/hmel_logo.png",
                // color: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text("No Internet Connection",
                  // AppStrings.txtCopyright,
                  style: AppTextStyle.font14OpenSansBoldBlackTextStyle),
            ),
            MaterialButton(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => MyApp())));
                },
                child: Text("Retry",
                    style: AppTextStyle.font14OpenSansSemiBoldGreenTextStyle))
          ],
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
              child: Text(AppStrings.txtCopyright,
                  style: AppTextStyle.font12OpenSansRegularBlackTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
