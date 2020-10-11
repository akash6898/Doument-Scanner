import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Server extends ChangeNotifier {
  // ignore: deprecated_member_use
  final databaseReference = Firestore.instance;
  CollectionReference getData(String s) {
    final _paq = databaseReference.collection(s);
    return _paq;
  }

  Future createData(String path, Map<String, dynamic> data) async {
    await databaseReference.collection(path).add(data);
  }

  Future updateData(String s, String id, Map<String, dynamic> data) async {
    await databaseReference.collection(s).doc(id).update(data);
  }

  Future<String> uploadFile(File _file, String name) async {
    String _url;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('pdfs/scanned_pdf$name');
    StorageUploadTask uploadTask = storageReference.putFile(_file);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      _url = fileURL.toString();
    });
    return _url;
  }
}
