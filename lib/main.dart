import 'package:flutter/material.dart';
import 'package:quranquiz/ui/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Quiz',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.indigo,
        fontFamily: "Montserrat",
        buttonColor: Colors.green,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary
        )
      ),
      home: HomePage(),
    );
  }
}
