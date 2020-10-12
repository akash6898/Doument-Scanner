import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../backend/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'pdfviewer.dart';

import 'confirmation.dart';

class PdfList extends StatefulWidget {
  @override
  _PdfListState createState() => _PdfListState();
}

class _PdfListState extends State<PdfList> {
  TextEditingController _controller = new TextEditingController();
  Server _server;
  @override
  @override
  Widget build(BuildContext context) {
    _server = Provider.of<Server>(context);
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
            return Dismissible(
              confirmDismiss: (DismissDirection direction) async {
                final bool res = await confirmation();
                return res;
              },
              onDismissed: (dic) {
                _server.delete(snapshot.data.docs[index].id,
                    snapshot.data.docs[index].data()['url']);
              },
              key: UniqueKey(),
              background: Container(color: Colors.red),
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text(
                  snapshot.data.docs[index].data()['name'],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "created on : ${snapshot.data.docs[index].data()['created on']}",
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: false,
                onTap: () {
                  Get.to(PdfViewwer(snapshot.data.docs[index].data()['url'],
                      snapshot.data.docs[index].data()['name']));
                },
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await edit(
                        snapshot.data.docs[index].id,
                        snapshot.data.docs[index].data()['name'],
                        snapshot.data.docs[index].data()['url']);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future edit(String id, String name, String url) async {
    _controller.text = name;
    await Get.bottomSheet(
        Container(
          padding: EdgeInsets.all(20),
          height: 250,
          child: Column(
            children: [
              Center(
                  child: Text(
                "Edit Name",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Pdf Name",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 40,
                    width: 120,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _server
                            .updateData("pdfs", id, {'name': _controller.text});
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          Text(
                            "  Update",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 120,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        Get.back();
                        bool res = await confirmation();
                        if (res) _server.delete(id, url);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "  Delete",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
        ),
        shape: RoundedRectangleBorder(),
        elevation: 0);
  }

  Future<bool> confirmation() async {
    final bool res = await Get.dialog(Confirmation());
    return res;
  }
}
