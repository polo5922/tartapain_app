import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/home/page_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
        title: 'Tartapain',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            fontFamily: kfont,
            scaffoldBackgroundColor: kBackgroundColor),
        home: HomePage());
  }
}
