import 'package:flutter/material.dart';
import 'package:muscle_points/Widgets/ExerList.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:muscle_points/Widgets/Exercicios.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key});




  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _newMuscularGroup = TextEditingController();
  TextEditingController _newExercise = TextEditingController();

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

  //Chart

  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = false;




  var _lista = '{"exercicios": []}';
  //var _lista = '{"exercicios": []}';






  List<Exercicios> currentExerContext = [];

  Exercicios exerciciosClass = Exercicios("","",[],[]);

  Future<List<Exercicios>> _getExercicios(String method, [String parametroOpcional = "no"]) async {





    Map<String, dynamic> listaForm = json.decode(_lista);
    //print(listaForm["exercicios"]);
    //Map<String, dynamic> exerciciosData = listaForm["exercicios"][0];



    if(method == "groupExercises"){

      if(!(listaForm["exercicios"].length <=0)) {

        List<Exercicios> gruposMusculares = [];

        listaForm["exercicios"].forEach((exer){
          var groupName = exer.keys.first;
          gruposMusculares.add(Exercicios("ExerList", groupName, [], []));
        });


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


              Exercicios exer = Exercicios("DataList",nome, repeticoes, kgs);

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

    currentMuscularGroup = groupClicked;

    setState(() {
      addExerciseInput = false;
      addMuscularGroupButton = false;
      addMuscularGroupInput = false;
      //addExerciseButton = true;
      showBackButton = true;
      _saveListButton = true;
      deleteItem = true;
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
      //addExerciseButton = false;
      _loaded = false;
      _saveListButton = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _futureExercicios = _getExercicios("groupExercises");
  }













  @override
  Widget build(BuildContext context) {

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
                      height: 800,
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
                        return ListTile(
                          title: GestureDetector(
                            onTap: ()=>_loadExercicios(exercicio!.exercicio),
                            child: Text(exercicio!.exercicio),
                          ),
                          subtitle: Text("Ultima vez treinado: 27/08/2003"),
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
                                      var newLista = exerciciosClass.newExercise(currentMuscularGroup, _newExercise.text, _lista);
                                      setState(() {
                                        addExerciseInput = false;
                                      });
                                      _newExercise.text = "";
                                      _lista = newLista;
                                      _loadExercicios(currentMuscularGroup);
                                    },
                                    icon: Icon(Icons.add),
                                  )
                                ],
                              )
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Row(
                                  children: [
                                    //    Text('Angle',
                                    //     style: TextStyle(
                                    //     color: Colors.deepPurple,
                                    //   ),
                                    // ),
                                    // Slider(
                                    // value: angleValue,
                                    // max: 360,
                                    // onChanged: (double value) => setState(() => angleValue = value),
                                    // ),
                                    // Checkbox(
                                    // value: relativeAngleMode,
                                    // onChanged: (v) => setState(() => relativeAngleMode = v!),
                                    // ),
                                    // const Text('Relative'),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDataSetIndex = -1;
                                    });
                                  },
                                  child: Text(
                                    'Desempenho'.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: rawDataSets()
                                      .asMap()
                                      .map((index, value) {
                                    final isSelected = index == selectedDataSetIndex;
                                    return MapEntry(
                                      index,
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedDataSetIndex = index;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          margin: const EdgeInsets.symmetric(vertical: 2),
                                          height: 26,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.orange
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(46),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 6,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 400),
                                                curve: Curves.easeInToLinear,
                                                padding: EdgeInsets.all(isSelected ? 8 : 6),
                                                decoration: BoxDecoration(
                                                  color: value.color,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              AnimatedDefaultTextStyle(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeInToLinear,
                                                style: TextStyle(
                                                  color:
                                                  isSelected ? value.color : Colors.black,
                                                ),
                                                child: Text(value.title),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                      .values
                                      .toList(),
                                ),
                                AspectRatio(
                                  aspectRatio: 1.3,
                                  child: RadarChart(
                                    RadarChartData(
                                      radarTouchData: RadarTouchData(
                                        touchCallback: (FlTouchEvent event, response) {
                                          if (!event.isInterestedForInteractions) {
                                            setState(() {
                                              selectedDataSetIndex = -1;
                                            });
                                            return;
                                          }
                                          setState(() {
                                            selectedDataSetIndex =
                                                response?.touchedSpot?.touchedDataSetIndex ?? -1;
                                          });
                                        },
                                      ),
                                      dataSets: showingDataSets(),
                                      radarBackgroundColor: Colors.transparent,
                                      borderData: FlBorderData(show: false),
                                      radarBorderData: const BorderSide(color: Colors.transparent),
                                      titlePositionPercentageOffset: 0.2,
                                      titleTextStyle:
                                      TextStyle(color: Colors.black, fontSize: 14),
                                      getTitle: (index, angle) {
                                        final usedAngle =
                                        relativeAngleMode ? angle + angleValue : angleValue;
                                        switch (index) {
                                          case 0:
                                            return RadarChartTitle(
                                              text: 'Desempenho geral',
                                              angle: usedAngle,
                                            );
                                          case 2:
                                            return RadarChartTitle(
                                              text: 'Reps',
                                              angle: usedAngle,
                                            );
                                          case 1:
                                            return RadarChartTitle(text: 'Kgs', angle: usedAngle);
                                          case 3:
                                            return RadarChartTitle(
                                              text: "Total",
                                              angle: usedAngle,
                                            );
                                          default:
                                            return const RadarChartTitle(text: '');
                                        }
                                      },
                                      tickCount: 1,
                                      ticksTextStyle:
                                      const TextStyle(color: Colors.transparent, fontSize: 10),
                                      tickBorderData: const BorderSide(color: Colors.transparent),
                                      gridBorderData: BorderSide(color: Colors.blue, width: 2),
                                    ),
                                    swapAnimationDuration: const Duration(milliseconds: 400),
                                  ),
                                ),
                              ],
                            ),
                          )

                      ],
                      )
                      ),
                        Visibility(
                            visible: _saveListButton,
                            child: ElevatedButton(onPressed: (){
                              print(currentExerContext);
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

                                        treino[i] = {"nome": currentExerContext[i].exercicio,"repetições": [...conversao["reps"]],"kg": [...conversao["kgs"]]};

                                        setState((){
                                          _lista = json.encode(mapList);
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


  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;
      print(rawDataSet);

      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
          ? true
          : false;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withOpacity(0.2)
            : rawDataSet.color.withOpacity(0.05),
        borderColor:
        isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries: //[RadarEntry(value: 30),RadarEntry(value: 40),RadarEntry(value: 50),RadarEntry(value: 10)],
        rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }


  List<RawDataSet> rawDataSets() {
    var count = 0;
    Map<String, dynamic> listForm = json.decode(_lista);
    List<RawDataSet> theReturn = [];

    for(var i=0;i<listForm["exercicios"].length;i++){
        var exercicio = listForm["exercicios"][i][listForm["exercicios"][i].keys.first];
        var treino = exercicio.length>0 ? exercicio[exercicio.length - 1]["treino"]: "";

        if(listForm["exercicios"].length>0 && exercicio.length>0 && treino.length>0 && treino[0]["repetições"].length>0) {
          var reps = [];
          var kgs = [];
          var dsp = [];
          for (var j = 0; j < treino.length; j++) {
            reps.add(treino[j]["repetições"]);
            reps.add(treino[j]["kg"]);
            for (var l = 0; l < treino[j]["kg"].length; l++) {
              dsp.add([treino[j]["repetições"][l], treino[j]["kg"][l]]);
            }
          }


          double repsSum = 0.0;
          if (reps.isNotEmpty) {
            repsSum = reps
                .expand((linha) => linha)
                .map((elemento) => elemento.toDouble())
                .reduce((valorAnterior, elemento) => valorAnterior + elemento);
          }

          double kgsSum = 0.0;
          if (kgs.isNotEmpty) {
            kgsSum = kgs
                .expand((linha) => linha)
                .map((elemento) => elemento.toDouble())
                .reduce((valorAnterior, elemento) => valorAnterior + elemento);
          }

          double dspGeralCount = 0.0;
          var dspList = [];

          for (var k = 0; k < dsp.length; k++) {
            var inicialValue = 0.0;
            for (var j = 0; j < dsp[k].length - 1; j++) {
              if (dsp[k][j + 1] != null) {
                inicialValue = dsp[k][j] * dsp[k][j + 1].toDouble();
              }
            }
            dspList.add(inicialValue);
          }

          print(dspList);

          double dspSum = 0.0;
          if (dspList.isNotEmpty) {
            dspSum = dspList
                .map((elemento) => elemento.toDouble())
                .reduce((valorAnterior, elemento) => valorAnterior + elemento);
          }

          dspSum = dspSum / dspList.length;

          print("dpsSum: $dspSum");

          print("${listForm["exercicios"][i].keys.first}: $dspSum");

          print("separação$count");
          //print("i Atual: $i");
          theReturn.add(
              RawDataSet(
                title: listForm["exercicios"][i].keys.first,
                color: preColors[i],
                values: [
                  dspSum,
                  kgsSum,
                  repsSum,
                ],
              )
          );
        }else{
          break;
        }

    }


        return theReturn.length>0?theReturn: [RawDataSet(
          title: '',
          color: Colors.white,
          values: [
            0,
            0,
            0,
          ],
        )];
    // return [
    //   RawDataSet(
    //     title: 'Perna',
    //     color: Colors.yellow,
    //     values: [
    //       300,
    //       50,
    //       250,
    //     ],
    //   )
    // ];
  }
}



class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}

