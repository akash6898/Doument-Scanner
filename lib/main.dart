import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend/firebase.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ui/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Server>(
      create: (_) => Server(),
      child: HomePage(),
    );
  }
}
