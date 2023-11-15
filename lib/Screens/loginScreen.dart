import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muscle_points/Home.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  var signInMethod = true;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  VerifyAuth()async{
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );



    User? user = auth.currentUser;

    if (user != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home("${user?.uid}")));
    } else {
      print("deslogado?");
    }
  }


  Future SignInRegister(email, password, [method="signIn"])async{
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
//
    if(method=="signIn"){
      auth.signInWithEmailAndPassword(email: email, password: password)
          .then((firebaseUser) {
        print("logado com sucesso!! email: ${firebaseUser.user?.email} - id: ${firebaseUser.user?.uid}");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home("${firebaseUser.user?.uid}")));
      }).catchError((err){
        print("deu erro: "+err);
      });
    }else{
      auth.createUserWithEmailAndPassword(email: email, password: password).then((firebaseUser) {
        print("logado com sucesso!! email: ${firebaseUser.user?.email} - id: ${firebaseUser.user?.uid}");


        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home("${firebaseUser.user?.uid}")));
      }).catchError((err){
        print("deu erro: "+err);
      });
    }


  }


  @override
  Widget build(BuildContext context) {


    VerifyAuth();


    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/musclepoints_logo.png"),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Email:"
              ),
              controller: _email,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Senha:"
              ),
              controller: _password,
            ),
          ),

          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: (){
                signInMethod ? SignInRegister(_email.text, _password.text) : SignInRegister(_email.text, _password.text, "register");
              },
              child: Text(signInMethod ? "Logar" : "Cadastrar")),
          GestureDetector(
            onTap: (){
              if(signInMethod){
                setState(() {
                  signInMethod = false;
                });
              }else{
                setState(() {
                  signInMethod = true;
                });
              }
            },
            child: Text( signInMethod ? "Cadastrar" : "Logar"),
          )

        ],
      )
    );
  }
}
