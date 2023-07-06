import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lec/controller/providers/params_provider.dart';
import 'package:lec/model/models/fetch_params_model.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/screens/pending_photo_upload.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/repository/base_repo.dart';
import '../app_data/app_strings.dart';
import '../widgets/custom_buttom.dart';
import 'package:http/http.dart' as http;
import '../widgets/loader_services.dart';

class LecParams extends StatefulWidget {
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
  const LecParams(
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
      this.location_serial_no
      })
      : super(key: key);

  @override
  State<LecParams> createState() => _LecParamsState();
}

class _LecParamsState extends State<LecParams> {
  double? _width;
  String? type_2;
  ParamsProvider? provider;
  FetchParamsModel? model;
  bool? hasParamsData;
  String? accessToken;
  String? gender;
  String? lecParameterId;
  String? lec_parameter_id;
  //
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
    getFetchDataFromaLocaldatabase();
    super.initState();
    provider = Provider.of<ParamsProvider>(context, listen: false);
    String? parameterId = provider!.lecParameterId;
    print('----------93----${widget.location_serial_no}');
    print('parameterId-------72---$parameterId');
    print('----99------------> lec id: ${widget.lec_id}",applicationId: "${widget.applicationId}');
    //LODER DELAY
    Future.delayed(const Duration(milliseconds: 100), () {
      //_onLoading();
      getFetchDataFromaLocaldatabase();
      getLecParametersApi("${widget.lec_id}","${widget.applicationId}",accessToken!);
      provider!.fetchParamsInProvider("${widget.lec_id}","${widget.applicationId}",accessToken!);

      setState(() {});
    });
    // Future.delayed(Duration(milliseconds: 500), () {
    //   if (provider!.fpmap['status'] == false) {
    //     print('Cear method call --->${provider!.fpmap['status']}');
    //     provider!.clearParams();
    //   }
    // });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }
  // gettokenfrom the local database
  getFetchDataFromaLocaldatabase() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    accessToken = prefs.getString('accessToken');
    print('---123-  token--$accessToken');
  }
  // getLecParameters Api: This api is used to get data in a lecParameter Screen
  getLecParametersApi(
      String lec_id,
      String application_id,
      String access_token
      ) async {
    try {
      showLoader();
      // here we now what is data is going
      print('----lecID------133---$lec_id');
      print('----applicationId-----134---$application_id');
      print('----accessToken-----135----$accessToken');

      var headers = {
        'x-api-key': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/getLECParameters";
      var getlecParameterApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$getlecParameterApi'));
      request.body = json.encode({
        "lec_id": lec_id,
        "application_id": application_id,
        "access_token": access_token,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);

      print('--------160---$map');
      print('--------156----${map['status']}');
      print('--------157----${map['message']}');
      print('--------158----${map['message']}');

      // if((status == 'false') && (token == 'true')){
      //   print('-----LogOut----');
      //   // here you shoudl remove emial
      //
      // }else{
      //   print('-----Non Logout----');
      // }

      if(response.statusCode == 200)
      {
        hideLoader();
        print('-------Records has been fetch successfully.------');
      } else {
        print('-------Records has not been fetch successfully.-----');
        hideLoader();
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
      hideLoader();
    }  on Error catch (e) {
      debugPrint('General Error: $e');
      hideLoader();
    }
  }

  // loader code
  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 10.0),
              Text("Loading...",
                  style: AppTextStyle.font12OpenSansBoldOrangeTextStyle),
            ],
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); //pop dialog
    });
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
              AppStrings.txtLECParameters,
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
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PendComp()),
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset("assets/images/hmel_logo.png")),)
             /* Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset("assets/images/hmel_logo.png")),*/
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
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "${widget.lId}",
                                  style: AppTextStyle
                                      .font14OpenSansRegularWhiteTextStyle,
                                ),
                                Text(
                                  "${widget.location_serial_no}",
                                  style: AppTextStyle
                                      .font14OpenSansRegularWhiteTextStyle,
                                ),
                              ],
                            ),*/
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
                radioOption(provider)

                // paramWidget()
              ],
            ),
          ),
          // }),
          bottomNavigationBar: Container(
              padding:
                  const EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 15),
              child: CustomButton(
                  buttonColor: AppColors.orange,
                  onClick: (() {
                    if (provider.selectedParams[0]["selected_val"] == "" ||
                        provider.selectedParams[1]["selected_val"] == "" ||
                        provider.selectedParams[2]["selected_val"] == "" ||
                        provider.selectedParams[3]["selected_val"] == "" ||
                        provider.selectedParams[4]["selected_val"] == "" ||
                        provider.selectedParams[5]["selected_val"] == "" ||
                        provider.selectedParams[6]["selected_val"] == "" ||
                        provider.selectedParams[7]["selected_val"] == "" ||
                        provider.selectedParams[8]["selected_val"] == "" ||
                        provider.selectedParams[9]["selected_val"] == "" ||
                        provider.selectedParams[10]["selected_val"] == "" ||
                        provider.selectedParams[11]["selected_val"] == "") {
                      // snakbar code
                      final snackBar = SnackBar(
                        content: Text(
                          AppStrings.txtPleaseFillAllTheParameters,
                          style: AppTextStyle.font12OpenSansRegularRedTextStyle,
                        ),
                        backgroundColor: (AppColors.black),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: AppStrings.txtDismiss,
                          textColor: AppColors.red,
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                   // if(lecParameterId != null){
                   //       print('-------Call GetLec Parameter...');
                   //       // data is fetch
                   //       //
                   //       //lecParameterGetApi();
                   //       lecParameterGetApi(
                   //         widget.lec_id!,
                   //         widget.applicationId!,
                   //         provider.selectedParams[0]["selected_val"].toString(),
                   //         provider.selectedParams[1]["selected_val"].toString(),
                   //         provider.selectedParams[2]["selected_val"].toString(),
                   //         provider.selectedParams[3]["selected_val"].toString(),
                   //         provider.selectedParams[4]["selected_val"].toString(),
                   //         provider.selectedParams[5]["selected_val"].toString(),
                   //         provider.selectedParams[6]["selected_val"].toString(),
                   //         provider.selectedParams[7]["selected_val"].toString(),
                   //         provider.selectedParams[8]["selected_val"].toString(),
                   //         provider.selectedParams[9]["selected_val"].toString(),
                   //         provider.selectedParams[10]["selected_val"].toString(),
                   //         provider.selectedParams[11]["selected_val"].toString(),
                   //         lecParameterId.toString(),
                   //       );
                   //     }
                   //     else{
                   //       lecParameterPostApi(
                   //             widget.lec_id!,
                   //            widget.applicationId!,
                   //           provider.selectedParams[0]["selected_val"].toString(),
                   //           provider.selectedParams[1]["selected_val"].toString(),
                   //           provider.selectedParams[2]["selected_val"].toString(),
                   //         provider.selectedParams[3]["selected_val"].toString(),
                   //         provider.selectedParams[4]["selected_val"].toString(),
                   //         provider.selectedParams[5]["selected_val"].toString(),
                   //         provider.selectedParams[6]["selected_val"].toString(),
                   //         provider.selectedParams[7]["selected_val"].toString(),
                   //         provider.selectedParams[8]["selected_val"].toString(),
                   //         provider.selectedParams[9]["selected_val"].toString(),
                   //         provider.selectedParams[10]["selected_val"].toString(),
                   //         provider.selectedParams[11]["selected_val"].toString(),
                   //         lecParameterId.toString(),
                   //       );
                   //       print('-------Lec Parameter Post Api...');
                   //       // Here you should some parameter with api on the server
                   //
                   //     }
                       provider.fpmap['status'] == true
                          ? provider.updateParamsInProvider(
                              widget.lec_id!,
                              widget.applicationId!,
                              provider.selectedParams[0]["selected_val"].toString(),
                              provider.selectedParams[1]["selected_val"].toString(),
                              provider.selectedParams[2]["selected_val"].toString(),
                              provider.selectedParams[3]["selected_val"]
                                  .toString(),
                              provider.selectedParams[4]["selected_val"]
                                  .toString(),
                              provider.selectedParams[5]["selected_val"]
                                  .toString(),
                              provider.selectedParams[6]["selected_val"]
                                  .toString(),
                              provider.selectedParams[7]["selected_val"]
                                  .toString(),
                              provider.selectedParams[8]["selected_val"]
                                  .toString(),
                              provider.selectedParams[9]["selected_val"]
                                  .toString(),
                              provider.selectedParams[10]["selected_val"]
                                  .toString(),
                              provider.selectedParams[11]["selected_val"]
                                  .toString(),

                          provider.fpmap['data'][0]['lec_parameter_id'])

                          : provider.loadRepoInProvider(
                              widget.lec_id!,
                              widget.applicationId!,
                          accessToken!,
                              provider.selectedParams[0]["selected_val"]
                                  .toString(),
                              provider.selectedParams[1]["selected_val"]
                                  .toString(),
                              provider.selectedParams[2]["selected_val"]
                                  .toString(),
                              provider.selectedParams[3]["selected_val"]
                                  .toString(),
                              provider.selectedParams[4]["selected_val"]
                                  .toString(),
                              provider.selectedParams[5]["selected_val"]
                                  .toString(),
                              provider.selectedParams[6]["selected_val"]
                                  .toString(),
                              provider.selectedParams[7]["selected_val"]
                                  .toString(),
                              provider.selectedParams[8]["selected_val"]
                                  .toString(),
                              provider.selectedParams[9]["selected_val"]
                                  .toString(),
                              provider.selectedParams[10]["selected_val"]
                                  .toString(),
                              provider.selectedParams[11]["selected_val"]
                                  .toString(),
                          provider.fpmap['data'][0]['lec_parameter_id']

                      );
                       for (int i = 0; i < provider.selectedParams.length; i++) {
                        provider.selectedParams[i]["selected_val"] = "";
                      }

                     snakbarCode();
                      Timer(Duration(seconds: 1), () {
                        print("Yeah, this line is printed after 3 seconds");


                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => PendingPhotoUpload(
                                    lId: widget.lId,
                                    lName: widget.lName,
                                    vDate: widget.vDate,
                                    applicantId: widget.applicantId,
                                    applicantname: widget.applicantname,
                                    mobile_no: widget.mobile_no,
                                    email_id: widget.email_id,
                                    type: widget.type,
                                    applicationId: widget.applicationId,
                                    lec_id: widget.lec_id,
                                    location_serial_no: widget.location_serial_no,
                                   ))));
                      });
                    }
                   // print('----62--> lec id: ${widget.lec_id}",applicationId: "${widget.applicationId}');
                    // provider.selectedParams.clear();
                  }),
                  text: Text(
                    AppStrings.txtNext,
                    style: AppTextStyle.font14OpenSansBoldWhiteTextStyle,
                  ))),
        ),
      );
    }));
  }
  // data POst and update
  lecParameterGetApi(
      String lec_id,
      String application_id,
      String earth_filling,
      String earth_rock_cutting,
      String LT_O_H_Line,
      String oh_tel_line,
      String trees,
      String proximity_to_culvert,
      String soil_type,
      String availability_power,
      String availability_water,
      String visibility_from_Road,
      String no_presence_divider,
      String outside_octroi_limits,
      String lec_parameter_id,
      ) async {
    try {
      // here we now what is data is going
      showLoader();
      print('----lecID-----${widget.lec_id}');
      print('----applicationId-----${widget.applicationId}');
      print('----earthFilling-----${ provider?.selectedParams[0]["selected_val"].toString()}');
      print('----earthrock-----${provider?.selectedParams[1]["selected_val"].toString()}');
      print('----LTohLine-----${provider?.selectedParams[2]["selected_val"].toString()}');

      var headers = {
        'x-api-key': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/LECParameters";
      var lecParaMeterApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$lecParaMeterApi'));
      request.body = json.encode({
        "lec_id": lec_id,
        "application_id": application_id,
        "earth_filling": earth_filling,
        "earth_rock_cutting": earth_rock_cutting,
        "LT_O_H_Line": LT_O_H_Line,
        "oh_tel_line": oh_tel_line,
        "trees": trees,
        "proximity_to_culvert": proximity_to_culvert,
        "soil_type": soil_type,
        "availability_power": availability_power,
        "availability_water": availability_water,
        "visibility_from_Road": visibility_from_Road,
        "no_presence_divider": no_presence_divider,
        "outside_octroi_limits": outside_octroi_limits,
        "lec_parameter_id": lec_parameter_id,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('--------557---$map');
      print('--------558----${map['status']}');
      var status = "${map['status']}";
      print('-------status---528---$status');

      // if((status == 'false') && (token == 'true')){
      //   print('-----LogOut----');
      //   // here you shoudl remove emial
      //
      // }else{
      //   print('-----Non Logout----');
      // }

      if(response.statusCode == 200)
      {
        hideLoader();
        print('-------Api call-Succeful------');
      } else {
        print('-------Api call faild-----');
        hideLoader();
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
      hideLoader();
    }  on Error catch (e) {
      debugPrint('General Error: $e');
      hideLoader();
    }
  }
  // GetLecPostApiCODE
  lecParameterPostApi(
      String lec_id,
      String application_id,
      String earth_filling,
      String earth_rock_cutting,
      String LT_O_H_Line,
      String oh_tel_line,
      String trees,
      String proximity_to_culvert,
      String soil_type,
      String availability_power,
      String availability_water,
      String visibility_from_Road,
      String no_presence_divider,
      String outside_octroi_limits,
      String lec_parameter_id,
      ) async {
    try {
      showLoader();
      // here we now what is data is going
    print('----lecID---  625--${widget.lec_id}');
    print('----applicationId--626---${widget.applicationId}');
    print('----earthFilling-----${ provider?.selectedParams[0]["selected_val"].toString()}');
    print('----earthrock-----${provider?.selectedParams[1]["selected_val"].toString()}');
    print('----LTohLine-----${provider?.selectedParams[2]["selected_val"].toString()}');

      var headers = {
        'x-api-key': '123456',
        'Content-Type': 'application/json',
        'Authorization': 'Basic YWRtaW46MTIzNA=='
      };
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/LECParameters";
      var lecParaMeterApi = "$baseURL$endPoint";
      var request = http.Request('POST', Uri.parse('$lecParaMeterApi'));
      request.body = json.encode({
        "lec_id": lec_id,
        "application_id": application_id,
        "earth_filling": earth_filling,
        "earth_rock_cutting": earth_rock_cutting,
        "LT_O_H_Line": LT_O_H_Line,
        "oh_tel_line": oh_tel_line,
        "trees": trees,
        "proximity_to_culvert": proximity_to_culvert,
        "soil_type": soil_type,
        "availability_power": availability_power,
        "availability_water": availability_water,
        "visibility_from_Road": visibility_from_Road,
        "no_presence_divider": no_presence_divider,
        "outside_octroi_limits": outside_octroi_limits,
        "lec_parameter_id": lec_parameter_id,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('--------660---$map');
      print('--------661----${map['status']}');
      var status = "${map['status']}";
      print('-------status---663---$status');

      // if((status == 'false') && (token == 'true')){
      //   print('-----LogOut----');
      //   // here you shoudl remove emial
      //
      // }else{
      //   print('-----Non Logout----');
      // }

      if(response.statusCode == 200)
      {
        hideLoader();
      print('-------Api call-Succeful------');
      } else {
        print('-------Api call faild-----');
        hideLoader();
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout Error: $e');
      hideLoader();
    }  on Error catch (e) {
      debugPrint('General Error: $e');
      hideLoader();
    }
  }

  void snakbarCode(){
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
            children: [
              Text(
                AppStrings.txtYes,
                style: AppTextStyle.font14OpenSansBoldLightGreenTextStyle,
              ),
              Text(
                AppStrings.txtNo,
                style: AppTextStyle.font14OpenSansBoldLightGreenTextStyle,
              ),
              Text(
                AppStrings.txtNA,
                style: AppTextStyle.font14OpenSansBoldLightGreenTextStyle,
              ),
            ],
          ),
        )
      ],
    );
  }

  // radioOption

Widget radioOption(ParamsProvider provider) {
    return Expanded(
      child: ListView.builder(
          itemCount: provider.selectedParams.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // no change
                SizedBox(
                    width: _width! * 0.45,
                    child: Text(provider.selectedParams[index]["p_name"])),
                Container(
                  width: _width! * 0.45,
                  padding: const EdgeInsets.only(left: 0, right: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Radio(
                              value: provider.paramVal[0],
                              activeColor: AppColors.orange,
                              groupValue: provider.selectedParams[index]["selected_val"],
                              onChanged: (value) {
                                setState(() {
                                  provider.selectedParams[index]["selected_val"] = value.toString();
                                  debugPrint(
                                      "${provider.selectedParams[index]["p_name"]} : ${provider.selectedParams[index]["selected_val"]}");
                                });
                              }),
                          Radio(
                              value: provider.paramVal[1],
                              activeColor: AppColors.orange,
                              groupValue: provider.selectedParams[index]["selected_val"],
                              onChanged: (value) {
                                setState(() {
                                  provider.selectedParams[index]["selected_val"] =
                                      value.toString();
                                });
                                debugPrint(
                                    "${provider.selectedParams[index]["p_name"]} : ${provider.selectedParams[index]["selected_val"]}");
                              }),
                          Radio(
                              value: provider.paramVal[2],
                              activeColor: AppColors.orange,
                              groupValue: provider.selectedParams[index]["selected_val"],
                              onChanged: (value) {
                                setState(() {
                                  provider.selectedParams[index]["selected_val"] = value.toString();
                                });
                                debugPrint(
                                    "${provider.selectedParams[index]["p_name"]} : ${provider.selectedParams[index]["selected_val"]}");
                              }),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
