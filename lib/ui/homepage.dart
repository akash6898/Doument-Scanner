import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/firebase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'loading.dart';
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
          title: const Text('Document Scanner'),
        ),
        body: PdfList(),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(8),
          child: GestureDetector(
              child: Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                FlutterGeniusScan.scanWithConfiguration({
                  'source': 'camera',
                  'multiPage': true,
                }).then((result) async {
                  Get.dialog(Loading("Uploding..."));
                  String pdfUrl = result['pdfUrl'];
                  File _file =
                      File.fromUri(Uri(path: pdfUrl.replaceAll("file://", '')));
                  DateTime now = new DateTime.now();
                  String time = now.toString();
                  int i = time.indexOf('.');
                  time = time.substring(0, i);
                  String _url = await _server.uploadFile(_file, now.toString());
                  await _server.createData('pdfs', {
                    'name': "Scan" + time,
                    'url': _url,
                    'created on': time,
                    'timestamp': Timestamp.now()
                  });
                  Get.back();
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
