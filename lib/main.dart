import 'package:flutter/material.dart';
import 'package:life_colored/models/global_model.dart';
import 'package:life_colored/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

//for git

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalModel g = GlobalModel
        .instance; //init GlobalModel - only one for the App (only restart may help :)
    return MaterialApp(
      title: 'LIFE game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        key: GlobalKey<State>(),
      ),
    );
  }
}
