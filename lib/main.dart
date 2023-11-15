import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:muscle_points/Home.dart';
import 'package:muscle_points/Screens/loginScreen.dart';
import 'package:provider/provider.dart';
import 'package:muscle_points/Widgets/ExerList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth auth = FirebaseAuth.instance;

  //String email = "maysonteste@gmail.com";
  //String senha = "123456";

    //auth.signInWithEmailAndPassword(email: email, password: senha);
    //auth.signOut();
  var currentUser = "";

  int index;

  User? user = auth.currentUser;

  if (user != null) {
    currentUser = "${user?.uid}";
    index = 0;
  } else {
    index = 1;
  }


  var currentScreen = [
    Home(currentUser),
    LoginScreen()
  ];

  // auth.createUserWithEmailAndPassword(email: email, password: senha).then((firebaseUser){
  //           print("novo usuario: sucesso!! EMail: ${firebaseUser.user?.email}");
  //         }).catchError((error){
  //   print("erro: "+ error);
  // });





  runApp(
    ChangeNotifierProvider(
      create: (context) => ExerList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: currentScreen[index],
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.orange
        ),
      ),
    ),
  );
}
