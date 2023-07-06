import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lec/controller/providers/params_provider.dart';
import 'package:lec/model/models/fetch_params_model.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/screens/report_downlode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../../model/repository/base_repo.dart';
import '../app_data/app_strings.dart';
import 'downloading_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'downloading_dialog_report_2.dart';
import 'login.dart';

class LecComParams extends StatefulWidget {
  final String? lId,
      lName,
      vDate,
      applicantId,
      applicationId,
      applicantname,
      lec_id,
      mobile_no,
      email_id,
      type,
      location_serial_no;
  const LecComParams(
      {Key? key,
      this.lId,
      this.lName,
      this.vDate,
      this.applicantId,
      this.applicationId,
      this.applicantname,
      this.lec_id,
      this.email_id,
      this.mobile_no,
      this.type,
      this.location_serial_no})
      : super(key: key);

  @override
  State<LecComParams> createState() => _LecComParamsState();
}

class _LecComParamsState extends State<LecComParams> {
  double? _width;
  String? type_2;

  ParamsProvider? provider;
  FetchParamsModel? model;
  bool? hasParamsData;
  var lecIdValue;
  var applicationId;
  List catSearchSubcategoryList = [];
  var reportulploadextension;
  String? accessToken;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text(
              'Are you sure?',
              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
            ),
            content: new Text(
              'Do you want to go Home Page',
              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
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

  goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PendComp()),
    );
  }

  @override
  void initState() {
    getFetchDataFromaLocaldatabase();
    getParameterApi('${widget.lec_id}', '${widget.applicationId}');
    provider = Provider.of<ParamsProvider>(context, listen: false);

    super.initState();
    String? parameterId = provider!.lecParameterId;
    //ACCESS TOKEN

    print(
        '----100--> lec id: ${widget.lec_id}",applicationId: "${widget.applicationId}');
    lecIdValue = "${widget.lec_id}";
    applicationId = "${widget.applicationId}";
    print('-----99----$lecIdValue');
    print('-----100----$applicationId');
    print('-----------61----$lecIdValue');

    // future delay
    Future.delayed(const Duration(seconds: 1), () {
// Here you can write your code
      print(
          '--------------120----${provider?.selectedParams[0]["lec_report_upload"]}');

      setState(() {
        // Here you can write your code for open new view
      });
    });

    // provider!.fetchParamsInProvider("$lecIdValue", "$applicationId");

    // debugPrint("provider!.fpmap['status']!---- ${provider!.fpmap['status']!}");

    Future.delayed(Duration(milliseconds: 700), () {
      if (provider!.fpmap['status'] == false) {
        print('Cear method call --->${provider!.fpmap['status']}');
        provider!.clearParams();
      }
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  getFetchDataFromaLocaldatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    accessToken = prefs.getString('accessToken');
    provider!
        .fetchParamsInProvider("$lecIdValue", "$applicationId", "$accessToken");
    print('---access  token--$accessToken');
  }

  // getlecParameter
  Future<List?> getParameterApi(String lecId, String applicationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    String? id = prefs.getString('id');
    String? statusfirst = prefs.getString('status');
    String? accessToken = prefs.getString('accessToken');

    print('-----id----498---$id');
    print('-----status----499---$statusfirst');
    print('-----accessToken----500---$accessToken');

    try {
      var headers = {
        'X-API-KEY': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getLECParameters";
      var getlecParameterApi = "$baseURL$endPoint";
      var request = http.Request(
          'POST', Uri.parse('$getlecParameterApi'));
      request.body = json.encode({
        "lec_id": lecId,
        "application_id": applicationId,
        "access_token": accessToken
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      // print('--------183   xxxxx---${map[data][0]['lec_report_upload']}');
      print('--------182---${map['data'][0]['lec_report_upload']}');

      // store pdf into the local database
      // addStringToSF() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('pdfname', "${map['data'][0]['lec_report_upload']}");
      //  }

      print('--------183---$map');

      // print('--------183   xxxxx---${map[data][0]['lec_report_upload']}');

      print('--------185----${map['status']}');
      print('--------525----${map['IsTokenExpired']}');
      var status = "${map['status']}";
      var token = "${map['IsTokenExpired']}";
      print('-------status---528---$status');
      print('-------token---529---$token');
      if ((status == 'false') && (token == 'true')) {
        print('-----LogOut----');
        // here you shoudl remove emial

        //Read data
        String? loginEmail = prefs.getString('loginEmail');
        print('-----LoginEmail----536---$loginEmail');
        //Remove String
        prefs.remove("loginEmail");
        setState(() {});

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        print('-----Non Logout----');
      }

      // var headers = {
      //   'x-api-key': '123456',
      //   'Content-Type': 'application/json',
      //   'Authorization': 'Basic YWRtaW46MTIzNA=='
      // };
      // var request = http.Request('POST', Uri.parse('http://49.50.107.91/hmel/api/getAllLecRecord'));
      // request.body = json.encode({
      //   "status": 1,
      //   "officer_id": id,
      //   "access_token": accessToken
      // });
      // request.headers.addAll(headers);
      //
      // http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
    } on Error catch (e) {
      debugPrint('General Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    // _height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Consumer<ParamsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                AppStrings.txtLECCompletedList,
                style: AppTextStyle.font12OpenSansBoldOrangeTextStyle,
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PendComp()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.black,
                  )),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PendComp()),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset("assets/images/hmel_logo.png")),
                )
              ],
              elevation: 0,
            ),
            // body: Consumer<LecParamsProvider>(builder: (context, provider, child) {
            //   return
            body: Container(
              // height: _height,
              width: _width,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Card(
                    // margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    elevation: 8,
                    color: AppColors.lightGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      // color: AppColors.appGrey,
                      // width: _width! * 90,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppStrings.txtLocationID}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${AppStrings.txtLocationName}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${AppStrings.txtLECVisitDate}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${AppStrings.txtApplicationId}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${AppStrings.txtApplicantName}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "Mobile no.:",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "Email ID:",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "Type:",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.location_serial_no}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${widget.lName}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${widget.vDate}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${widget.applicantId}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${widget.applicantname}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${widget.mobile_no}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                "${widget.email_id}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                              Text(
                                widget.type == "0"
                                    ? "Individual"
                                    : widget.type == "1"
                                        ? "Non-Individual"
                                        : "Partnership",
                                // "${widget.type}",
                                style: AppTextStyle
                                    .font14OpenSansRegularWhiteTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  paramHeader(),
                  paramsValue(provider)
                  // paramWidget()
                ],
              ),
            ),
            // }),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.only(
                  right: 15, left: 15, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 175,
                    child: ElevatedButton.icon(
                      label: Text('Report Download',
                          style: AppTextStyle.font14OpenSansBoldWhiteTextStyle),
                      icon: Icon(Icons.download),
                      onPressed: () {
                        // here you should downlode report
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  DownloadingDialog2()),
                        // );
                        downloadFile(context);

                        // showDialog(
                        //   context: context,
                        //   builder: (context) => DownloadingDialog(reportulploadextension:  reportulploadextension ),
                        // );
                        // notification code
                        // Workmanager().initialize(
                        //     callbackDispatcher,
                        //     isInDebugMode: true
                        // );
                        // Workmanager().registerPeriodicTask(
                        //   "2", "simplePeriodicTask",
                        //   frequency: Duration(minutes: 15),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          textStyle:
                              AppTextStyle.font14OpenSansBoldWhiteTextStyle),
                    ),
                  ),

                  //AppStrings.txtDownloadLecVisitZip,
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 175,
                    child: ElevatedButton.icon(
                      label: Text('Photos',
                          style: AppTextStyle.font14OpenSansBoldWhiteTextStyle),
                      icon: Icon(Icons.download),
                      onPressed: () {
                        print(
                            '-----ReportDownlode ----lecID-----${widget.lec_id}');
                        print(
                            '-----ReportDownlode-------ApplicationId-${widget.applicationId}');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDownlode(
                                  lecId: '${widget.lec_id}',
                                  aplicationId: '${widget.applicationId}'),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          textStyle:
                              AppTextStyle.font14OpenSansBoldWhiteTextStyle),
                    ),
                  ),
                ],
              ),
            )),
      );
    }));
  }

  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) {
      FlutterLocalNotificationsPlugin flip =
          new FlutterLocalNotificationsPlugin();
      var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
      var settings = new InitializationSettings(android: android);
      flip.initialize(settings);
      _showNotificationWithDefaultSound(flip);
      return Future.value(true);
    });
  }

  //
  Future _showNotificationWithDefaultSound(flip) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flip.show(0, 'Hmel Lec', 'Your are one step away to open Pdf',
        platformChannelSpecifics,
        payload: 'Default_Sound');
  }

  void snakbarCode() {
    final snackBar = SnackBar(
      content: Text(
        "Documents saved Successfully",
        // AppStrings.txtPleaseFillAllTheParameters,
        style: AppTextStyle.font12OpenSansRegularRedTextStyle,
      ),
      backgroundColor: (AppColors.black),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: AppStrings.txtDismiss,
        textColor: AppColors.red,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget paramHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.txtLECParameters,
          style: AppTextStyle.font14OpenSansBoldLightGreenTextStyle,
        ),
        SizedBox(
          width: _width! * 0.46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [],
          ),
        )
      ],
    );
  }

  Widget paramsValue(ParamsProvider provider) {
    return Expanded(
      child: Card(
        // margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        elevation: 8,
        color: AppColors.lightGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        child: ListView.builder(
            itemCount: provider.selectedParams.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _width! * 0.45,
                      child: Text(provider.selectedParams[index]["p_name"],
                          style:
                              AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                    ),
                    Container(
                      width: _width! * 0.45,
                      padding: const EdgeInsets.only(left: 0, right: 5),
                      child: Text(
                          provider.selectedParams[index]["selected_val"],
                          style:
                              AppTextStyle.font14OpenSansRegularWhiteTextStyle),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  ///Request Permission
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  var _onPressed;
  Directory? externalDir;
  String? pdfdownload;
  String? url;

  String convertCurrentDateTimeToString() {
    String formattedDateTime =
        DateFormat('yyyyMMdd_kkmmss').format(DateTime.now()).toString();
    return formattedDateTime;
  }

  Future<void> downloadFile(BuildContext context) async {
    Dio dio = Dio();

    final status = await Permission.storage.request();
    if (status.isGranted) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/HMEL/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      try {
        FileUtils.mkdir([dirloc]);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //Return String
        pdfdownload = prefs.getString('pdfname');
        print('----------40-----$pdfdownload');

        // print('----------reportdownlodeextention ----20---${widget.reportulploadextension}');
        //String url = 'http://49.50.107.91/hmel/admin/lecDocumentZipApp/SG1lbCMxMjM0QGFwcA/${widget.lecId}';
        // String url = 'http://49.50.107.91/hmel//uploads/lecdocument/pdf/64425c37d68f52023_04_21.pdf';

        print('-------40 xxx -------$pdfdownload');
        url =
            'https://dealerselection.hmel.in/uploads/lecdocument/pdf/${pdfdownload}';
        print('---------40----$url');
        await dio
            .download(url!, dirloc + convertCurrentDateTimeToString() + ".pdf",
                onReceiveProgress: (receivedBytes, totalBytes) {
          print('here 1');
          setState(() {
            downloading = true;
            progress =
                ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
            print(progress);
          });
          print('here 2');
        });
      } catch (e) {
        print('catch catch catch');
        print(e);
      }

      setState(() {
        downloading = false;
        progress = "Download Completed.";
        path = dirloc + convertCurrentDateTimeToString() + ".pdf";
      });
      print(path);
      final snackBar = SnackBar(
        content: Text(
          "Download success at $path",
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "Dismiss",
          textColor: Colors.red,
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print('here give alert-->completed');
    } else {
      setState(() {
        progress = "Permission Denied!";
        _onPressed = () {
          downloadFile(context);
        };
      });
    }
  }
}
