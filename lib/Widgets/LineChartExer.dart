import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:muscle_points/Widgets/SeasonSystem.dart';


class LineChartExer extends StatelessWidget {

  final bool isShowingMainData;
  String? lista;
  String? currentMuscularGroup;
  String? currentMethod;

  LineChartExer({required this.isShowingMainData, required this.lista, required this.currentMuscularGroup, required this.currentMethod});



  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData? sampleData1 : sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }


  SeasonSystem seasonsystem = SeasonSystem();



  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 14,
    maxY: 10,
    minY: 0,
  );

  Color? parseColor([String corString="white"]) {
    Map<String, Color> cores = {
      "red": Colors.red,
      "blue": Colors.blue,
      "black": Colors.black,
      "pink": Colors.pink,
      "orange": Colors.orange,
      "white": Colors.white,
      // "red", "blue", "black", "pink", "white", "orange"
    };

    return cores[corString];
  }



  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    ...getLinesChartBarData()
  ];

  LineTouchData get lineTouchData2 => const LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );



  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.white
    );
    String text = '';

    if(currentMethod == "diet"){

      switch (value.toInt()) {
        case 1:
          text = '0.5kcal';
          break;
        case 2:
          text = '1.0kcal';
          break;
        case 3:
          text = '1.5kcal';
          break;
        case 4:
          text = '2.0kcal';
          break;
        case 5:
          text = '2.5kcal';
          break;
        case 6:
          text = '3.0kcal';
          break;
        case 7:
          text = '3.5kcal';
          break;
        case 8:
          text = '4.0kcal';
          break;
        case 9:
          text = '4.5kcal';
          break;
        case 10:
          text = '5.0kcal>';
          break;
        default:
          return Container();
      }

    }else if(currentMethod == "water"){

      switch (value.toInt()) {
        case 1:
          text = '1l';
          break;
        case 2:
          text = '2l';
          break;
        case 3:
          text = '3l';
          break;
        case 4:
          text = '4l';
          break;
        case 5:
          text = '5l';
          break;
        case 6:
          text = '6l';
          break;
        case 7:
          text = '7l';
          break;
        case 8:
          text = '8l';
          break;
        case 9:
          text = '9l';
          break;
        case 10:
          text = '10l>';
          break;
        default:
          return Container();
      }

    }else if(currentMethod == "WorkoutScreen" || currentMethod == "exercises"){
      switch (value.toInt()) {
        case 1:
          text = '1pts';
          break;
        case 2:
          text = '2pts';
          break;
        case 3:
          text = '3pts';
          break;
        case 4:
          text = '4pts';
          break;
        case 5:
          text = '5pts';
          break;
        case 6:
          text = '6pts';
          break;
        case 7:
          text = '7pts';
          break;
        case 8:
          text = '8pts';
          break;
        case 9:
          text = '9pts';
          break;
        case 10:
          text = '10pts';
          break;
        default:
          return Container();
      }
    }

    return Text(text, style: style, textAlign: TextAlign.center);


  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {

    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.white
    );
    Widget text;





    if(currentMethod == "WorkoutScreen"){

      switch (value.toInt()) {
        case 1:
          text = Text("Week 1", style: style);
          break;
        case 4:
          text = Text("Week 2",style: style);
          break;
        case 7:
          text = Text("Week 3",style: style);
          break;
        case 10:
          text = Text("Week 4",style: style);
          break;
        case 13:
          text = Text("Week 5",style: style);
          break;
        default:
          text = Text('');
          break;
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 7,
        child: text,
      );


    }else if(currentMethod == "exercises"){
      int compararDatas(String a, String b) {
        final partesA = a.split('/').map(int.parse).toList();
        final partesB = b.split('/').map(int.parse).toList();

        // Comparamos primeiro os dias (partesA[0] e partesB[0]),
        // depois os meses (partesA[1] e partesB[1]).
        if (partesA[1] == partesB[1]) {
          return partesA[0].compareTo(partesB[0]);
        } else {
          return partesA[1].compareTo(partesB[1]);
        }
      }


      Map<String, dynamic> jsonData = json.decode(lista!);

      List<String> datesList = [];


      // Itera sobre os exercícios
      if (jsonData['exercicios'].length > 0 &&
          jsonData['exercicios'][0].values.first.length > 0) {
        print(jsonData['exercicios'][0]);


        for (var exercise in jsonData['exercicios']) {
          // Itera sobre os treinos de cada exercício
          print('exercise');
          print(currentMuscularGroup);
          if (exercise.keys.first == currentMuscularGroup) {
            print("entrou chara");
            print(exercise.keys.first);
            print(exercise.values.first);
            for (var workout in exercise.values.first) {
              String date = workout['date'];
              // Formata a data para exibir apenas "dd/mm"
              String formattedDate = date.split('/')[0] + '/' +
                  date.split('/')[1];
              // Verifica se a data já existe na lista antes de adicioná-la
              if (!datesList.contains(formattedDate)) {
                datesList.add(formattedDate);
              }
              print(datesList);
            }
          }
        }

        // Ordene a lista de datas
        datesList.sort(compararDatas);

        var lastWeekTrain = datesList.length > 5 ? datesList.sublist(
            datesList.length - 5) : datesList;



        switch (value.toInt()) {
          case 1:
            text = Text(lastWeekTrain[0] != null && lastWeekTrain[0].isNotEmpty
                ? lastWeekTrain[0]
                : "", style: style);
            break;
          case 4:
            text = Text(lastWeekTrain.length > 1 && lastWeekTrain[1] != null &&
                lastWeekTrain[1].isNotEmpty ? lastWeekTrain[1] : "",
                style: style);
            break;
          case 7:
            text = Text(lastWeekTrain.length > 2 && lastWeekTrain[2] != null &&
                lastWeekTrain[2].isNotEmpty ? lastWeekTrain[2] : "",
                style: style);
            break;
          case 10:
            text = Text(lastWeekTrain.length > 3 && lastWeekTrain[3] != null &&
                lastWeekTrain[3].isNotEmpty ? lastWeekTrain[3] : "",
                style: style);
            break;
          case 13:
            text = Text(lastWeekTrain.length > 4 && lastWeekTrain[4] != null &&
                lastWeekTrain[4].isNotEmpty ? lastWeekTrain[4] : "",
                style: style);
            break;
          case 16:
            text = Text(lastWeekTrain.length > 5 && lastWeekTrain[5] != null &&
                lastWeekTrain[5].isNotEmpty ? lastWeekTrain[5] : "",
                style: style);
            break;
          default:
            text = Text('');
            break;
        }

        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 7,
          child: text,
        );
      } else {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 7,
          child: Text(""),
        );
      }
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 7,
      child: Text(""),
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom:
      BorderSide(color: Colors.blue.withOpacity(0.2), width: 4),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  var nextDistance = 1.0;

  List<LineChartBarData> getLinesChartBarData(){

    if(currentMethod == "WorkoutScreen"){
      var color = "";
      Map<String, dynamic> listaForm = json.decode(lista!);
      var weeks = [['01/10/2023','07/10/2023'],['08/10/2023','14/10/2023'],['15/10/2023','21/10/2023'],['22/10/2023','28/10/2023']];
      List<LineChartBarData> exercicios = listaForm["exercicios"].map<LineChartBarData>((i){
        nextDistance = 1.0;
        List<FlSpot> flSpots = [];
        List weekAvg = [];
        i[i.keys.first].forEach((e){
          color = i["color"];
          for(var week=0;week<weeks.length;week++){
            weekAvg.add(double.parse(seasonsystem.systemLoad(lista, weeks[week])));
          }

          //week de laço
          for(var weekL=0;weekL<weekAvg.length;weekL++){
            if(nextDistance<16.0) {
              flSpots.add(FlSpot(nextDistance, weekAvg[weekL]));
              nextDistance += 3;
            }else{
              break;
            }
          }



        });

        //if(flSpots.length<2){
        //print("acho que caiu aqui, sla");
        //flSpots.add(FlSpot(nextDistance, lastAvgs.length>0?lastAvgs[0]: 0));
        //}

        return LineChartBarData(
          isCurved: true,
          color: parseColor(color),
          barWidth: 8,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: [...flSpots],
        );
      }).toList();
      print(exercicios);
      return exercicios;
    }else{

      var color = "";
      Map<String, dynamic> listaForm = json.decode(lista!);
      List<LineChartBarData> exercicios = listaForm["exercicios"].map<LineChartBarData>((i){
        print("separador");

        var lastAvgs = [];
        List<FlSpot> flSpots = [];


        i[i.keys.first].forEach((e){
          print("i key");
          if(i.keys.first == currentMuscularGroup){

            color = i["color"];

            lastAvgs.add(e["lastAvg"]);
            flSpots.add(FlSpot(nextDistance, e["lastAvg"]));
            nextDistance += 3.0;

          }
        });

        //if(flSpots.length<2){
        //print("acho que caiu aqui, sla");
        //flSpots.add(FlSpot(nextDistance, lastAvgs.length>0?lastAvgs[0]: 0));
        //}

        return LineChartBarData(
          isCurved: true,
          color: parseColor(color),
          barWidth: 8,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: [...flSpots],
        );
      }).toList();
      print(exercicios);
      return exercicios;
    }

  }

  // LineChartBarData get lineChartBarData1_1 => LineChartBarData(
  //   isCurved: true,
  //   color: Colors.green,
  //   barWidth: 8,
  //   isStrokeCapRound: true,
  //   dotData: const FlDotData(show: false),
  //   belowBarData: BarAreaData(show: false),
  //   spots: const [
  //     FlSpot(1, 1),
  //     FlSpot(4, 1.5),
  //     FlSpot(7, 1.4),
  //     FlSpot(10, 3.4),
  //     FlSpot(13, 1.8),
  //   ],
  // );

  // LineChartBarData get lineChartBarData1_2 => LineChartBarData(
  //   isCurved: true,
  //   color: Colors.pink,
  //   barWidth: 8,
  //   isStrokeCapRound: true,
  //   dotData: const FlDotData(show: false),
  //   belowBarData: BarAreaData(
  //     show: false,
  //     color: Colors.pink.withOpacity(0),
  //   ),
  //   spots: const [
  //     FlSpot(1, 1),
  //     FlSpot(4, 2.8),
  //     FlSpot(7, 1.2),
  //     FlSpot(10, 2.8),
  //     FlSpot(13, 3.9),
  //   ],
  // );
  //
  // LineChartBarData get lineChartBarData1_3 => LineChartBarData(
  //   isCurved: true,
  //   color: Colors.blue,
  //   barWidth: 8,
  //   isStrokeCapRound: true,
  //   dotData: const FlDotData(show: false),
  //   belowBarData: BarAreaData(show: false),
  //   spots: const [
  //     FlSpot(1, 2.8),
  //     FlSpot(4, 1.9),
  //     FlSpot(7, 3),
  //     FlSpot(10, 1.3),
  //     FlSpot(13, 2.5),
  //   ],
  // );
  //
  // LineChartBarData get lineChartBarData1_4 => LineChartBarData(
  //   isCurved: true,
  //   color: Colors.orange,
  //   barWidth: 8,
  //   isStrokeCapRound: true,
  //   dotData: const FlDotData(show: false),
  //   belowBarData: BarAreaData(show: false),
  //   spots: const [
  //     FlSpot(1, 3),
  //     FlSpot(4, 2.3),
  //     FlSpot(7, 3.5),
  //     FlSpot(10, 2.4),
  //     FlSpot(13, 3),
  //   ],
  // );


}

