import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'backend/firebase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';

import 'package:open_file/open_file.dart';
import 'package:get/get.dart';
import 'ui/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Server>(
      create: (_) => Server(),
      child: HomePage(),
    );
  }
}
