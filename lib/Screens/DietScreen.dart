import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {

    List<TextEditingController> _foodName = [];
    List<TextEditingController> _kcal = [];

    //var dietList = '{"dietScreen": [{"date": "12/02", "diet": {"breakfest": "1000kcal", "almoco": "12kcal"}, "water": "15000"}]}';
    var dietList = '{"dietScreen": []}';
    var _waterDrunkCount = 0;


    var _foodSelected = true;

    List<Widget> _waterDrunkList = [];

    List<Widget>? _diet = [];

    dietListConvert(){
      _diet = [];
      _foodName = [];
      _kcal = [];

      print("foodLength");
      print(_foodName.length);

      Map<String, dynamic> dietConverted = json.decode(dietList);

      if(dietConverted["dietScreen"].length>0){
        for(var item in dietConverted["dietScreen"][dietConverted["dietScreen"].length-1]["diet"].keys){
          _diet?.add(modelWidget(false, _foodName.length, item));
        }
      }

    }

    newDietField(nameField, currentKcalLabel){

      Map<String, dynamic> dietConverted = json.decode(dietList);

      DateTime dateNow = DateTime.now();
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dateNow);
      print(dataFormatada);

      print(nameField);
      print(currentKcalLabel);

      var lastItem = dietConverted["dietScreen"].length>0? dietConverted["dietScreen"][dietConverted["dietScreen"].length - 1]: null;

      var newItem = {"date": "$dataFormatada", "diet": lastItem!=null? lastItem["diet"]:{}, "water": _waterDrunkCount};
      newItem["diet"][nameField] = currentKcalLabel;

      if(lastItem != null && lastItem["date"] == dataFormatada){

        setState((){
          lastItem = newItem;
        });

      }else{
        setState((){
          dietConverted["dietScreen"].add(newItem);
        });
      }

      var result = json.encode(dietConverted);
      dietList = result;
      dietListConvert();
      print(dietList);

      //dietConverted["dietScreen"].add({"date": "$dataFormatada", "diet": {"breakfest": "1000kcal", "almoco": "12kcal"}, "water": "15000"});
      //{"date": "12/02", "diet": {"breakfest": "1000kcal", "almoco": "12kcal"}, "water": "15000"}
    }


    getDiet(){
      return _diet;
    }


    Widget modelWidget(bool newField, editingController, [fieldName = null]){

      print(_foodName.length);

      Map<String, dynamic> dietConverted = json.decode(dietList);
      var lastItem = dietConverted["dietScreen"].length>0? dietConverted["dietScreen"][dietConverted["dietScreen"].length - 1]: null;

      _foodName.add(TextEditingController());
      _kcal.add(TextEditingController());

      DateTime dateNow = DateTime.now();
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dateNow);
      if(lastItem != null && dataFormatada == lastItem["date"] && fieldName != null){
        _kcal[editingController].text = lastItem["diet"][fieldName];
      }

      if(!newField){
      return Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if(!_foodSelected)  Expanded(
            //     child: TextField(
            //       decoration: InputDecoration(
            //         hintText: "Nome do alimento",
            //       ),
            //       controller: _foodName[editingController],
            //     )
            // ),

            Text("$fieldName - "),

            // if(!_foodSelected) GestureDetector(
            //     onTap: (){},
            //     child: Icon(Icons.check)
            // ),
            Container(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: " Kcal",
                  ),
                  controller: _kcal[editingController],
                )
            ),

          ],
        ),
      );}

      if(newField) {
        return Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Nome do alimento",
                    ),
                    controller:  _foodName[editingController],
                  )
              ),

              //if(_foodSelected) Text("$fieldName - "),
                   GestureDetector(
                  onTap: () {
                    newDietField(_foodName[editingController].text, _kcal[editingController].text);
                  },
                  child: Icon(Icons.check)
              ),
              Container(
                  width: 100,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: " Kcal",
                    ),
                    controller: _kcal[editingController],
                  )
              ),

            ],
          ),
        );
      }

      return Container();

    }


    saveData(){
      Map<String, dynamic> dietConverted = json.decode(dietList);
      var lastItem = dietConverted["dietScreen"].length>0? dietConverted["dietScreen"][dietConverted["dietScreen"].length - 1]: null;

      DateTime dateNow = DateTime.now();
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dateNow);

      if(lastItem != null && lastItem["date"] == dataFormatada){
        lastItem["water"] = _waterDrunkCount;
        dietConverted["dietScreen"][dietConverted["dietScreen"].length - 1] = lastItem;

        dietList = json.encode(dietConverted);
        print("salvo com sucesso!");
      }else{
        print("tem porra nenhuma carai");
      }

    }


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietListConvert();
  }



  @override
  Widget build(BuildContext context) {





    return Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 55),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  height: 600,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 500,
                            child: SingleChildScrollView(
                                child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Dieta",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              IconButton(onPressed: (){
                                                setState((){
                                                  _diet?.add(modelWidget(true,_foodName.length));
                                                });
                                              }, icon: Icon(Icons.add))
                                              ]
                                          )
                                      ),
                                      Column(
                                        children: _diet!,
                                      ),
                                    ]
                                )
                            ),
                          ),


                        SingleChildScrollView(
                                child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    if(_waterDrunkList.length>0){
                                                      setState((){
                                                        if(_waterDrunkCount<=6500){
                                                          _waterDrunkList.removeLast();
                                                        }
                                                        _waterDrunkCount -= 500;
                                                      });
                                                    }else if(_waterDrunkCount>0){
                                                      setState((){
                                                        _waterDrunkCount -= 500;
                                                      });
                                                    }

                                                  },
                                                  child: Icon(Icons.water_drop, color: Colors.red,),
                                                ),
                                                    Text(
                                                    " - Água - ",
                                                      style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    if(_waterDrunkList.length<=12){
                                                      setState((){
                                                        _waterDrunkList.add(Icon(Icons.water_drop, color: Colors.blue));
                                                        _waterDrunkCount += 500;
                                                      });
                                                    }else if(_waterDrunkCount<15000){
                                                      setState((){
                                                        _waterDrunkCount += 500;
                                                      });
                                                    }

                                                  },
                                                  child: Icon(Icons.water_drop, color: Colors.blue,),
                                                ),

                                                Text(" = 500ml")
                                                ],
                                              )

                                              ]
                                          )
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          ..._waterDrunkList

                                        ],
                                      ),
                                      Text("${_waterDrunkCount}"),
                                    ]
                                )
                              )

                        ],
                      )
                  ),
                ),
                ElevatedButton(
                    onPressed: (){saveData();},
                    child: Text("Salvar"))
              ],
            ),
          ),
        )
      );
  }
}
