// import 'dart:io';
//
// // import 'package:easy_localization/easy_localization.dart';
// import 'package:file_utils/file_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class OpenPDF extends StatefulWidget {
//   final File file;
//   final String url;
//   final provider;
//
//   const OpenPDF(
//       {Key? key, required this.file, required this.url, this.provider})
//       : super(key: key);
//
//   @override
//   State<OpenPDF> createState() => _OpenPDFState();
// }
//
// class _OpenPDFState extends State<OpenPDF> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool downloading = false;
//   var progress = "";
//   var path = "No Data";
//   var platformVersion = "Unknown";
//   var _onPressed;
//   Directory? externalDir;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   String convertCurrentDateTimeToString() {
//     String formattedDateTime =
//     DateFormat('yyyyMMdd_kkmmss').format(DateTime.now()).toString();
//     return formattedDateTime;
//   }
//
//   Future<void> downloadFile(BuildContext context) async {
//     Dio dio = Dio();
//
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       String dirloc = "";
//       if (Platform.isAndroid) {
//         dirloc = "/sdcard/download/HMEL/";
//       } else {
//         dirloc = (await getApplicationDocumentsDirectory()).path;
//       }
//
//       try {
//         FileUtils.mkdir([dirloc]);
//         await dio.download(
//             widget.url, dirloc + convertCurrentDateTimeToString() + ".pdf",
//             onReceiveProgress: (receivedBytes, totalBytes) {
//               print('here 1');
//               setState(() {
//                 downloading = true;
//                 progress =
//                     ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
//                 print(progress);
//               });
//               print('here 2');
//             });
//       } catch (e) {
//         print('catch catch catch');
//         print(e);
//       }
//
//       setState(() {
//         downloading = false;
//         progress = "Download Completed.";
//         path = dirloc + convertCurrentDateTimeToString() + ".pdf";
//       });
//       print(path);
//       final snackBar = SnackBar(
//         content: Text(
//           "Download success at $path",
//         ),
//         duration: const Duration(seconds: 2),
//         action: SnackBarAction(
//           label: "Dismiss",
//           textColor: Colors.red,
//           onPressed: () {},
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // print('here give alert-->completed');
//     } else {
//       setState(() {
//         progress = "Permission Denied!";
//         _onPressed = () {
//           downloadFile(context);
//         };
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final name = basename(widget.file.path);
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             downloadFile(context);
//             // await _storeFile(widget.url, "sample.pdf", context);
//           },
//           child: Icon(Icons.download),
//         ),
//         body: Column(
//           children: [
//             Text("Here will be PDF view")
//             // Expanded(
//             //   child: PDFView(
//             //     filePath: widget.file.path,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   ///Download PDF
//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }
// }