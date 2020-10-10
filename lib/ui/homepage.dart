import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../backend/firebase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';

import 'package:open_file/open_file.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    BuildContext context1 = context;
    return MaterialApp(
      navigatorKey: Get.key,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GS SDK Flutter Demo'),
        ),
        body: Center(
          child: Text("No"),
        ),
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
                }).then((result) {
                  String pdfUrl = result['pdfUrl'];
                  OpenFile.open(pdfUrl.replaceAll("file://", ''))
                      .then((result) => debugPrint(result.toString()),
                          onError: (error) {
                    displayError(error);
                  });
                }, onError: (error) => displayError(error));
              }),
        ),
      ),
    );
  }

  void displayError(PlatformException error) {
    Get.defaultDialog(
        title: "Error",
        middleText: error.message,
        confirm: FlatButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            )));
  }
}
