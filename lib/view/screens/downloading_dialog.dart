import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../app_data/app_colors.dart';
import '../app_data/app_strings.dart';
import '../app_data/app_text_style.dart';
import 'package:open_file/open_file.dart';

class DownloadingDialog extends StatefulWidget {
  final String? reportulploadextension;
  const DownloadingDialog({Key? key, this.reportulploadextension})
      : super(key: key);

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;
  String? path;
  String? pdfdownload;
  String? url;

  void startDownloading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    pdfdownload = prefs.getString('pdfname');
    print('----------40-----$pdfdownload');

    print(
        '----------reportdownlodeextention ----20---${widget.reportulploadextension}');
    //String url = 'http://49.50.107.91/hmel/admin/lecDocumentZipApp/SG1lbCMxMjM0QGFwcA/${widget.lecId}';
    // String url = 'http://49.50.107.91/hmel//uploads/lecdocument/pdf/64425c37d68f52023_04_21.pdf';

    print('-------40 xxx -------$pdfdownload');
    url = 'http://49.50.107.91/hmel/uploads/lecdocument/pdf/${pdfdownload}';
    print('---------40----$url');

    // const String fileName = "pickimage.zip";
    //  const String fileName = "report.pdf";
    if (pdfdownload!.isNotEmpty) {
      path = await _getFilePath(url!.split("/").last);
      print('----path-----32---$path');

      await dio.download(
        url!,
        path,
        onReceiveProgress: (recivedBytes, totalBytes) {
          setState(() {
            progress = recivedBytes / totalBytes;
          });
          print(progress);
          print('--------------37------$progress');
        },
        deleteOnError: true,
      ).then((_) {
        Navigator.pop(context);
        print('--------------42------$progress');
        snakbarCode(path!);
      });
    } else {
      snakbarCode("PDF Not available !");
    }
  }

  Future<String> _getFilePath(String filename) async {
    Directory? directory;
    //final dir = await getApplicationDocumentsDirectory();
    // final dir = await getExternalStorageDirectory();
    //  final dir = (await getExternalStorageDirectories(type: StorageDirectory.downloads))?.first;
    if (await _requestPermission(Permission.storage)) {
      directory = await getExternalStorageDirectory();
      String newPath = "";
      print(directory);
      List<String> paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/HMEL";
      directory = Directory(newPath);
      print("from 58 =-=---=> $directory");
      //return "${dir.path}/$filename";
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      print('----file path----48--${directory.path}/$filename');
      return "${directory.path}/$filename";
    } else {
      return '';
    }
  }

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

  // bottomNavigation code
  void snakbarCode(String path) {
    final snackBar = SnackBar(
      content: Text(
        path,
        // AppStrings.txtPleaseFillAllTheParameters,
        style: AppTextStyle.font12OpenSansRegularRedTextStyle,
      ),
      backgroundColor: (AppColors.black),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: AppStrings.txtDismiss,
        textColor: AppColors.red,
        onPressed: () {
          OpenFile.open(
              'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');
          print('---------75---Pdf Open---');
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    localdatabse();

    startDownloading();
    //
    Future.delayed(const Duration(seconds: 0), () {
      // Here you can write your code
      //  toastCode();
      setState(() {
        // Here you can write your code for open new view
      });
    });
  }

  void localdatabse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    pdfdownload = prefs.getString('pdfname');
    print('----------158-----$pdfdownload');
  }
  //
  // void callbackDispatcher() {
  //   Workmanager().executeTask((task, inputData) {
  //     FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
  //     var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  //     var settings = new InitializationSettings(android: android);
  //     flip.initialize(settings);
  //     _showNotificationWithDefaultSound(flip);
  //     return Future.value(true);
  //   });
  // }

  // Future _showNotificationWithDefaultSound(flip) async {
  //   var androidPlatformChannelSpecifics =  AndroidNotificationDetails(
  //       'your channel id',
  //       'your channel name',
  //       'your channel name',
  //       importance: Importance.max,
  //       priority: Priority.high
  //   );
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //   );
  //   await flip.show(0, 'Hmel Lec',
  //       'Your are one step away to connect with GeeksforGeeks',
  //       platformChannelSpecifics, payload: 'Default_Sound'
  //   );
  //
  // }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          // toastCode("Report Download")
        ],
      ),
    );
  }

  toastCode() {
    Fluttertoast.showToast(
        msg: "Report Download",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
