import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../backend/firebase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:open_file/open_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'pdfList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Widget build(BuildContext context) {
    Server _server = Provider.of<Server>(context);
    return MaterialApp(
      navigatorKey: Get.key,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GS SDK Flutter Demo'),
        ),
        body: PdfList(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              child: Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                FlutterGeniusScan.scanWithConfiguration({
                  'source': 'camera',
                  'multiPage': true,
                }).then((result) async {
                  Get.dialog(AlertDialog(
                    content: CircularProgressIndicator(),
                  ));
                  String pdfUrl = result['pdfUrl'];
                  File _file =
                      File.fromUri(Uri(path: pdfUrl.replaceAll("file://", '')));
                  DateTime now = new DateTime.now();
                  String time = now.toString();
                  int i = time.indexOf('.');
                  time = time.substring(0, i);
                  String _url = await _server.uploadFile(_file, now.toString());
                  await _server.createData('pdfs',
                      {'name': "Scan" + time, 'url': _url, 'created on': time});
                  Get.back();
                  // OpenFile.open(pdfUrl.replaceAll("file://", ''))
                  //     .then((result) => debugPrint(result.toString()),
                  //         onError: (error) {
                  //   displayError(error);
                  // });
                }, onError: (error) => displayError(error));
              }),
        ),
      ),
    );
  }

  void displayError(PlatformException error) {
    Get.dialog(AlertDialog(
      title: const Text("Error"),
      content: Text(error.message),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("OK"),
        ),
      ],
    ));
  }
}
