import 'package:flutter/foundation.dart';

class ExerList extends ChangeNotifier {

    String lista ="";

    void atualizarLista(String novaLista) {
      print("modificou");
      lista = novaLista;
      notifyListeners(); // Notifique os ouvintes após a modificação

    }

}