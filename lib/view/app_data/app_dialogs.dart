import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/widgets/custom_buttom.dart';
import 'app_colors.dart';

class AppDialogs {
  ///Withdraw Dialog
  static Future openThankYouDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)), //this right here
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width * 0.90,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.orange),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // margin: EdgeInsets.only(right: 10),
                    height: 50,
                    child: Image.asset("assets/images/hmel_logo.png"),
                  ),
                  Container(
                      // height: 0,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Thank you",
                        style: AppTextStyle
                            .font18OpenSansExtraBoldLightGreenTextStyle,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                      buttonHeight: 30,
                      buttonWidth: 80,
                      buttonColor: AppColors.orange,
                      onClick: () {
                        Navigator.pop(context);
                      },
                      text: Text(
                        "OK",
                        style: AppTextStyle.font12OpenSansRegularWhiteTextStyle,
                      ))
                ],
              ),
            ),
          );
        });
  }

  ///OpenSettingForLocation
  static Future openLocationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.lightGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)), //this right here
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width * 0.90,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.orange),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      // height: 0,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Please enable location service",
                        style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                          buttonHeight: 30,
                          buttonWidth: 80,
                          buttonColor: AppColors.orange,
                          onClick: () {
                            Navigator.pop(context);
                          },
                          text: Text(
                            "Cancel",
                            style: AppTextStyle
                                .font12OpenSansRegularWhiteTextStyle,
                          )),
                      CustomButton(
                          buttonHeight: 30,
                          buttonWidth: 80,
                          buttonColor: AppColors.orange,
                          onClick: () {
                            AppSettings.openLocationSettings();
                            Navigator.pop(context);
                          },
                          text: Text(
                            "Open",
                            style: AppTextStyle
                                .font12OpenSansRegularWhiteTextStyle,
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }



  ///AreYouOkToSubmit
  static Future openAreYouOkToSubmitDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)), //this right here
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width * 0.90,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.orange),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // margin: EdgeInsets.only(right: 10),
                    height: 50,
                    child: Image.asset("assets/images/hmel_logo.png"),
                  ),
                  Container(
                      // height: 0,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Are you OK to submit?",
                        style: AppTextStyle
                            .font18OpenSansExtraBoldLightGreenTextStyle,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                          buttonHeight: 30,
                          buttonWidth: 80,
                          buttonColor: AppColors.orange,
                          onClick: () {
                            Navigator.pop(context);
                          },
                          text: Text(
                            "Cancel",
                            style: AppTextStyle
                                .font12OpenSansRegularWhiteTextStyle,
                          )),
                      CustomButton(
                          buttonHeight: 30,
                          buttonWidth: 80,
                          buttonColor: AppColors.orange,
                          onClick: () {
                            final snackBar = SnackBar(
                              content: Text(
                                  AppStrings.txtLECSubmittedSuccessfully,
                                  style: AppTextStyle
                                      .font12OpenSansRegularWhiteTextStyle),
                              backgroundColor: (AppColors.lightGreen),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: AppStrings.txtDismiss,
                                textColor: AppColors.red,
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            Navigator.pop(context);
                          },
                          text: Text(
                            "OK",
                            style: AppTextStyle
                                .font12OpenSansRegularWhiteTextStyle,
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
