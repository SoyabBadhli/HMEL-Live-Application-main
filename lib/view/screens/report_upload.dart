import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lec/controller/providers/report_upload_provider.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_dialogs.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/widgets/loader_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/models/lec_report_upload_model.dart';
import '../../model/repository/base_repo.dart';
import '../widgets/custom_buttom.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'lec_pending_list.dart';
import 'login.dart';

class ReportUpload extends StatefulWidget {
  final String? lId,
      lName,
      vDate,
      applicantId,
      applicantname,
      mobile_no,
      email_id,
      type,
      applicationId,
      lec_id,
      location_serial_no;
  const ReportUpload(
      {Key? key,
      this.lId,
      this.lName,
      this.vDate,
      this.applicantId,
      this.applicantname,
      this.mobile_no,
      this.email_id,
      this.type,
      this.applicationId,
      this.lec_id,
      this.location_serial_no})
      : super(key: key);

  @override
  State<ReportUpload> createState() => ReportUploadState();
}

class ReportUploadState extends State<ReportUpload> {
  double? _height;
  File? selectedFile;
  String? fileInBase64;
  Future<LecReportUploadModel>? _futureAlbum;
  var textFieldValue;
  String?  accessToken;
  // String? splitedSelected;
  final myController = TextEditingController();
  var dummyText = 'soyab';
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
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }
  // repo code
  void repoCall()
  {
    print('lec_id---103-------${widget.lec_id}');
    print('applicationId---104....--${widget.applicationId}');
    print('fileInBase64---105.....--${fileInBase64}');// textFieldValue
    print('textFieldValue---106...--${textFieldValue}');
    print('accessToken---107----${accessToken}');


    _futureAlbum = createLecReportUpload("${widget.lec_id}","${widget.applicationId}",fileInBase64==null?"":fileInBase64!,textFieldValue!,'$accessToken'
        );
  }
  // Show Dialog
  // CircularProgressBar
  // CircularProgressBar

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Uploding...")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    
    print('------------locationSerialno----132--${widget.location_serial_no}');
    print('------------locationSerialno----133--${widget.mobile_no}');
    print('------------locationSerialno----134--${widget.email_id}');
    //lId
    print('------------lid----143--${widget.lId}');
    super.initState();
    gettokenfromlacaldb();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp

    ]);
  }
  void gettokenfromlacaldb() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
     accessToken = prefs.getString('accessToken');
     print('------------------153------$accessToken');
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    // _width = MediaQuery.of(context).size.width;
    return Consumer<ReportUploadProvider>(builder: (context, provider, child) {
      return SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                AppStrings.txtLECReportUpload,
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
              ],
              elevation: 0,
            ),
            body: SingleChildScrollView(
              // height: _height,
              // width: _width,
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
                  Container(
                    height: _height! * 0.20,
                    // color: AppColors.white,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: myController,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      cursorColor: AppColors.orange,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10)),
                        focusColor: AppColors.orange,
                        hintText: AppStrings.txtImportantRemarks,
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                      child: Text(
                        AppStrings.txtLECReportUpload,
                        style: AppTextStyle.font12OpenSansBoldOrangeTextStyle,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      provider.splitedSelected == null
                          ? const Text(AppStrings.txtNoDocSelected)
                          : GestureDetector(
                        onTap: (){
                          print('no doc selected ------');
                          },
                            child: Container(
                                width: 150,
                                child: Text(
                                  provider.getSplitedSelected()!,
                                  style: AppTextStyle
                                      .font12OpenSansRegularBlackTextStyle,
                                )),
                          ),

                      CustomButton(
                          buttonColor: AppColors.orange,
                          onClick: () async {
                            // openImageDialog(context);
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              File file = File(result.files.single.path!);
                                              // var fileExtension = file.path.split('.').last;debugPrint(file.path);
                              setState(() {
                                selectedFile = file;
                                // splitedSelected = file.path.split('/').last;
                              });
                              provider.setSplitedSelected(file.path.split('/').last);
                            } else {
                              //
                            }
                          },
                          buttonHeight: 30,
                          buttonWidth: 100,
                          text: Text(
                            AppStrings.txtUpload,
                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                          )),
                    ],
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                  buttonColor: AppColors.orange,
                  onClick: () {
                     setState(() {
                       textFieldValue = myController.text;
                     });
                     if(textFieldValue.isEmpty){
                       snakbarCodeRemark("Please select Remarks");
                     }else if(selectedFile!=null) {
                       var fileExtension = selectedFile?.path.split('.').last;
                       if(fileExtension != "pdf"){
                         snakbarCodeRemark("Upload only pdf file");
                       } else if(textFieldValue !="" && selectedFile !=null){
                         dialogBox();
                       }
                     }else{
                       //dialogBox();
                       snakbarCodeRemark("Please Upload Report");
                     }
                     var fileInByte = selectedFile!.readAsBytesSync();
                     fileInBase64 = base64Encode(fileInByte);
                     print('File base 64----369----$fileInBase64');
                     },
                  text: Text(
                    AppStrings.txtSubmit,
                    style: AppTextStyle.font14OpenSansBoldWhiteTextStyle,
                  )),
            ),
          ),
        ),
      ));
    });
  }
  void dialogBox(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)), //this right here
            child: Container(
              height: 165,
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
                        "Are you sure submit final application ?",
                        style: AppTextStyle.font18OpenSansExtraBoldLightGreenTextStyle,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
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
                              setState(() {
                                if(textFieldValue.isEmpty){
                                  snakbarCodeRemark("Please write important Remarks");

                                }else {
                                  repoCall();
                                  snakbarCodeRemark("Data has been updated successfully");
                                  // navigate to homescreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PendComp()),
                                  );
                                }
                              });
                            },
                            text: Text(
                              "OK",
                              style: AppTextStyle
                                  .font12OpenSansRegularWhiteTextStyle,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
  // sankBar code
  void snakbarCodeRemark(String title){
    final snackBar = SnackBar(
      content: Text(
        "$title",
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

  void snakbarCode(){
    final snackBar = SnackBar(
      content: Text(
        "Please select pdf file",
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
  void snakbardataSubmited(){
    final snackBar = SnackBar(
      content: Text(
        "Data has not been updated successfully",
        // AppStrings.txtPleaseFillAllTheParameters,
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
  }
  //
  // to send data to server

 createLecReportUpload(String lec_id, String application_id,
      String lec_report_upload,String lec_remaks,String token) async {
     showLoader();

    var headers = {
      'X-API-KEY': '123456',
      'Content-Type': 'application/json',
      'Authorization': 'Basic YWRtaW46MTIzNA=='
    };
     var baseURL = BaseRepo().baseurl;
     var endPoint = "/api/LECVisitRemark";
     var lecVisitRemarkApi = "$baseURL$endPoint";

    var request = http.Request('POST', Uri.parse('$lecVisitRemarkApi'));
    request.body = json.encode({
      'lec_id': lec_id,
       'application_id': application_id,
       'lec_report_upload': lec_report_upload,
       'lec_remaks': lec_remaks,
       'access_token': accessToken,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var map;
    var data = await response.stream.bytesToString();

    map = json.decode(data);
    print('--------522---$map');

    print('--------599----${map['status']}');
    print('--------600----${map['IsTokenExpired']}');
    var status = "${map['status']}";
    var token = "${map['IsTokenExpired']}";
    print('-------status---528---$status');
    print('-------token---529---$token');
    if((status == 'false') && (token == 'true')){
      print('-----LogOut----');
      // here you shoudl remove emial

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );

    }else{
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PendComp()));

          }
    // final response = await http.post(
    //   Uri.parse('http://49.50.107.91/hmel/api/LECVisitRemark'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     'lec_id': lec_id,
    //     'application_id': application_id,
    //     'lec_report_upload': lec_report_upload,
    //     'lec_remaks': lec_remaks,
    //     'access_token': accessToken,
    //   }),
    // );


    if (response.statusCode == 200) {
      hideLoader();

    } else {
      hideLoader();
    }
  }
}

