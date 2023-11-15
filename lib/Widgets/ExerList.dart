import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExerList extends ChangeNotifier {

    String lista ="";
    bool appIsRunning = false;


    void atualizarLista(String novaLista) {
      print("modificou");
      lista = novaLista;
      notifyListeners(); // Notifique os ouvintes após a modificação

    }


  void RunOnApp(bool action) {
      print("modificou");
      appIsRunning = action;
      notifyListeners(); // Notifique os ouvintes após a modificação

    }

}