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
  TextEditingController _controller = new TextEditingController();
  @override
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
                  String _url = await _server.uploadFile(_file, now.toString());
                  await _server.createData(
                      'pdfs', {'name': now.toString(), 'url': _url});
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

  // Future edit([int index = -1]) async {
  //   if (index != -1) {
  //     _controller.text;
  //   }
  //   await Get.bottomSheet(
  //       Container(
  //         padding: EdgeInsets.all(20),
  //         height: 250,
  //         child: Column(
  //           children: [
  //             Center(
  //                 child: Text(
  //               index == -1 ? "ADD" : "Edit Teacher",
  //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //             )),
  //             SizedBox(
  //               height: 30,
  //             ),
  //             TextField(
  //               controller: _controller,
  //               decoration: InputDecoration(
  //                 border: OutlineInputBorder(),
  //                 labelText: "Teacher Name",
  //               ),
  //             ),
  //             SizedBox(
  //               height: 30,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 Container(
  //                   height: 40,
  //                   width: 120,
  //                   child: RaisedButton(
  //                     color: Theme.of(context).primaryColor,
  //                     onPressed: () {
  //                       if (index != -1)
  //                         _graphco.updatep(index, _controller.text);
  //                       else
  //                         _graphco.addp(_controller.text);

  //                       Get.back();
  //                     },
  //                     child: Row(
  //                       children: [
  //                         Icon(
  //                           index == -1 ? Icons.add : Icons.edit,
  //                           color: Colors.white,
  //                         ),
  //                         Text(
  //                           index == -1 ? "  Create" : "  Update",
  //                           style: TextStyle(
  //                               fontSize: 16,
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.normal),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 if (index != -1)
  //                   Container(
  //                     height: 40,
  //                     width: 120,
  //                     child: RaisedButton(
  //                       color: Theme.of(context).primaryColor,
  //                       onPressed: () {
  //                         _graphco.deletep(index);

  //                         Get.back();
  //                       },
  //                       child: Row(
  //                         children: [
  //                           Icon(
  //                             Icons.delete,
  //                             color: Colors.white,
  //                           ),
  //                           Text(
  //                             "  Delete",
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.normal),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //               ],
  //             )
  //           ],
  //         ),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: new BorderRadius.only(
  //                 topLeft: const Radius.circular(10.0),
  //                 topRight: const Radius.circular(10.0))),
  //       ),
  //       shape: RoundedRectangleBorder(),
  //       elevation: 0);
  // }
}
