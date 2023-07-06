import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/widgets/card_shimmer.dart';
import 'package:lec/view/widgets/top_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/providers/report_downlode_provider.dart';
import '../../model/repository/base_repo.dart';
import 'downloding_report_dialog.dart';
import 'login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportDownlode extends StatefulWidget {
  String? lecId;
  String? aplicationId;

  ReportDownlode({Key? key, @required this.lecId, @required this.aplicationId})
      : super(key: key);

  @override
  State<ReportDownlode> createState() => _LecPendingListState();
}

class _LecPendingListState extends State<ReportDownlode> {
  String? applicationid, applicantId;
  double? _height, _width;
  int? typeValue;
  String? type;
  String? appType;
  String? lectype;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //late PendingProvider pendingProvider;
  late ReportDownlodeProvider reportDownlodeProvider;
  var data;
  var docResponse;
  bool? docResponse2;
  //
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
    getreportDownlodeApi();
    debugPrint("PendingProvider");
    super.initState();
    reportDownlodeProvider =
        Provider.of<ReportDownlodeProvider>(context, listen: false);

    data = reportDownlodeProvider.loadRepoInProvider(
        "${widget.lecId}", "${widget.aplicationId}");
    debugPrint("PendingProvider...xxx-->51: $data");
    print('------------52---$data');
    print('------------82---${widget.lecId}');
    print('------------83---${widget.aplicationId}');

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  // getReportdownlodeapi
  Future<List?> getreportDownlodeApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    String? id = prefs.getString('id');
    String? statusfirst = prefs.getString('status');
    String? accessToken = prefs.getString('accessToken');

    print('-----id----498---$id');
    print('-----status----499---$statusfirst');
    print('-----accessToken----500---$accessToken');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Read data
      String? id = prefs.getString('id');
      String? statusfirst = prefs.getString('status');
      String? accessToken = prefs.getString('accessToken');

      print('-----id----498---$id');
      print('-----status----499---$statusfirst');
      print('-----accessToken----500---$accessToken');

      var headers = {
        'Content-Type': 'application/json',
        'x-api-key': '123456',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getLECdoc";
      var getLecDocApi = "$baseURL$endPoint";
      var request = http.Request(
          'POST', Uri.parse('$getLecDocApi'));
      request.body = json.encode({
        "lec_id": widget.lecId,
        "application_id": widget.aplicationId,
        "access_token": accessToken
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('--------522---$map');

      print('--------524----${map['status']}');
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

      if (response.statusCode == 200) {
      } else {}
    } on Error catch (e) {
      debugPrint('General Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Consumer<ReportDownlodeProvider>(
        builder: (context, provider, child) {
      return !provider.isLoaded
          ? const CardShimmer(height: 110)
          : SafeArea(
              child: WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: AppColors.backgroundColor,
                  body: SizedBox(
                    height: _height,
                    width: _width,
                    child: Column(
                      children: [
                        TopBar(
                            scaffoldKey: _scaffoldKey,
                            titleText:
                                const Text(AppStrings.txtLECCompletedList)
                            // route: AppStrings.routeToNewArchives,
                            ),
                        ElevatedButton.icon(
                          label: Text('Download photo zip',
                              style: AppTextStyle
                                  .font14OpenSansBoldWhiteTextStyle),
                          icon: const Icon(Icons.download),
                          onPressed: () {
                            ///Photo Download
                            //   print("Photo download");
                            //    showDialog(
                            //   context: context,
                            //   builder: (context) => downloadFile(context);
                            // );

                            downloadFile(context);
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => DownloadinReportDialog(
                            //       lecId:
                            //           "${widget.lecId}"), // lecId:  widget.lec_id
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              textStyle: AppTextStyle
                                  .font14OpenSansBoldWhiteTextStyle),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: provider.repotdownldoelist!.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                    onTap: () async {
                                      var lecid =
                                          provider.repotdownldoelist![index]
                                              ['lec_doc_latitude'];
                                      applicationid =
                                          provider.repotdownldoelist![index]
                                              ['lec_doc_longitude'];
                                      // Api
                                      print('lecid ----99-->$lecid');
                                      print(
                                          'application_id ----100-->$applicationid');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 100.0,
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        provider.repotdownldoelist![
                                                                index]
                                                            ['lec_documents']),
                                                    fit: BoxFit.cover),
                                                borderRadius: const BorderRadius
                                                        .only(
                                                    topRight:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(10.0))),
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            height: 100.0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    'id : ' +
                                                        provider.repotdownldoelist![
                                                            index]['lec_id'],
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularBlackTextStyle),
                                                SizedBox(height: 5.0),
                                                Text(
                                                    'latitudde : ' +
                                                        provider.repotdownldoelist![
                                                                index][
                                                            'lec_doc_latitude'],
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularBlackTextStyle),
                                                SizedBox(height: 5.0),
                                                Text(
                                                    'longitude : ' +
                                                        provider.repotdownldoelist![
                                                                index][
                                                            'lec_doc_longitude'],
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularBlackTextStyle),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              })),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
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

  ///Convert Current DateTime
  String convertCurrentDateTimeToString() {
    String formattedDateTime =
        DateFormat('yyyyMMdd_kkmmss').format(DateTime.now()).toString();
    return formattedDateTime;
  }

  ///Download File
  Future<void> downloadFile(BuildContext context) async {
    Dio dio = Dio();

    final status = await Permission.storage.request();
    if (status.isGranted) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/HMEL/Photos/";
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
        var baseURL = BaseRepo().baseurl;
        var endPoint = "/admin/lecDocumentZipApp/SG1lbCMxMjM0QGFwcA/";
        var downlodezipApi = "$baseURL$endPoint${widget.lecId}";
       // url = 'https://dealerselection.hmel.in/admin/lecDocumentZipApp/SG1lbCMxMjM0QGFwcA/${widget.lecId}';
        //url = 'https://49.50.77.135/lecDocumentZipApp/SG1lbCMxMjM0QGFwcA/${widget.lecId}';
        // url =
        //     'http://49.50.107.91/hmel//uploads/lecdocument/pdf/${pdfdownload}';
        print('---------40----$downlodezipApi');
        await dio
            .download(downlodezipApi!, dirloc + convertCurrentDateTimeToString() + ".zip",
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
        path = dirloc + convertCurrentDateTimeToString() + ".zip";
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
