import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muscle_points/Widgets/ExerList.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:muscle_points/Widgets/saveData.dart';
import 'package:provider/provider.dart';



class Exercicios{


  String _exercicio;
  String screen;
  List _repeticoes;
  List _kgs;

  List<TextEditingController> textRepControllers = [];
  List<TextEditingController> textKgControllers = [];

  Exercicios( this.screen, this._exercicio,this._repeticoes, this._kgs){
    // Crie os controladores no construtor
    for (var i = 0; i < _repeticoes.length; i++) {
      TextEditingController textRepController = TextEditingController();
      textRepControllers.add(textRepController);
    }

    for (var i = 0; i < _kgs.length; i++) {
      TextEditingController textKgController = TextEditingController();
      textKgControllers.add(textKgController);
    }
  }




  List subReps = [];
  List subKgs = [];
  bool campoVazio = false;
  bool deleteIcon = false;

  List get kgs => _kgs;

  set kgs(List value) {
    _kgs = value;
  }

  List get repeticoes => _repeticoes;

  set repeticoes(List value) {
    _repeticoes = value;
  }

  String get exercicio => _exercicio;

  set exercicio(String value) {
    _exercicio = value;
  }


  ExerListagem<Widget>(BuildContext contextList, String muscularGroup, String exercicio, List kgs, List reps, lista){


    widgetsExerInsert<Widget>(){
      List widgetsExer = [];

      var rows = [];

      for(var i=0; i<kgs.length;i++){

        subReps.add(reps[i]);
        subKgs.add(kgs[i]);

        if(reps[i] != 0 && kgs[i] != 0){
          textRepControllers[i].text = reps[i].toString();
          textKgControllers[i].text = kgs[i].toString();
        }

        rows.add(
          Row(
            children: [
              Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: textRepControllers[i],
                    decoration: InputDecoration(
                      hintText: "Rep: ${reps[i].toString()}",
                      hintStyle: TextStyle(
                        color: campoVazio ? Colors.red : Colors.black54
                      )
                    ),
                    ),

                  ),

              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (e){print(textKgControllers[i].text);},
                        controller: textKgControllers[i],
                        decoration: InputDecoration(
                          hintText: "Kgs: ${kgs[i].toString()}",
                          hintStyle: TextStyle(
                            color: campoVazio ? Colors.red : Colors.black54
                          )
                        ),
                      ),
                        )

              ),
              Visibility(
                  visible: deleteIcon,
                  child: IconButton(
                    onPressed: (){
                      deleteSerieData(contextList,muscularGroup,exercicio,i,lista);
                    },
                    icon: Icon(Icons.delete),
                  )
              )

            ],
          )
        );

      } //for

      widgetsExer.add(
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: deleteIcon,
                        child: IconButton(
                          onPressed: (){
                            deleteExerciseData(contextList,muscularGroup,exercicio,lista);
                          },
                          icon: Icon(Icons.delete),
                        )
                    ),
                    Text(
                      exercicio,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(onPressed: (){this.addRepColumn(contextList,lista,muscularGroup, exercicio);}, icon: Icon(Icons.add))
                  ],
                ),

                ...rows,



              ],
            ),
          )
      );

      return widgetsExer;



    }




    return Container(

            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Column(
                children: [

                  ...widgetsExerInsert(),

                ],
              ),
            ),

          );

  }


  newMuscularGroup(muscularGroupName, currentList){
    Map<String, dynamic> listaForm = json.decode(currentList);
    listaForm["exercicios"].add({muscularGroupName: []});
    String jsonString = json.encode(listaForm);

    var buffer = StringBuffer(jsonString);

    final int chunkSize = 1000;
    for (var i = 0; i < jsonString.length; i += chunkSize) {
      final end = (i + chunkSize < jsonString.length) ? (i + chunkSize) : jsonString.length;
      print(jsonString.substring(i, end));
    }

    return json.encode(listaForm);


  }

  newExercise(muscularGroupName,exerciseName, currentList){
    Map<String, dynamic> listaForm = json.decode(currentList);

    DateTime dataAtual = DateTime.now();
    String dataFormatada = DateFormat('dd/MM/yyyy').format(dataAtual);
    print(dataFormatada);

    for (var i=0; i<listaForm["exercicios"].length;i++) {

      if(listaForm["exercicios"][i].containsKey(muscularGroupName)) {

        if(listaForm["exercicios"][i][muscularGroupName].length>0){
          listaForm["exercicios"][i][muscularGroupName][listaForm["exercicios"][i][muscularGroupName].length-1]["treino"].add({"nome":"$exerciseName","repetições":[],"kg":[]});


          String jsonString = json.encode(listaForm);

          var buffer = StringBuffer(jsonString);

          final int chunkSize = 1000;
          for (var i = 0; i < jsonString.length; i += chunkSize) {
            final end = (i + chunkSize < jsonString.length) ? (i + chunkSize) : jsonString.length;
            print(jsonString.substring(i, end));
          }
        }else{
          listaForm["exercicios"][i][muscularGroupName].add({"date": dataFormatada, "treino": [{"nome":"$exerciseName","repetições":[],"kg":[]}]});


          String jsonString = json.encode(listaForm);

          var buffer = StringBuffer(jsonString);

          final int chunkSize = 1000;
          for (var i = 0; i < jsonString.length; i += chunkSize) {
            final end = (i + chunkSize < jsonString.length) ? (i + chunkSize) : jsonString.length;
            print(jsonString.substring(i, end));
          }
        }
        print("ta aqui ó");
        print(json.encode(listaForm));
        return json.encode(listaForm);

      }
    }




  }



  addRepColumn(context, lista,muscularGroup, exercicio) {
    Map<String, dynamic> listaForm = json.decode(lista);

    final exerList = Provider.of<ExerList>(context, listen: false);
    DateTime dataAtual = DateTime.now();
    String dataFormatada = DateFormat('dd/MM/yyyy').format(dataAtual);
    print(dataFormatada);


    for (var i = 0; i <= listaForm["exercicios"].length; i++) {
      if(listaForm["exercicios"][i].containsKey(muscularGroup)){

        if(listaForm["exercicios"][i][muscularGroup][listaForm["exercicios"][i][muscularGroup].length-1]["date"]!=dataFormatada){
          listaForm["exercicios"][i][muscularGroup].add({"date": dataFormatada, "treino": [...listaForm["exercicios"][i][muscularGroup][listaForm["exercicios"][i][muscularGroup].length-1]["treino"]]});
          print(listaForm["exercicios"][i][muscularGroup]);
        }

          var treino = listaForm["exercicios"][i][muscularGroup][listaForm["exercicios"][i][muscularGroup].length-1]["treino"];

            for(var j=0;j<treino.length;j++){

              print(treino[j]["nome"]);

                if (treino[j]["nome"] == exercicio) {
                  treino[j]["repetições"].add(
                    0);
                  treino[j]["kg"].add(0);

                String jsonString = json.encode(listaForm);

                var buffer = StringBuffer(jsonString);

                final int chunkSize = 1000;
                for (var i = 0; i < jsonString.length; i += chunkSize) {
                  final end = (i + chunkSize < jsonString.length)
                      ? (i + chunkSize)
                      : jsonString.length;
                  print(jsonString.substring(i, end));
                }

                exerList.atualizarLista(jsonString);

              } else {
                print("por enquanto nada");
              }
            }


      }

    }
  }







  saveCurrentData(context){

    var reps = [];
    var kgs = [];

    for(var i=0;i<textRepControllers.length;i++){
      if(textRepControllers[i].text.isEmpty){
        print(campoVazio);

      }else{
        //print("ta escrito: ${textRepControllers[i].text}");
        reps.add(textRepControllers[i].text);
      }

    }

    for(var i=0;i<textKgControllers.length;i++){
      if(textKgControllers[i].text.isEmpty){
          //print(textKgControllers[i].text);

          return "leftContent";
      }else{
        //print("não ta vazio");
        kgs.add(textKgControllers[i].text);
      }

    }

    for(var i = 0; i<reps.length;i++){
      if(reps[i].isEmpty){
        reps.removeAt(i);
      }
    }
    for(var i = 0; i<kgs.length;i++){
      if(kgs[i].isEmpty){
        kgs.removeAt(i);
      }
    }

    //print("SubReps");
    //print(subReps);
    //print("SubKgs");
    //print(subKgs);


    if(reps.length == 0 && kgs.length == 0){
      return "notChange";
    }else if(reps.length == 0 && kgs.length != 0){
      return '{"reps": ${[...subReps]}, "kgs": ${[...kgs]}}';
    }else if(reps.length != 0 && kgs.length == 0){
      return '{"reps": ${[...reps]}, "kgs": ${[...subKgs]}}';
    }else{
      return '{"reps": ${[...reps]}, "kgs": ${[...kgs]}}';
    }


  }


  deleteSerieData(context,muscularGroup, exercise, serie, list){

    final exerList = Provider.of<ExerList>(context, listen: false);

    Map<String, dynamic> listForm = json.decode(list);

    //print(listForm["exercicios"][muscularGroup].length);

    for(var i=0;i<= listForm["exercicios"].length;i++){

      if(listForm["exercicios"][i].containsKey(muscularGroup)){

        var treino = listForm["exercicios"][i][muscularGroup][listForm["exercicios"][i][muscularGroup].length-1]["treino"];

        for(var j=0;j<treino.length;j++){

          if(treino[j]["nome"] == exercise){

            treino[j]["repetições"].removeAt(serie);
            treino[j]["kg"].removeAt(serie);
            exerList.atualizarLista(json.encode(listForm));
            return "atualizou";
          }else{
            print("ta caindo aqui");
            continue;
          }

        }



      }




    }

    return "acho que não";


  }

  deleteExerciseData(context,muscularGroup, exercise, list){

    final exerList = Provider.of<ExerList>(context, listen: false);

    Map<String, dynamic> listForm = json.decode(list);

    //print(listForm["exercicios"][muscularGroup].length);

    for(var i=0;i<= listForm["exercicios"].length;i++){

      if(listForm["exercicios"][i].containsKey(muscularGroup)){

        var treino = listForm["exercicios"][i][muscularGroup][listForm["exercicios"][i][muscularGroup].length-1]["treino"];

        for(var j=0;j<treino.length;j++){

          if(treino[j]["nome"] == exercise){

            treino.removeAt(j);
            exerList.atualizarLista(json.encode(listForm));
            return "atualizou";
          }else{
            print("ta caindo aqui");
            continue;
          }

        }



      }




    }

    return "acho que não";


  }


  deleteMuscularGroup(context,muscularGroup, list){
    final exerList = Provider.of<ExerList>(context, listen: false);
    SaveData savedata = SaveData();
    
    Map<String, dynamic> listForm = json.decode(list);

    //print(listForm["exercicios"][muscularGroup].length);

    for(var i=0;i<= listForm["exercicios"].length;i++){

      if(listForm["exercicios"][i].containsKey(muscularGroup)){

        listForm["exercicios"].removeAt(i);
        exerList.atualizarLista(json.encode(listForm));
        savedata.salvarDadosEmArquivo(json.encode(listForm));
        
      }




    }

    return "acho que não";
  }




}