import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lec/controller/providers/lec_params_provider.dart';
import 'package:lec/controller/providers/pending_photo_provider.dart';
import 'package:lec/controller/providers/pending_provider.dart';

import 'package:lec/controller/providers/report_upload_provider.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:provider/provider.dart';

import 'controller/providers/complete_provider.dart';
import 'controller/providers/get_lec_parameter_provider.dart';
import 'controller/providers/login_provider.dart';
import 'controller/providers/params_provider.dart';
import 'controller/providers/params_provider_complete.dart';
import 'controller/providers/report_downlode_provider.dart';
import 'view/routes/app_router.dart';
import 'view/screens/no_internet.dart';

void main() {
  // notification code
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  configLoading();
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
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

class _MyAppState extends State<MyApp> {
  bool activeConnection = false;
  String T = "";
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  void initState() {
    checkUserConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return activeConnection
        ? MultiProvider(
            providers: [
              ListenableProvider<LoginProvider>(create: (_) => LoginProvider()),
              ChangeNotifierProvider<ParamsProvider>(
                  create: (_) => ParamsProvider()),
              ListenableProvider<PendingPhotoProvider>(
                  create: (_) => PendingPhotoProvider()),
              ListenableProvider<ReportUploadProvider>(
                  create: (_) => ReportUploadProvider()),
              ListenableProvider<PendingProvider>(
                  create: (_) => PendingProvider()),
              ListenableProvider<CompleteListProvider>(
                  create: (_) => CompleteListProvider()),
              ListenableProvider<ParamsProviderCom>(
                  create: (_) => ParamsProviderCom()),
              ListenableProvider<GetLecParametersProvider>(
                  create: (_) => GetLecParametersProvider()),
              ListenableProvider<ReportDownlodeProvider>(
                  create: (_) => ReportDownlodeProvider()),
            ],//ReportDownlodeProvider
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: AppStrings.routeToSplash,
              onGenerateRoute: generateRoute,
              builder: EasyLoading.init(),

            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: NoInternet(),
            builder: EasyLoading.init(),
            // initialRoute: AppStrings.routeToSplash,
            // onGenerateRoute: generateRoute,
          );
  }
}
