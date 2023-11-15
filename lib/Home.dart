import 'package:flutter/material.dart';
import 'package:muscle_points/Screens/SelectWorkoutGroup.dart';
import 'package:muscle_points/Screens/DietScreen.dart';
import 'package:muscle_points/Screens/SettingsScreen.dart';
import 'package:muscle_points/Screens/WorkoutScreen.dart';
import 'package:muscle_points/Widgets/ExerList.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:muscle_points/Widgets/Exercicios.dart';
import 'package:muscle_points/Widgets/LineChartExer.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'Widgets/saveData.dart';

class Home extends StatefulWidget {

  String userId;
  Home(this.userId);

  //const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _tabIndex = 1;



  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {

    var _screenItem = [
      DietScreen(),
      WorkoutScreen(widget.userId),
      SettingsScreen()
    ];



    return Scaffold(
      body: _screenItem[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) {
          if(_tabIndex != index){
            setState(() {
              _tabIndex = index;
            });
          }
         },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Dieta',

          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/images/dumbell.png")),
            label: 'Treinar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );

  }
}
