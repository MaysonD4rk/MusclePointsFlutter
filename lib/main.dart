import 'package:flutter/material.dart';
import 'package:muscle_points/Home.dart';
import 'package:provider/provider.dart';
import 'package:muscle_points/Widgets/ExerList.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ExerList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    ),
  );
}