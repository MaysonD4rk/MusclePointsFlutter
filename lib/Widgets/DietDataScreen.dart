import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:muscle_points/Widgets/LineChartExer.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'package:muscle_points/Widgets/saveData.dart';



class DietDataScreen extends StatefulWidget {

  String dietList;
  DietDataScreen({required this.dietList});

  @override
  State<DietDataScreen> createState() => _DietDataScreenState();
}

class _DietDataScreenState extends State<DietDataScreen> {
  @override
  Widget build(BuildContext context) {
    /* return Visibility(
        visible: true,
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            color: Color(0xFF392f5b),
            borderRadius:
            BorderRadius.circular(10.0),
          ),
          child: AspectRatio(
            aspectRatio: 1.23,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Desempenho',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 32,
                        fontWeight:
                        FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign:
                      TextAlign.center,
                    ),
                    Text(
                      'WeekBest: Peito - 920.90pts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign:
                      TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .only(
                            right: 16,
                            left: 6),
                        child: LineChartExer(
                            isShowingMainData: true,
                            lista: widget.dietList,
                            currentMethod: "dietScreen",
                            currentMuscularGroup: null,),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));


     */

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 55),
          child: SingleChildScrollView(
              child: Column(
                children: [

                  Container(
                      width: 350,
                      height: 900,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Visibility(
                                visible: true,
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF392f5b),
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1.23,
                                    child: Stack(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .stretch,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Dieta',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 32,
                                                fontWeight:
                                                FontWeight.bold,
                                                letterSpacing: 2,
                                              ),
                                              textAlign:
                                              TextAlign.center,
                                            ),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight.bold,
                                                letterSpacing: 2,
                                              ),
                                              textAlign:
                                              TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    right: 16,
                                                    left: 6),
                                                child: LineChartExer(
                                                  isShowingMainData: true,
                                                  lista: widget.dietList,
                                                  currentMethod: "diet",
                                                  currentMuscularGroup: null,),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ),


                        Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Visibility(
                              visible: true,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xFF392f5b),
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1.23,
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .stretch,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Água',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 32,
                                              fontWeight:
                                              FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                            textAlign:
                                            TextAlign.center,
                                          ),
                                          Text(
                                            '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight:
                                              FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                            textAlign:
                                            TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  right: 16,
                                                  left: 6),
                                              child: LineChartExer(
                                                isShowingMainData: true,
                                                lista: widget.dietList,
                                                currentMethod: "water",
                                                currentMuscularGroup: null,),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),

                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("Fechar"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            ),
                        )
                      ]
                    )
                  )

                ],

              )
          ),
        ),
      ),
    );
  }





}
