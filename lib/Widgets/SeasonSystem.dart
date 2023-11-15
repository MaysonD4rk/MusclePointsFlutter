import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

class SeasonSystem{

  systemLoad(lista, interval) {
    // Carregue o arquivo JSON como uma String.
    var weekTotalPts = 0.0;
    var divider = 0;
    var weekAvg = 0.0;

    // Analise a String JSON em um mapa.
    Map<String, dynamic> data = jsonDecode(lista);

    // Defina o intervalo de datas desejado no formato "dd/mm/yy".
    String dataInicialString = interval[0];
    String dataFinalString = interval[1];

    // Crie um DateFormat para analisar datas no formato desejado.
    DateFormat dateFormat = DateFormat('dd/MM/yy');

    // Converta as strings de data em objetos DateTime.


    DateTime dataInicial = dateFormat.parse(dataInicialString);
    DateTime dataFinal = dateFormat.parse(dataFinalString);

    // Lista para armazenar exercícios no intervalo de datas.
    List<dynamic> exerciciosNoIntervalo = [];

    // Itere pelos exercícios e verifique a data.
    for (var exercicio in data['exercicios']) {
      // Converta a data do exercício para um objeto DateTime.
      for (var i = 0; i < exercicio.length; i++) {
        for (var j = 0; j < exercicio[exercicio.keys.first].length; j++) {
          DateTime dataExercicio = dateFormat.parse(
              exercicio[exercicio.keys.first][j]["date"]);

          if (dataExercicio.isAfter(dataInicial) &&
              dataExercicio.isBefore(dataFinal)) {
            print("lastAvg: ${exercicio[exercicio.keys.first][j]["lastAvg"]}");
            weekTotalPts += exercicio[exercicio.keys.first][j]["lastAvg"];
            divider++;
            exerciciosNoIntervalo.add(exercicio);
          }
        }

        // Imprima os exercícios no intervalo de datas.
        print(
            'Exercícios no intervalo de $dataInicialString a $dataFinalString:');

      }
    }
      weekAvg = weekTotalPts / divider;
      print(divider);
      print(weekTotalPts);
      print("retornando weekAvg: ${weekAvg.toStringAsFixed(1)}");
      return weekAvg.toStringAsFixed(1);


  }

}