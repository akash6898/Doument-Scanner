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

class PdfList extends StatefulWidget {
  @override
  _PdfListState createState() => _PdfListState();
}

class _PdfListState extends State<PdfList> {
  @override
  Widget build(BuildContext context) {
    Server _server = Provider.of<Server>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _server.getAllPdfs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.docs.length == 0) {
          return Center(
            child: Text("No Pdfs created"),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text(snapshot.data.docs[index].data()['name']),
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: null),
            );
          },
        );
      },
    );
  }
}
