import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Server extends ChangeNotifier {
  Future<String> uploadFile(File _file) async {
    String _url;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('pdfs/${_file.path}');
    StorageUploadTask uploadTask = storageReference.putFile(_file);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      _url = fileURL.toString();
    });
    return _url;
  }
}
