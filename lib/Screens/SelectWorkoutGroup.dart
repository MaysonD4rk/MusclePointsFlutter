import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectWorkoutGroup extends StatefulWidget {

  String userId;

  SelectWorkoutGroup(this.userId);

  @override
  State<SelectWorkoutGroup> createState() => _SelectWorkoutGroupState();
}

class _SelectWorkoutGroupState extends State<SelectWorkoutGroup> {

  TextEditingController _workoutName = TextEditingController();

  List<String> _workouts = [];
  String? _workoutList;
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool firstCreatingOfState = true;
  bool _createWorkoutIsVisible = false;



  Future<void> _CreateWorkout() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;

    CollectionReference exerciseCollection = db.collection('Treinos');

    try {
      await exerciseCollection.add({
        'idOwner': widget.userId,
        'workout': '{"exercicios": []}',
        'workoutName': '${_workoutName.text}'
      });
    } catch (e) {
      print('Error adding document: $e');
    }



    setState(() {

    });
  }

  var loaded = false;


  Future<List<String>> _getWorkouts()async{
      //List<String> wkouts = [];




        WidgetsFlutterBinding.ensureInitialized();

        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        QuerySnapshot querySnapshot = await db.collection("Treinos").where("idOwner", isEqualTo: "${widget.userId}").get();


        List<DocumentSnapshot> documents = querySnapshot.docs;
        List<Map<String, dynamic>> dataList = documents.map((item) => item.data() as Map<String, dynamic>).toList();


        _workouts = [];
        print(_workouts);

        for(var item in dataList){
        print(item["workoutName"]);
        _workouts.add(item["workoutName"]);
      }

      // for(DocumentSnapshot item in querySnapshot.docs){
      //   var dados = item.data() as Map<String, dynamic>;
      //   _workouts.add(dados!["workoutName"]);
      // }

      //workouts em variavel

      //wkouts = [..._workouts];

      print(_workouts);
      return Future.value(_workouts);


  }


  _getChoosenWorkout(workoutName)async{
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    QuerySnapshot querySnapshot = await db.collection("Treinos").where("idOwner", isEqualTo: "${widget.userId}").where("workoutName", isEqualTo: workoutName).get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    List<Map<String, dynamic>> dataList = documents.map((item) => item.data() as Map<String, dynamic>).toList();


    for(var item in dataList){
      //print(item["workout"]);
      setState((){
        _workoutList = item["workout"];
      });
    }


      Navigator.of(context).pop(_workoutList);


  }


  @override
  Widget build(BuildContext context) {




    return Scaffold(
      body:  FutureBuilder<List>(
        future: _getWorkouts(),
        builder: (context, snapshot) {
        switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
            case ConnectionState.active:
            case ConnectionState.done:

                return Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("   "),
                                          Text(
                                            "Escolha o treino",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                _createWorkoutIsVisible = true;
                                              });
                                            },
                                            child: Icon(Icons.add),
                                          )
                                        ]
                                      )
                                  ),
                                  //
                                  Expanded(child:
                                  ListView.builder(
                                      itemCount: _workouts.length,
                                      itemBuilder: (context, index){
                                        return HighlightListItem(
                                          text: _workouts[index],
                                          highlightColor: Colors.black12, // Cor de destaque desejada
                                          onTap: () {
                                            _getChoosenWorkout(_workouts[index]);
                                          },
                                        );
                                  }),
                                  ),
                                  Visibility(
                                      visible: _createWorkoutIsVisible,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _workoutName,
                                                  decoration: InputDecoration(
                                                      labelText: "Nome do treino",
                                                      hintText: "Nome do treino"
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(onTap: _CreateWorkout, child: Icon(Icons.add),)
                                            ]
                                        ),
                                      ),
                                  )


                                ],
                              )
                          ),
                        )
                      ],
                    ),
                    );
        }
        }
      )
    );
  }
}




class HighlightListItem extends StatefulWidget {
  final String text;
  final Color highlightColor;
  final VoidCallback onTap;

  HighlightListItem({
    required this.text,
    required this.highlightColor,
    required this.onTap,
  });

  @override
  _HighlightListItemState createState() => _HighlightListItemState();
}

class _HighlightListItemState extends State<HighlightListItem> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
        widget.onTap();
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Duração da animação
        color: isTapped ? widget.highlightColor : Colors.transparent,
        child: ListTile(
          title: Text(widget.text, style: TextStyle(
            fontSize: 17
          ),),
          subtitle: Text(
              "Ultima vez treinado: 27/08/2003"),
          // Outros widgets de conteúdo do item da lista
        ),
      ),
    );
  }
}