import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:lec/view/app_data/app_dialogs.dart';
import 'package:lec/view/app_data/app_strings.dart';
import 'package:lec/view/app_data/app_text_style.dart';
import 'package:lec/view/screens/pend_comp.dart';
import 'package:lec/view/screens/report_upload.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/providers/pending_photo_provider.dart';
import '../../model/models/modelclass.dart';
import '../../model/repository/base_repo.dart';
import '../../model/repository/repo.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/loader_services.dart';
import 'lec_pending_list.dart';
import 'login.dart';

class PendingPhotoUpload extends StatefulWidget {
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
  const PendingPhotoUpload(
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
      this.location_serial_no
      })
      : super(key: key);

  @override
  State<PendingPhotoUpload> createState() => _PendingPhotoUploadState();
}

class _PendingPhotoUploadState extends State<PendingPhotoUpload> {
  double? _width;
  File? imagefile;
  Future<Album>? _futureAlbum;
  File? pickeGalleryImage;
  String? fileInBase64;
  List<String> imagesListBase64 = [];
  List<File>? imagePath;
  bool locationServiceEnabled = true;
  ImagePicker picker = ImagePicker();
  XFile? image;
  double? lat, long;
  List<File>imagesGaller2 = [];
  File? image3;
  String?  accessToken;
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
    super.initState();
   // getLocation();
    gettokenfromdb();
    print('---------112-----${widget.type}');
    print('----106---${widget.location_serial_no}');
    print('----107---${widget.applicationId}');
    print('----108---${widget.email_id}');
    print('----109---${widget.mobile_no}');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }
  //loder code
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
  //here you get a toke form a login

  void gettokenfromdb()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Read data
    String? id = prefs.getString('id');
    String? statusfirst = prefs.getString('status');
      accessToken = prefs.getString('accessToken');
    print('--------125---$accessToken');
  }
  //  session out api
  Future<Album> uplodeDocumetsSessionOutApi(String lec_id, String application_id,
      List lec_documents,
      double lec_doc_latitude, double lec_doc_longitude,String accessToken) async {
      print('------158-----$lec_id');
      print('------159-----$application_id');
      print('------160-----$lec_documents');
      print('------161-----$lec_doc_latitude');
      print('------162-----$lec_doc_longitude');
      print('------163-----$accessToken');

     showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "/api/LECVisitDocuments";
      var lecVistDocumetsApi = "$baseURL$endPoint";

    final response = await http.post(
      Uri.parse('$lecVistDocumetsApi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'lec_id': lec_id,
        'application_id': application_id,
        'lec_documents': lec_documents.toList(),
        'lec_doc_latitude': lec_doc_latitude,
        'lec_doc_longitude': lec_doc_longitude,
        'accessToken': accessToken
      }),
    );
    if (response.statusCode == 200) {
      hideLoader();
      /// here you should close dialogBox
      print('Response body -------153--${response.statusCode}');
      print('-------------184-----${response.body}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) =>
              ReportUpload(
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

              )),
        ),
      );
      // insert data into model class
      return Album.fromJson(jsonDecode(response.body));
    } else {
      print('Response body -------208--${response.statusCode}');
      print('Response code--124---${response.statusCode}');
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create table.');
    }
  }

  // Repo part here
   uplodeDocumets(String lec_id, String application_id,
      List lec_documents,
      double lec_doc_latitude, double lec_doc_longitude,String accessToken) async {


    print('--------------222----$lec_id');
    print('--------------223----$application_id');
    print('--------------224----$lec_documents');
    print('--------------225----$lec_doc_latitude');
    print('--------------226----$lec_doc_longitude');
    print('--------------227----$accessToken');
    showLoader();

    // loder Code

    var headers = {
      'X-API-KEY': '123456',
      'Content-Type': 'application/json',
      'Authorization': 'Basic YWRtaW46MTIzNA=='
    };
    var baseURL = BaseRepo().baseurl;
    var endPoint = "/api/LECVisitDocuments";
    var lecVisitDocmentsApi = "$baseURL$endPoint";
    var request = http.Request('POST', Uri.parse('$lecVisitDocmentsApi'));
    request.body = json.encode({
      "lec_id": lec_id,
      "application_id": application_id,
      "lec_documents": lec_documents.toList(),
      "lec_doc_latitude": lec_doc_latitude,
      "lec_doc_longitude": lec_doc_longitude,
      "lec_document_id": "",
      "access_token": accessToken

    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var map;
    var data = await response.stream.bytesToString();
    map = json.decode(data);
    print('--------210---$map');

    print('--------215----${map['status']}');
    print('--------216----${map['IsTokenExpired']}');
    print('--------217----${map['message']}');
    var status = "${map['status']}";
    var token = "${map['IsTokenExpired']}";
    var msg = "${map['IsTokenExpired']}";
    print('-------status---219---$status');
    print('-------token---220---$token');

    if((status == 'false') && (token == 'true')){
      hideLoader();
      print('-----LogOut----');

      // here you shoudl remove emial
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );

    } else {
      // loder close
      hideLoader();

      print('-------------234------next page----');
      if(status == 'true') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                ReportUpload(
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
                  location_serial_no: widget.location_serial_no

                )),
          ),
        );
      } else {
        //
        print('-----------256--$msg');
      }
      print('-----not logout------');
    }


    // final response = await http.post(
    //   Uri.parse('http://49.50.107.91/hmel/api/LECVisitDocuments'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     'lec_id': lec_id,
    //     'application_id': application_id,
    //     'lec_documents': lec_documents.toList(),
    //     'lec_doc_latitude': lec_doc_latitude,
    //     'lec_doc_longitude': lec_doc_longitude,
    //     'accessToken': accessToken
    //   }),
    //
    // );
    //
    // if (response.statusCode == 200) {
    //   /// here you should close dialogBox
    //   print('Response body -------210--${response.statusCode}');
    //   print('Response body ---212--${response.body}');
    //
    //
    //    var status = 'false';
    //    var IsTokenExpired = 'true';
    //    if((status == 'false') && (IsTokenExpired == 'true')){
    //      Navigator.push(
    //        context,
    //        MaterialPageRoute(builder: (context) => const Login()),
    //      );
    //      print('----------Logout');
    //    }
    //
    //
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: ((context) =>
    //           ReportUpload(
    //             lId: widget.lId,
    //             lName: widget.lName,
    //             vDate: widget.vDate,
    //             applicantId: widget.applicantId,
    //             applicantname: widget.applicantname,
    //             mobile_no: widget.mobile_no,
    //             email_id: widget.email_id,
    //             type: widget.type,
    //             applicationId: widget.applicationId,
    //             lec_id: widget.lec_id,
    //
    //           )),
    //     ),
    //   );
    //   // insert data into model class
    //   return Album.fromJson(jsonDecode(response.body));
    // } else {
    //   print('Response code--124---${response.statusCode}');
    //   // If the server did not return a 201 CREATED response,
    //   // then throw an exception.
    //   throw Exception('Failed to create table.');
    // }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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
  Widget build(BuildContext context) {
    _width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(child: Consumer<PendingPhotoProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            title: Text(
              AppStrings.txtLECPhotoUpload,
              style: AppTextStyle.font12OpenSansBoldOrangeTextStyle,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  //Navigator.pop(context);
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
                    child: Image.asset("assets/images/hmel_logo.png")),)
            ],
            elevation: 0,
          ),
          body:
          // Consumer<PendingPhotoProvider>(builder: (context, provider, child) {
          //   return
          SizedBox(
            // height: _height,
            width: _width,
            child: Column(
              children: [
                Card(
                  // margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  elevation: 8,
                  color: AppColors.lightGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
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
                //photoUpload(provider),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: CustomButton(
                    buttonColor: AppColors.orange,
                    onClick: () {
                      permisssionChecker();
                      // getLocation();
                      //pickImageCamera();
                    },
                    text: Text(
                      AppStrings.txtUploadphoto,
                      style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                    ),
                    buttonHeight: 45,
                    buttonWidth: 150,
                  ),
                ),
                const Divider(),
                // gridView Code
                SingleChildScrollView(child: gallerycode())
              ],
            ),
          ),

          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
            child: CustomButton(
                buttonColor: AppColors.orange,
                onClick: () {
                  //
                  // if((imagesGaller2.length < ) && (imagesGaller2.length >= 10)){
                  //   snakbarCode();
                  //   print('PHOTO 5 TO 10-----');
                  // }
                  // else if(_futureAlbum == null){
                  //   print(' NOT  PHOTO 5 TO 10-----');
                  //  // _asyncConfirmDialog(context);
                  // }

                  if (imagesGaller2.length < 5) {
                    snakbarCode();
                  } else if (_futureAlbum == null) {
                    _asyncConfirmDialog(context);
                  } else {
                  }

                  },
                text: Text(
                  AppStrings.txtSubmit,
                  style: AppTextStyle.font14OpenSansBoldWhiteTextStyle,
                )),
          ),
          // ));
        ),
      );
    }));
  }
  void permisssionChecker() async {
    var status = await Permission.location.status;
    if(status.isDenied){
      print("Permission is denined.");
     // requestLocationPermission();
      getLocation();
    }else if(status.isGranted){
      print("Permission is already granted.");
      getLocation();
      pickImageCamera();

    }else if(status.isPermanentlyDenied){
      print("Permission is permanently denied");
    //  requestLocationPermission();
      getLocation();
    }else if(status.isRestricted){
      print("Permission is OS restricted.");
      //requestLocationPermission();
      getLocation();
    }
  }
  // dialog box
  void _asyncConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: Text('Document upload'),
          content: const Text('Do you want to upload photos ?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('No'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontStyle: FontStyle.normal),
              ),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
            ElevatedButton(
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontStyle: FontStyle.normal),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
               // _onLoading();
                  repoCall();
                  buildFutureBuilder();

               // Navigator.of(context).pop();


                print('Yes....');
              },
            ),
          ],
        );
      },
    );
  }


  // snakbarCode
  void snakbarCode() {
    final snackBar = SnackBar(
      content: Text(
        "Please select at least 5  images",
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

  // repoCode
  void repoCall() {

    print('-----------697----$lat');
    print('-----------698----$long');
    print('lec_id------699--${widget.lec_id}');
    print('applicationId---700--${widget.applicationId}');
    print('imagesListBase64------701--$imagesListBase64');



    _futureAlbum = uplodeDocumets(
        "${widget.lec_id}", "${widget.applicationId}", imagesListBase64,lat!,
        long!,accessToken!);
  }
  // Get a response from api
  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final appId = '${snapshot.data!.lec_id}';
          print('applicatin Id....378.---->$appId');
          print("Application id ---376" + snapshot.data!.application_id);
          //return Text(snapshot.data!.application_id);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget photoUpload(PendingPhotoProvider pendingPhotoProvider) {
    return Expanded(
      // height: _height! * .55,
      // padding: EdgeInsets.only(bottom: 20),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: pendingPhotoProvider.photos.length,
          itemBuilder: ((context, index) {
            return ListTile(
              leading: Text(pendingPhotoProvider.photos[index]['name']),
              title: Container(
                height: 50,
                width: 30,
                color: AppColors.appGrey.withOpacity(0.9),
                padding: const EdgeInsets.all(10),
                child: Text(
                  pendingPhotoProvider.photos[index]['image_name'].toString(),
                  style: AppTextStyle.font8OpenSansRegularBlackTextStyle,
                ),
              ),
              trailing: CustomButton(
                buttonColor: AppColors.orange,
                onClick: () {
                  // getCurrentLocation();
                 // getLocation();
                  openBottomSheet(context, index, pendingPhotoProvider);
                },
                text: Text(
                  AppStrings.txtUpload,
                  style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                ),
                buttonHeight: 30,
                buttonWidth: 100,
              ),
            );
          })),
    );
  }

  void pickImageCamera() async {
    dynamic imagedata = await picker.pickImage(source: ImageSource.camera,imageQuality: 35);
    setState(() {
      //update UI
      File fileName = File(imagedata.path);
      print('IMage file size ---511---${fileName.lengthSync()}');
      imagesGaller2.add(fileName);

      print('Gallery image 2----503..xxx->$imagesGaller2');

      List<int> fileInByte = fileName.readAsBytesSync();
      fileInBase64 = base64Encode(fileInByte);
      print('Base64file ---433---$fileInBase64');
      imagesListBase64.add(fileInBase64!);
      print('imagesListBase64 ----389..xxx->$imagesListBase64');
    });
  }

  Widget gallerycode() {
    return Container(
        width: 400.0,
        height: 320.0,
        padding: EdgeInsets.only(left: 6, right: 6),
        child: GridView.count(
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          // childAspectRatio: 16/14,
          children: List.generate(imagesGaller2.length, (index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              contentPadding: const EdgeInsets.all(6.0),
                              content: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 200,
                                    height: 200,
                                    child:
                                    Image.file(imagesGaller2[index] as File,
                                      fit: BoxFit.cover,),
                                  ),
                                  Positioned(
                                    top: 0.0,
                                    right: 0.0,
                                    child: GestureDetector(
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        child: Icon(Icons.close, size: 35,
                                            color: Colors.red),
                                      ),
                                      onTap: () {
                                        print(imagesGaller2.length);
                                        print("Index value-------555----$index");
                                        // imagesGaller2.removeAt(index);
                                        print(imagesGaller2.length);

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ));
                  },
                    child: Container(
                      height: 95,
                      width: 100,
                    // elevation: 1,
                      child: Image.file(
                        imagesGaller2[index] as File,
                        fit: BoxFit.cover,
                      ),

                 ),
                ),
                CustomButton(
                  buttonColor: AppColors.orange,
                  onClick: (){
                    print("index $index");
                    setState(() {
                      imagesGaller2.removeAt(index);
                    });
                  },
                  buttonHeight: 30,
                  buttonWidth: 100,
                  text: Text("Remove",
                    style: AppTextStyle.font14OpenSansBoldWhiteTextStyle,),
                ),
              ],
            );
          }),
        ));
  }

  Future openBottomSheet(BuildContext context, int index,
      PendingPhotoProvider provider) {
    // function arg :   BuildContext context, int index, PendingPhotoProvider provider
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text(AppStrings.txtPleaseChooseMode),
                CustomButton(
                    onClick: () {
                      pickImage(ImageSource.camera, index, provider);
                    },
                    buttonHeight: 40,
                    text: const Text(AppStrings.txtCamera)),
                CustomButton(
                    onClick: () {
                      pickImage(ImageSource.gallery, index, provider);
                    },
                    buttonHeight: 40,
                    text: const Text(AppStrings.txtGallery)),
              ],
            ),
          ),
        );
      },
    );
  }

  // pick image popup
  void pickupGridView() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  //Image.file(imagesGaller2[index] as File)
                  Container(
                    height: 200,
                    width: 200,
                    child:
                    //Image.file(imagesGaller2[index] as File)
                    Image.network(
                      'https://www.kindpng.com/picc/m/355-3557482_flutter-logo-png-transparent-png.png',
                    ),
                  ),
                  Positioned(
                    top: 5.0,
                    right: 5.0,
                    child: GestureDetector(
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Icon(Icons.close, size: 25, color: Colors.red),
                      ),
                      onTap: () {
                        print('Image is close---');
                        //TODO decider ce que je fais pour ici
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  Future pickImage(ImageSource src, int index,
      PendingPhotoProvider provider) async {
    try {
      final image = await ImagePicker().pickImage(source: src);
      if (image == null) return;
      imagefile = File(image.path);

      print('Pick image---381---$imagefile');
      print('--------382------');
      if (imagefile != null) {
        // imagePath.addAll(imagefile);
        print('List image ---384----$imagefile');
        //
        //imagePath!.add(imagefile!);
        // imagePath?.add(imagefile!.path);

        print('List image ---386----$imagePath');
        print('List image ---387----$imagefile');
      } else {
        print('imagefile  is null----------384---');
      }
      // final imageTemp = File(image.path);
      print('image path---------383 ${imagePath}');
      provider.setImageBase64(index, imagefile!.path);
      // to insert image into provider
      //provider.setImageBase64(index, imageTemp.toString());
      // photos[index]['image_base64'] = imageTemp.toString();
      if (src == ImageSource.camera) {
        // set image name into the provider
        provider.setImageName(index, image.path
            .split("-")
            .last);
        // photos[index]['image_name'] = image.path.split("-").last;
      } else {
        provider.setImageName(index, image.path
            .split("/")
            .last);
        // photos[index]['image_name'] = image.path.split("/").last;
      }
      // setState(() {});
      Navigator.pop(context);
      // setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }
  // locationc code
  Future<void> requestLocationPermission() async {

    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      AppDialogs.openLocationDialog(context);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    lat = position.latitude;
    long = position.longitude;
    print('-----------1051----$lat');
    print('-----------1052----$long');

    setState(() {
    });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }

  // multipartProdecudre() async {
  //   //showLoader();
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('http://49.50.107.91/hmel/api/LECVisitDocuments'))
  //   //for token
  //   //..headers.addAll({"Authorization": ""})
  //   // TextFields
  //     ..fields['lec_id'] = '78912,'
  //     ..fields['application_id'] = '96'
  //     ..fields['lec_doc_latitude'] = '12323423'
  //     ..fields['lec_doc_longitude'] = '12323423';
  //   print('ImagePath-------462-----$imagefile');
  //
  //   // TO send data with a list
  //   List<String> manageTagModel = [
  //     '/data/user/0/com.example.lec/cache/image_picker1193111876058191933.jpg',
  //     '/data/user/0/com.example.lec/cache/image_picker1193111876058191933.jpg',
  //     '/data/user/0/com.example.lec/cache/image_picker1193111876058191933.jpg'
  //   ];
  //   print('----List Data---467----$manageTagModel');
  //   for (String item in manageTagModel) {
  //     request.files.add(http.MultipartFile.fromString('lec_documents', item));
  //     print('item --470-inserted--$item');
  //   }
  //   try {
  //     // for completing the request
  //     var response = await request.send();
  //     //for getting and decoding the response int json format
  //     var responsed = await http.Response.fromStream(response);
  //     final responseData = json.decode(responsed.body);
  //     // alreadydataonserver = responseData['data'];
  //     if (response.statusCode == 200) {
  //       // hideLoader();
  //       //clearText
  //       print('-------response--->476--->${responseData}');
  //       print('status code-------------477---->${response.statusCode}');
  //     } else if (response.statusCode == 403) {
  //       print('dublicate entry-------------406---->${response.statusCode}');
  //     } else {
  //       print('status code-------------408---->${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print("error $e");
  //   }
  // }
}
