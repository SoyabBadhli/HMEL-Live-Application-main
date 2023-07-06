import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_data/app_colors.dart';
import '../app_data/app_strings.dart';
import '../app_data/app_text_style.dart';

class DownloadinReportDialog extends StatefulWidget {
  final String? lecId;
  const DownloadinReportDialog({Key? key, this.lecId}) : super(key: key);

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadinReportDialog> {
  Dio dio = Dio();
  double progress = 0.0;

  void startDownloading() async {
    String url =
        'http://49.50.107.91/hmel/admin/lecDocumentZipApp/SG1lbCMxMjM0QGFwcA/${widget.lecId}';

    const String fileName = "Photos.zip";

    String path = await _getFilePath(fileName);

    await dio.download(
      url,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });
        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
      snakbarCode(path);
    });
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

  // snakbarcode
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
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<String> _getFilePath(String filename) async {
    Directory? directory;
    // final dir = await getExternalStorageDirectory();
    // print('----file path----44--${dir?.path}/$filename');
    //
    // return "${dir?.path}/$filename";
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
      print("from 77 =-=---=> $directory");
      //return "${dir.path}/$filename";
      print('----file path----79--${directory.path}/$filename');
      return "${directory.path}/$filename";
    } else {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    print('-----------112--- lecID------${widget.lecId}');
    startDownloading();
    Future.delayed(const Duration(seconds: 2), () {
// Here you can write your code
      toastCode();

      setState(() {
        // Here you can write your code for open new view
      });
    });
  }

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
        ],
      ),
    );
  }

  toastCode() {
    Fluttertoast.showToast(
        msg: "Photo Download",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  ///Photo download

}
