import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lec/controller/providers/pending_provider.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/login.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/screens/pending_photo_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lec/view/screens/report_upload.dart';
import 'package:lec/view/widgets/card_shimmer.dart';
import 'package:lec/view/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../controller/providers/complete_provider.dart';
import '../../model/repository/base_repo.dart';
import '../../model/repository/complete_repo.dart';
import 'lec_complete_list_detail.dart';
import 'lec_params.dart';

class LecCompletedList extends StatefulWidget {
  const LecCompletedList({Key? key}) : super(key: key);

  @override
  State<LecCompletedList> createState() => _LecPendingListState();
}

class _LecPendingListState extends State<LecCompletedList> {
  String? lecid, applicationid, applicantId;
  double? _height, _width;
  int? typeValue;
  String? type;
  String? appType;
  String? lectype;
  Future<AlbumDoc>? _futureAlbum;
  List dataList = [];
  String? accessToken;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //late PendingProvider pendingProvider;
  late CompleteListProvider completeListProvider;
  CompleRepo? compleRepo;
  var data;
  var docResponse;
  bool? docResponse2;
  bool? isTokenVerified = false;
  bool? status = true;

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
    debugPrint("PendingProvider");
    getApiCompleList();
    super.initState();
    // getCompleApi();
    completeListProvider =
        Provider.of<CompleteListProvider>(context, listen: false);
    data = completeListProvider.loadRepoInProvider();

    Future.delayed(const Duration(seconds: 3), () {
      var responseValue = completeListProvider.completeDataPro;
      print('-------92---responseValue--$responseValue');
      print('---95------${completeListProvider.completeDataPro!}');

      // isTokenVerified = responseValue[1] == 'true'? true:false;
      // status = responseValue[0] == 'false'? false: true;
      //
      // if(status == false && isTokenVerified == true){
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
      //     return const Login();
      //   }));
      // }

      setState(() {
        // Here you can write your code for open new view
      });
    });

    debugPrint("PendingProvider...xxx-->35: $data");
    print('------------52---$data');

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  void navigateToLogin() {
    // here remove email to local database
    print('----Logout-----');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const Login()),
    // );
  }

  void getDataFromaProvider(CompleteListProvider provider) {
    var response = provider.completeDataPro;
    print('----------101---$response');
  }

  // loder code
  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 10.0),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Consumer<CompleteListProvider>(builder: (context, provider, child) {
      return !provider.isLoaded
          ? Card(
              margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
              elevation: 8,
              color: AppColors.lightGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TopBar(
                          scaffoldKey: _scaffoldKey,
                          titleText: Text(AppStrings.txtLECPendingList)
                          // route: AppStrings.routeToNewArchives,
                          ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Center(
                          child: Text("No Completed List",
                              style: AppTextStyle
                                  .font14OpenSansRegularBlackTextStyle),
                        )),
                  ],
                ),
              ),
            ) //const CardShimmer(height: 110)
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
                            titleText: Text(AppStrings.txtLECCompletedList)
                            // route: AppStrings.routeToNewArchives,
                            ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: provider.completeDataPro!.length,
                              itemBuilder: ((context, index) {
                                appType = provider.completeDataPro![index]
                                        ['application_type']
                                    .toString();
                                print('---------> 69xx.... $appType');
                                return GestureDetector(
                                  onTap: () async {
                                    lecid = provider.completeDataPro![index]
                                            ['lec_id']
                                        .toString();
                                    applicationid = provider
                                        .completeDataPro![index]
                                            ['application_id']
                                        .toString();

                                    // Api
                                    print('lecid -------------->$lecid');
                                    print(
                                        'application_id --------->$applicationid');
                                    //createAlbumDoc('$lecid','$applicationid');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => LecComParams(
                                                  lId:
                                                      provider.completeDataPro![
                                                          index]['location_id'],
                                                  lName: provider
                                                          .completeDataPro![
                                                      index]['location_name'],
                                                  vDate: provider
                                                          .completeDataPro![
                                                      index]['lec_visit_date'],
                                                  applicantId: provider
                                                              .completeDataPro![
                                                          index]
                                                      ['application_ref_no'],
                                                  applicationId: provider
                                                          .completeDataPro![
                                                      index]['application_id'],
                                                  applicantname: provider
                                                          .completeDataPro![
                                                      index]['applicant_name'],
                                                  lec_id:
                                                      provider.completeDataPro![
                                                          index]['lec_id'],
                                                  mobile_no:
                                                      provider.completeDataPro![
                                                          index]['mobile_no'],
                                                  email_id:
                                                      provider.completeDataPro![
                                                          index]['email_id'],
                                                  type:
                                                      provider.completeDataPro![
                                                              index]
                                                          ['application_type'],
                                                  location_serial_no: provider
                                                              .completeDataPro![
                                                          index]
                                                      ['location_serial_no'],

                                                  /// sharedPreference
                                                ))));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    elevation: 8,
                                    color: AppColors.lightGreen,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Container(
                                      // color: AppColors.appGrey,
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                          // SizedBox(height: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                //mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Text(
                                                    provider.completeDataPro![
                                                        index]['location_id'],
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularWhiteTextStyle,
                                                  ),
                                                  Text(
                                                    provider.completeDataPro![
                                                            index]
                                                        ['location_serial_no'],
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularWhiteTextStyle,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                provider.completeDataPro![index]
                                                    ['location_name'],
                                                style: AppTextStyle
                                                    .font14OpenSansRegularWhiteTextStyle,
                                              ),
                                              Text(
                                                provider.completeDataPro![index]
                                                    ['lec_visit_date'],
                                                style: AppTextStyle
                                                    .font14OpenSansRegularWhiteTextStyle,
                                              ),
                                              Text(
                                                provider.completeDataPro![index]
                                                    ['application_ref_no'],
                                                style: AppTextStyle
                                                    .font14OpenSansRegularWhiteTextStyle,
                                              ),
                                              Text(
                                                provider.completeDataPro![index]
                                                    ['applicant_name'],
                                                style: AppTextStyle
                                                    .font14OpenSansRegularWhiteTextStyle,
                                              ),
                                              Text(
                                                provider.completeDataPro![index]
                                                    ['mobile_no'],
                                                style: AppTextStyle
                                                    .font14OpenSansRegularWhiteTextStyle,
                                              ),
                                              Text(
                                                provider.completeDataPro![index]
                                                    ['email_id'],
                                                style: AppTextStyle
                                                    .font14OpenSansRegularWhiteTextStyle,
                                              ),
                                              Text(
                                                provider.completeDataPro![index]
                                                            [
                                                            'application_type'] ==
                                                        "0"
                                                    ? "Individual"
                                                    : provider.completeDataPro![
                                                                    index][
                                                                'application_type'] ==
                                                            "1"
                                                        ? "Non-Individual"
                                                        : "Partnership",
                                                style: AppTextStyle
                                                    .font14OpenSansRegularWhiteTextStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
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

  //
  Future<AlbumDoc> createAlbumDoc(
      String lecId, String applicantId, String accesstoken) async {
    var baseURL = BaseRepo().baseurl;
    var endPoint = "/api/getLECdoc";
    var getlecApi = "$baseURL$endPoint";
    final response = await http.post(
      Uri.parse('$getlecApi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'lec_id': lecId,
        'application_id': applicantId,
        'access_token': accesstoken,
      }),
    );
    if (response.statusCode == 200) {
      print('Response----${response.statusCode}');
      print('Response--297--${response.body}');
      var map = jsonDecode(response.body);
      print('----------333-----');
      print("334------" + map['status'].toString());

      docResponse = map['status'];
      setState(() {
        print("377");
        docResponse = map['status'];
      });
      var status = (map['status']);
      print('statuse----341-------xx---$status');

      print('--389 STATUS--- $docResponse');
      return AlbumDoc.fromJson(jsonDecode(response.body));
    } else {
      var map = jsonDecode(response.body);
      print('Response--309--${response.statusCode}');
      print('Response----${response.body}');
      print("map['status']: ${map['status']}");
      setState(() {
        print("407");
        docResponse = map['status'];
      });
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<List?> getApiCompleList() async {
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
        'x-api-key': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getAllLecRecord";
      var getAllRecordApi = "$baseURL$endPoint";
      var request = http.Request(
          'POST', Uri.parse('$getAllRecordApi'));
      request.body = json
          .encode({"status": 1, "officer_id": id, "access_token": accessToken});
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
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
    } on SocketException catch (e) {
      debugPrint('Socket Error: $e');
    } on Error catch (e) {
      debugPrint('General Error: $e');
    }
  }
}

// Constractro
class AlbumDoc {
  final String lecId;
  final String applicantId;

  const AlbumDoc({required this.lecId, required this.applicantId});

  factory AlbumDoc.fromJson(Map<String, dynamic> json) {
    return AlbumDoc(
      lecId: json['lec_id'] ?? '',
      applicantId: json['applicant_id'] ?? '',
    );
  }
}
