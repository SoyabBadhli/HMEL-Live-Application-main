import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lec/controller/providers/pending_provider.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/screens/report_upload.dart';
import 'package:lec/view/widgets/card_shimmer.dart';
import 'package:lec/view/widgets/loader_services.dart';
import 'package:lec/view/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/repository/base_repo.dart';
import 'lec_params.dart';
import 'package:intl/intl.dart';

import 'login.dart';

class LecPendingList extends StatefulWidget {

  const LecPendingList({Key? key}) : super(key: key);

  @override
  State<LecPendingList> createState() => _LecPendingListState();
}
class _LecPendingListState extends State<LecPendingList> {
  String? lecid, applicationid,applicantId;
  double? _height, _width;
  int? typeValue;
  String? type;
  String? appType;
  String? lectype;
  Future<AlbumDoc>? _futureAlbum;
  String? id;
  String? statusfirst;
  String?  accessToken;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PendingProvider pendingProvider;

  var data;
  var docResponse;
  bool? docResponse2;

  // Future<bool> _onWillPop() async {
  //   return false; //<-- SEE HERE
  // }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        content: new Text('Do you want to go Home Page',style: AppTextStyle
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
       MaterialPageRoute(builder: (context) => const PendComp()),
     );
   }

  @override
  void initState() {
    debugPrint("PendingProvider");
    getToken();
    getPendingApiListData();
    super.initState();
    pendingProvider = Provider.of<PendingProvider>(context, listen: false);
    data = pendingProvider.loadRepoInProvider();

    //
    Future.delayed(const Duration(milliseconds: 50), () {

// Here you can write your code
     // _onLoading();

      setState(() {
        // Here you can write your code for open new view
      });

    });
    Future.delayed(const Duration(seconds: 3), () {

// Here you can write your code
      var status = pendingProvider.pendDataPro![0]['status'];
      print('-------52---$status');
      //_onLoading();

      setState(() {
        // Here you can write your code for open new view
      });

    });

    SystemChrome.setPreferredOrientations(
     [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }
  // @override
  // void didChangeDependencies() {
  //   getPendingApiListData();
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }


  //
  // loader
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
   toastCode(){
    Fluttertoast.showToast(
        msg: "Data is not available show the message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  //
  // get token
  void getToken()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
     id = prefs.getString('id');
     statusfirst = prefs.getString('status');
    accessToken = prefs.getString('accessToken');

    print('-----id----169---$id');
    print('-----status----170---$statusfirst');
    print('-----accessToken----171---$accessToken');
  }
  Future<List?> getPendingApiListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

     showLoader();
    try {
      var headers = {
        'x-api-key': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getAllLecRecord";
      var getAllRecordApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$getAllRecordApi'));
      request.body = json.encode({
        "status": 0,
        "officer_id": id,
        "access_token": accessToken
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------199----$map');
       var leciD = "${map['lec_id']}";
       print("---------------------------201----$leciD");

      var status = "${map['status']}";
      var token = "${map['IsTokenExpired']}";
      print('-------status---184---$status');
      print('-------token---185---$token');

      if((status == 'false') && (token == 'true')){
        hideLoader();
        print('-----LogOut----');
        // here you shoudl remove emial

        //Read data
        String? loginEmail = prefs.getString('loginEmail');
        print('-----LoginEmail----536---$loginEmail');
        //Remove String
        prefs.remove("loginEmail");
        setState(() {
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );

      }else{
        print('-----Non Logout----');
        hideLoader();
      }
      if(response.statusCode == 200)
      {
       hideLoader();
      } else {
        hideLoader();
        // print(response.reasonPhrase);
        // return map;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
      hideLoader();
    } on Error catch (e) {
      debugPrint('General Error: $e');
      hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;

    return Consumer<PendingProvider>(builder: (context, provider, child) {
      return !provider.isLoaded
          ? Card(
        margin: const EdgeInsets.only(
            left: 0, right: 0, bottom: 0),
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
                                  padding: const EdgeInsets.only(top: 10,left: 20),
                                 child: Center(child: Text("No Pending List",style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle),)),


             ],
           ),
         ),
      )
      //     ?  Container(
      //        height: MediaQuery.of(context).size.height,
      //        width: MediaQuery.of(context).size.width,
      //        color: Colors.white,
      //        child: Padding(
      //          padding: const EdgeInsets.only(top: 30,left: 20),
      //          child: Center(child: Text("Data is not available",style: TextStyle(fontSize: 16,color: Colors.black),)),
      //        ),
      // ) //  const CardShimmer(height: 110)
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
                      titleText: Text(AppStrings.txtLECPendingList)
                    // route: AppStrings.routeToNewArchives,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: provider.pendDataPro!.length,
                        itemBuilder: ((context, index) {
                          appType = provider.pendDataPro![index]['application_type'];
                          print('---------> 69xx.... $appType');
                          return GestureDetector(
                            onTap: () async {

                              lecid = provider.pendDataPro![index]['lec_id'];
                              applicationid = provider.pendDataPro![index]['application_id'];
                              // Api
                              print('lecid -------------326-->$lecid');
                              print('application_id ---------327-->$applicationid');
                              print('---------328--token----$accessToken');

                              createAlbumDoc('$lecid','$applicationid','$accessToken');

                              Future.delayed(Duration(seconds: 1),(){
                                print("docResponse after delay rah------: $docResponse");

                                if(docResponse=='true'){
                                  print('-----------337----ReportUpload');
                                  print('-----337--$docResponse');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              ReportUpload(
                                                lId:
                                                provider.pendDataPro![index]['location_id'],

                                                lName:
                                                provider.pendDataPro![index]
                                                ['location_name'],
                                                vDate:
                                                provider.pendDataPro![index]
                                                ['lec_visit_date'],
                                                applicantId:
                                                provider.pendDataPro![index]
                                                ['application_ref_no'],
                                                applicationId:
                                                provider.pendDataPro![index]
                                                ['application_id'],
                                                applicantname:
                                                provider.pendDataPro![index]
                                                ['applicant_name'],
                                                lec_id:
                                                provider.pendDataPro![index]
                                                ['lec_id'],
                                                mobile_no:
                                                provider.pendDataPro![index]
                                                ['mobile_no'],
                                                email_id:
                                                provider.pendDataPro![index]
                                                ['email_id'],
                                                type:
                                                provider.pendDataPro![index]
                                                ['application_type'],
                                                location_serial_no:
                                                provider.pendDataPro![index]
                                                ['location_serial_no'],

                                                /// sharedPreference
                                              ))));
                                }else{
                                  print('-----------379----LecParms');
                                  print('-----337--$docResponse');
                                  var applicatinType =  provider.pendDataPro![index]
                                  ['application_type'];
                                  print('------------389---$applicatinType');

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LecParams(
                                                lId:
                                                provider.pendDataPro![index]['location_id'],
                                                lName:
                                                provider.pendDataPro![index]
                                                ['location_name'],
                                                vDate:
                                                provider.pendDataPro![index]
                                                ['lec_visit_date'],
                                                applicantId:
                                                provider.pendDataPro![index]
                                                ['application_ref_no'],
                                                applicationId:
                                                provider.pendDataPro![index]
                                                ['application_id'],
                                                applicantname:
                                                provider.pendDataPro![index]
                                                ['applicant_name'],
                                                lec_id:
                                                provider.pendDataPro![index]
                                                ['lec_id'],
                                                mobile_no:
                                                provider.pendDataPro![index]
                                                ['mobile_no'],
                                                email_id:
                                                provider.pendDataPro![index]
                                                ['email_id'],
                                                type:
                                                provider.pendDataPro![index]
                                                ['application_type'],
                                                location_serial_no:
                                                provider.pendDataPro![index]
                                                ['location_serial_no'],

                                                /// sharedPreference
                                              ))));
                                }
                              });
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
                                        Text(
                                          provider.pendDataPro![index]['location_serial_no'], style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                                        ),
                                        Text(
                                          provider.pendDataPro![index]
                                          ['location_name'],
                                          style: AppTextStyle
                                              .font14OpenSansRegularWhiteTextStyle,
                                        ),
                                        Text(
                                          provider.pendDataPro![index]['lec_visit_date'],
                                          style: AppTextStyle
                                              .font14OpenSansRegularWhiteTextStyle,
                                        ),
                                        Text(
                                          provider.pendDataPro![index]
                                          ['application_ref_no'],
                                          style: AppTextStyle
                                              .font14OpenSansRegularWhiteTextStyle,
                                        ),
                                        Text(
                                          provider.pendDataPro![index]
                                          ['applicant_name'],
                                          style: AppTextStyle
                                              .font14OpenSansRegularWhiteTextStyle,
                                        ),
                                        Text(
                                          provider.pendDataPro![index]
                                          ['mobile_no'],
                                          style: AppTextStyle
                                              .font14OpenSansRegularWhiteTextStyle,
                                        ),
                                        Text(
                                          provider.pendDataPro![index]
                                          ['email_id'],
                                          style: AppTextStyle
                                              .font14OpenSansRegularWhiteTextStyle,
                                        ),
                                        Text(
                                          provider.pendDataPro![index][
                                          'application_type'] ==
                                              "0"
                                              ? "Individual"
                                              : provider.pendDataPro![index]
                                          [
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
   Future<bool?> tostCode(){
      return Fluttertoast.showToast(
          msg: "no pending list ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  Future<List?> createAlbumDoc(String lecId, String applicantId, String accessToken) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    String? id = prefs.getString('id');
    String? statusfirst = prefs.getString('status');
    String?  accessToken = prefs.getString('accessToken');

    print('-----id----578---$id');
    print('-----status----579---$statusfirst');
    print('-----accessToken----580---$accessToken');
    print('-----lecid----581---$lecid');
    print('-----applicationId----582---$applicantId');
    showLoader();

    try {

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getLECdoc";
      var getlecDocApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$getlecDocApi'));
      request.body = json.encode({
        "lec_id": lecid,
        "application_id": applicantId,
        "access_token": accessToken
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('--------603---$map');
      print('--------604----${map['status']}');
      print('--------605----${map['IsTokenExpired']}');

      docResponse = "${map['status']}";
      setState(() {

      });
      print('------------------610-----$docResponse');
      var token = "${map['IsTokenExpired']}";
      print('-------token---529---$token');

      if(response.statusCode == 200)
      {
      hideLoader();
      } else {
      hideLoader();
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
      hideLoader();
    } on Error catch (e) {
      debugPrint('General Error: $e');
      hideLoader();
    }
  }

  // Future<AlbumDoc> createAlbumDoc(String lecId, String applicantId, String accessToken) async {
  //
  //
  //   final response = await http.post(
  //     Uri.parse('http://49.50.107.91/hmel/api/getLECdoc'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'lec_id': lecId,
  //       'application_id': applicantId,
  //       'access_token' : accessToken
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print('Responsse----574--${response.statusCode}');
  //     print('Response--297--${response.body}');
  //     var map = jsonDecode(response.body);
  //     print('----------333-----');
  //     print("578---------------"+map['status'].toString());
  //
  //     docResponse= map['status'];
  //     setState(() {
  //       print("377");
  //    docResponse= map['status'];
  //     });
  //     var status = (map['status']);
  //     print('statuse----341-------xx---$status');
  //     print('--389 STATUS--- $docResponse');
  //     return AlbumDoc.fromJson(jsonDecode(response.body));
  //   } else {
  //     var map = jsonDecode(response.body);
  //     print('Response--309--${response.statusCode}');
  //     print('Response----${response.body}');
  //     print("map['status']:-----593-- ${map['status']}");
  //     setState(() {
  //       print("407");
  //       docResponse= map['status'];
  //     });
  //     // If the server did not return a 201 CREATED response,
  //     // then throw an exception.
  //     throw Exception('Failed to create album.');
  //   }
  // }
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
