import 'package:flutter/material.dart';

class FavoritosCarros extends ChangeNotifier {
  List<String> favoritos = [];

  void adicionarFavorito(String modelo) {
    favoritos.add(modelo);
    notifyListeners();
  }

  void removerFavorito(String modelo) {
    favoritos.remove(modelo);
    notifyListeners();
  }
}
