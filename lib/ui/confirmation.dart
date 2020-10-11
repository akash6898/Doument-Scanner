import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Confirmation extends StatelessWidget {
  const Confirmation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm"),
      content: const Text("Are you sure you wish to delete this item?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text("DELETE")),
        FlatButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text("CANCEL"),
        ),
      ],
    );
  }
}
