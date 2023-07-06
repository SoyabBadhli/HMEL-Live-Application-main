import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lec/controller/providers/pending_provider.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/screens/report_upload.dart';
import 'package:lec/view/widgets/card_shimmer.dart';
import 'package:lec/view/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/repository/base_repo.dart';
import 'lec_params.dart';

class LecPendingList2 extends StatefulWidget {
  const LecPendingList2({Key? key}) : super(key: key);

  @override
  State<LecPendingList2> createState() => _LecPendingList2State();
}
class _LecPendingList2State extends State<LecPendingList2> {
  String? lecid, applicationid,applicantId;

  double? _height, _width;
  int? typeValue;
  String? type;
  String? appType;
  String? lectype;
  Future<AlbumDoc>? _futureAlbum;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PendingProvider pendingProvider;

  //late DocumentUplodeTestingProvider documentestprovider;
  var data;
  var docResponse;
  bool? docResponse2;
  //var documetuplodetesting;
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
    super.initState();
    pendingProvider = Provider.of<PendingProvider>(context, listen: false);
    data = pendingProvider.loadRepoInProvider();
    debugPrint("PendingProvider...xxx-->35: $data");
    SystemChrome.setPreferredOrientations(
     [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
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
                              print('lecid ----94-->$lecid');
                              print('application_id ----95-->$applicationid');
                              createAlbumDoc('$lecid','$applicationid');

                              Future.delayed(Duration(seconds: 3),(){
                                print("docResponse after delay------: $docResponse");

                                if(docResponse==true){
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
                                          provider.pendDataPro![index]
                                          ['lec_visit_date'],
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
  Future<AlbumDoc> createAlbumDoc(String lecId, String applicantId) async {
    var baseURL = BaseRepo().baseurl;
    var endPoint = "/api/getLECdoc";
    var getLecDocApi = "$baseURL$endPoint";
    final response = await http.post(
      Uri.parse('$getLecDocApi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'lec_id': lecId,
        'application_id': applicantId,
      }),
    );
    if (response.statusCode == 200) {
      print('Response----${response.statusCode}');
      print('Response--297--${response.body}');
      var map = jsonDecode(response.body);
      print('----------333-----');
      print("334------"+map['status'].toString());

      docResponse= map['status'];
      setState(() {
        print("377");
     docResponse= map['status'];
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
        docResponse= map['status'];
      });
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
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
