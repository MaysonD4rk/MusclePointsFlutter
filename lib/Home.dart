import 'package:flutter/material.dart';
import 'package:muscle_points/Widgets/ExerList.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:muscle_points/Widgets/Exercicios.dart';
import 'package:muscle_points/Widgets/LineChart.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import "dart:io";
import 'Widgets/saveData.dart';






class Home extends StatefulWidget {
  const Home({super.key});




  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {



  TextEditingController _newMuscularGroup = TextEditingController();
  TextEditingController _newExercise = TextEditingController();
  TextEditingController _maxWeight = TextEditingController();

  var preColors = [
    Colors.yellow,
    Colors.red,
  ];


  var showBackButton = false;
  var addMuscularGroupInput = false;
  var addMuscularGroupButton = true;
  var addExerciseInput = false;
  var _saveListButton = false;
  var currentMuscularGroup = "";
  var addExerciseButton = true;
  var deleteItem = false;
  var _loaded = false;
  var chartVisibility = false;
  var containerHeight = 500.0;

  var calcAvgPts = [];

  //Chart

  //int selectedDataSetIndex = -1;
  //double angleValue = 0;
  //bool relativeAngleMode = false;

  //bool showAvg = false;
  late bool isShowingMainData;


  var _lista = '{"exercicios": []}';

  //var _lista = '{"exercicios":[{"Peito":[{"date":"27/09/2023","lastAvg":8.95,"treino":[{"nome":"Supino","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"28/09/2023","lastAvg":5.0,"treino":[{"nome":"Supino","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"29/09/2023","lastAvg":7.0,"treino":[{"nome":"Supino","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"30/09/2023","lastAvg":8.0,"treino":[{"nome":"Supino","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"31/10/2023","lastAvg":9.0,"treino":[{"nome":"Supino","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}] }], "color": "blue"},{"Perna":[{"date":"15/09/2023","lastAvg":9.0,"treino":[{"nome":"Leg press","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"16/09/2023","lastAvg":2.0,"treino":[{"nome":"Leg press","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"17/09/2023","lastAvg":3.0,"treino":[{"nome":"Leg press","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"18/09/2023","lastAvg":5.0,"treino":[{"nome":"Leg press","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]},{"date":"19/10/2023","lastAvg":7.0,"treino":[{"nome":"Leg press","repetições":[12,12,11,10],"kg":[20,20,20,20],"cargaMaxima":25.0,"pts":8.7},{"nome":"Cross","repetições":[12,12,12],"kg":[25,25,25],"cargaMaxima":30.0,"pts":9.2}]}], "color": "red"}]}';


  Color? parseColor([String corString="white"]) {
    Map<String, Color> cores = {
      "red": Colors.blue,
      "blue": Colors.red,
      "black": Colors.black,
      "pink": Colors.pink,
      "orange": Colors.orange,
      "white": Colors.white,
      // "red", "blue", "black", "pink", "white", "orange"
    };

    return cores[corString];
  }




  Exercicios exerciciosClass = Exercicios("","",[],[], "");
  SaveData savedata = SaveData();

  Future<String> getData() async {
    print("entrou aqui hehe");
    bool existe = await savedata.arquivoExiste();
    print(existe);
    if (existe) {
      print("caiu aqui 1");
      var readData = await savedata.lerDadosDoArquivo();
      return readData;
    } else {
      print("caiu aqui 2");
      savedata.salvarDadosEmArquivo(_lista);
      var readData = await savedata.lerDadosDoArquivo();
      return readData;
    }
  }

  saveData<Future>(data) async {

    savedata.salvarDadosEmArquivo(data);

  }






  List<Exercicios> currentExerContext = [];



  Future<List<Exercicios>> _getExercicios(String method, [String parametroOpcional = "no"]) async {





    Map<String, dynamic> listaForm = json.decode(_lista);
    //print(listaForm["exercicios"]);
    //Map<String, dynamic> exerciciosData = listaForm["exercicios"][0];



    if(method == "groupExercises"){

      if(!(listaForm["exercicios"].length <=0)) {

        List<Exercicios> gruposMusculares = [];

        // listaForm["exercicios"].forEach((exer, index){
        //   var groupName = exer.keys.first;
        //
        //
        //   print(textColor);
        //   gruposMusculares.add(Exercicios("ExerList", groupName, [], [], textColor));
        // });

        for(var i = 0;i<listaForm["exercicios"].length;i++){
          var groupName = listaForm["exercicios"][i].keys.first;
          var textColor = listaForm["exercicios"][i]["color"];
          print(listaForm["exercicios"][0]);
          print(textColor);

          gruposMusculares.add(Exercicios("ExerList", groupName, [], [], textColor));

        }


        return gruposMusculares;
      }else{
        print("is empty");
      }
    }else if(method == "exercises"){
      List<Exercicios> exercicios = [];
      //Map<String, dynamic> exerciseData = exerciciosData[parametroOpcional];
      print("entrou aqui 1");
      for (var i=0; i<listaForm["exercicios"].length;i++) {

        if(listaForm["exercicios"][i].containsKey(parametroOpcional)){
          if(listaForm["exercicios"][i][parametroOpcional].length>0){
            dynamic exercicioData = listaForm["exercicios"][i][parametroOpcional][(listaForm["exercicios"][i][parametroOpcional].length)-1]["treino"];

            for(var index=0;index<exercicioData.length;index++){
              print(exercicioData[index]);
              List<int> repeticoes = List<int>.from(exercicioData[index]['repetições']);
              List<int> kgs = List<int>.from(exercicioData[index]['kg']);
              String nome = exercicioData[index]['nome'];


              Exercicios exer = Exercicios("DataList",nome, repeticoes, kgs, "");

              exercicios.add(exer);
            }


          }else{
            return [];
          }

        }

      }
      return exercicios;
    }

    return [];



  }



  Future<List<Exercicios>>? _futureExercicios;

  void _loadExercicios(groupClicked) {



    setState(() {
      currentMuscularGroup = groupClicked;
      addExerciseInput = false;
      addMuscularGroupButton = false;
      addMuscularGroupInput = false;
      //addExerciseButton = true;
      showBackButton = true;
      _saveListButton = true;
      deleteItem = true;
      chartVisibility = true;
      containerHeight = 800.0;

      _loaded = true;
      _futureExercicios = _getExercicios("exercises",groupClicked); // Recarrega o Future
    });
  }


  void _backScreen() {
    setState(() {
      _futureExercicios = _getExercicios("groupExercises");
      showBackButton = false;
      addExerciseInput = false;
      addMuscularGroupButton = true;
      addExerciseInput = false;
      deleteItem = false;
      chartVisibility = false;
      containerHeight = 500.0;
      //addExerciseButton = false;
      _loaded = false;
      _saveListButton = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    loadData();


  }

  void loadData() async {
    var loadJsonList = await getData();
    print(loadJsonList);
    setState(() {
      _lista = loadJsonList;
    });

    _futureExercicios = _getExercicios("groupExercises");

  }











  @override
  Widget build(BuildContext context) {

    //savedata.deleteFile();

    currentExerContext = [];

    DateTime dataAtual = DateTime.now();
    String dataFormatada = DateFormat('dd/MM/yyyy').format(dataAtual);
    print(dataFormatada);






    return Scaffold(
      backgroundColor: Colors.orange,
      body: FutureBuilder<List<Exercicios>>(
        future: _futureExercicios,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator()
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError){
                print("lista: erro ao carregar");
                return Text("Erro ao carregar os dados.");
              }else{
                print('lista carregou');
                return Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 400,
                                    height: containerHeight,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Visibility(
                                                visible: showBackButton,
                                                child: IconButton(
                                                  icon: Icon(Icons.arrow_back),
                                                  onPressed: () {
                                                    _backScreen();
                                                  },
                                                )
                                            ),
                                            /*Visibility(
                                  visible: addMuscularGroupButton,
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        addMuscularGroupInput = true;
                                      });
                                    },
                                  )
                              ),*/
                                            Visibility(
                                                visible: addExerciseButton,
                                                child: IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    setState(() {
                                                      if(_loaded){
                                                        addExerciseInput = true;
                                                      }else{
                                                        addMuscularGroupInput = true;
                                                      }
                                                    });
                                                  },
                                                )
                                            ),
                                            Visibility(
                                                visible: deleteItem,
                                                child: IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    for(var i=0;i<currentExerContext.length;i++){
                                                      setState(() {
                                                        currentExerContext[i].deleteIcon = true;
                                                      });

                                                    }
                                                  },
                                                )
                                            ),
                                          ],
                                        ),

                                        Expanded(child:
                                        ListView.builder(
                                            itemCount: snapshot.data?.length,
                                            itemBuilder: (context, index){

                                              List<Exercicios>? lista = snapshot.data;
                                              Exercicios? exercicio = lista?[index];

                                              final exerList = Provider.of<ExerList>(context, listen: false);

                                              exerList.addListener(() {
                                                setState((){
                                                  print("tentativa nova");
                                                  _lista = exerList.lista;
                                                  _loadExercicios(currentMuscularGroup);
                                                });

                                              });

                                              print("index: ${exercicio}");


                                              if(exercicio!.screen == "ExerList"){
                                                return InkWell(
                                                  onDoubleTap: ()=>_loadExercicios(exercicio!.exercicio),
                                                  onLongPress: (){
                                                    showDialog(context: context, builder: (context){
                                                      return AlertDialog(
                                                        title: Text("excluir ${exercicio.exercicio}?"),
                                                        content: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: (){
                                                                  exercicio.deleteMuscularGroup(context, exercicio.exercicio, _lista);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text("Sim"),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text("Não"),
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                                ),
                                                              ),

                                                            ]
                                                        ),
                                                      );
                                                    });
                                                  },
                                                  highlightColor: Colors.black.withOpacity(0.5), // Cor de destaque
                                                  child: ListTile(
                                                    title: Text(exercicio!.exercicio, style: TextStyle(color: parseColor(exercicio.textColor)),),
                                                    subtitle: Text("Ultima vez treinado: 27/08/2003"),
                                                  ),
                                                );
                                              }else if(exercicio.screen == "DataList"){
                                                currentExerContext.add(exercicio);
                                                return exercicio!.ExerListagem(context, currentMuscularGroup, exercicio!.exercicio, exercicio!.kgs, exercicio!.repeticoes, _lista);
                                              }






                                            }

                                        ),),

                                        Visibility(
                                          visible: addMuscularGroupInput,
                                          child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Row(
                                                children: [

                                                  Expanded(child: TextField(
                                                    controller: _newMuscularGroup,
                                                    decoration: InputDecoration(
                                                      hintText: "Nome do grupo",
                                                    ),
                                                  )),
                                                  IconButton(
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      var newLista = exerciciosClass.newMuscularGroup(_newMuscularGroup.text, _lista);
                                                      setState(() {
                                                        addMuscularGroupInput = false;
                                                      });

                                                      _lista = newLista;
                                                      _newMuscularGroup.text = "";
                                                      _backScreen();
                                                    },
                                                    icon: Icon(Icons.add),
                                                  )
                                                ],
                                              )
                                          ),
                                        ),
                                        Visibility(
                                          visible: addExerciseInput,
                                          child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Row(
                                                children: [

                                                  Expanded(child: TextField(
                                                    controller: _newExercise,
                                                    decoration: InputDecoration(
                                                      hintText: "Nome do exercício",
                                                    ),
                                                  )),
                                                  IconButton(
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            title: Text('Certeza que quer adicionar exercicio?', style: TextStyle(fontSize: 16),),
                                                            content: Row(
                                                              children: [
                                                                Text("Carga máxima"),
                                                                Expanded(child:
                                                                TextField(
                                                                  controller: _maxWeight,
                                                                  textAlign: TextAlign.center,
                                                                 decoration: InputDecoration(
                                                                   hintText: "20kg",
                                                                 ),
                                                                )
                                                                )
                                                            ]),
                                                            actions: [
                                                              ElevatedButton(
                                                                onPressed: () {

                                                                  Navigator.pop(context);

                                                                  print(_lista);

                                                                  var newLista = exerciciosClass.newExercise(currentMuscularGroup, _newExercise.text,_lista, double.parse(_maxWeight.text));

                                                                  setState(() {
                                                                    addExerciseInput = false;
                                                                  });
                                                                  _newExercise.text = "";
                                                                  print("antes do acontecimento");
                                                                  print(newLista);
                                                                  _lista = newLista;
                                                                  _loadExercicios(currentMuscularGroup);

                                                                },
                                                                child: Text('Criar'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('Cancelar'),
                                                              ),
                                                            ],
                                                          );


                                                        });

                                                    },
                                                    icon: Icon(Icons.add),
                                                  )
                                                ],
                                              )
                                          ),
                                        ),
                                        Visibility(
                                            visible: chartVisibility,
                                            child:
                                        Container(
                                          height: 350,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF392f5b),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child:  AspectRatio(
                                            aspectRatio: 1.23,
                                            child: Stack(
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Desempenho',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 32,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 2,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Text(
                                                      'WeekBest: Peito - 920.90pts',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 2,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 16, left: 6),
                                                        child: LineChartExer(isShowingMainData, _lista, currentMuscularGroup),
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
                                          )
                                        ),


                                      ],
                                    )
                                ),
                                Visibility(
                                    visible: _saveListButton,
                                    child: ElevatedButton(onPressed: (){
                                      calcAvgPts = [];
                                      for(var i=0;i<currentExerContext.length;i++){

                                        if(currentExerContext[i].saveCurrentData(context) == "notChange"){
                                          continue;
                                        }

                                        if(currentExerContext[i].saveCurrentData(context) =="leftContent"){
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Campo Obrigatório'),
                                                content: Text('Por favor, preencha o campo antes de continuar.'),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          //print("Direto de home: ${currentExerContext[i].textRepControllers.length}");

                                          setState((){
                                            currentExerContext[i].campoVazio = true;
                                          });


                                          //print("atual campo é: ${currentExerContext[i].campoVazio}");

                                        }else{
                                          Map<String, dynamic> conversao = json.decode(currentExerContext[i].saveCurrentData(context));


                                          Map<dynamic, dynamic> mapList = json.decode(_lista);

                                          for (var j = 0; j < mapList["exercicios"].length; j++) {


                                            //print(mapList["exercicios"][j][currentMuscularGroup][mapList["exercicios"][j][currentMuscularGroup].length-1]["treino"][i]);
                                            if(mapList["exercicios"][j].containsKey(currentMuscularGroup)){


                                              print(mapList["exercicios"][j][currentMuscularGroup][mapList["exercicios"][j][currentMuscularGroup].length-1]);
                                              if(mapList["exercicios"][j][currentMuscularGroup][mapList["exercicios"][j][currentMuscularGroup].length-1]["date"]!=dataFormatada){
                                                mapList["exercicios"][j][currentMuscularGroup].add({"date": dataFormatada, "treino": [...mapList["exercicios"][j][currentMuscularGroup][mapList["exercicios"][j][currentMuscularGroup].length-1]["treino"]]});
                                                //print(mapList["exercicios"][j][currentMuscularGroup]);
                                              }

                                              print(j);
                                              var treino = mapList["exercicios"][j][currentMuscularGroup][mapList["exercicios"][j][currentMuscularGroup].length-1]["treino"];
                                              print("reps");
                                              print(conversao["reps"]);

                                              var kgsMap = conversao["kgs"].map((e){
                                                var pts = (e/treino[i]["cargaMaxima"]);
                                                return pts*10;
                                              });

                                              var kgsPts = kgsMap.toList().reduce((a, b) => a + b)/kgsMap.toList().length;
                                              var repPts = double.parse(((conversao["reps"].reduce((a, b) => a + b)/(12*conversao["reps"].length))*10).toStringAsFixed(1));
                                              print(repPts);
                                              print("kgs");
                                              print((kgsPts+repPts)/2);

                                              var ptResult = double.parse(((kgsPts+repPts)/2).toStringAsFixed(1));

                                              calcAvgPts.add(ptResult);

                                              treino[i] = {"nome": currentExerContext[i].exercicio,"repetições": [...conversao["reps"]],"kg": [...conversao["kgs"]], "cargaMaxima": treino[i]["cargaMaxima"], "pts": ptResult };

                                              //calcAvgPts.reduce((a,b)=>a+b);
                                              var dayPoint = calcAvgPts.reduce((a,b)=>a+b)/calcAvgPts.length;

                                              mapList["exercicios"][j][currentMuscularGroup][mapList["exercicios"][j][currentMuscularGroup].length-1]["lastAvg"] = dayPoint;

                                              setState((){
                                                _lista = json.encode(mapList);
                                                saveData(_lista);
                                                print("Salvo com sucesso!");
                                                //print(_lista);
                                              });
                                              _loadExercicios(currentMuscularGroup);

                                            }
                                          }
                                        }





                                      }
                                      //currentExerContext.saveCurrentData();
                                    }, child: Text("salvar"))
                                ),


                              ]
                          ),
                        ),),
                    )
                );

              }
              break;
          }


        },
      ),
    );


  }


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,

    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.blue,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
            Colors.purple[50]!, // Primeira cor
            Colors.purple[200]!, // Segunda cor (altere para a cor desejada)
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.purple[50]!, // Primeira cor
                Colors.purple[200]!, // Segunda cor (altere para a cor desejada)
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: Colors.red, end: Colors.orange)
                  .lerp(0.2)!,
              ColorTween(begin: Colors.indigo, end: Colors.blue)
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: Colors.pink, end: Colors.pinkAccent)
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: Colors.blueGrey, end: Colors.grey)
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

