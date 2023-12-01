import 'package:flutter/material.dart';
import 'package:infocar/models/favoritos_carros.dart';
import 'package:provider/provider.dart';

class Favoritos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'), foregroundColor: Colors.black,
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      ),
      body: Consumer<FavoritosCarros>(
        builder: (context, favoritosCarros, child) {
          return ListView.builder(
            itemCount: favoritosCarros.favoritos.length,
            itemBuilder: (context, index) {
              final modelo = favoritosCarros.favoritos[index];
              return ListTile(
                title: Text(modelo),
                trailing: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    favoritosCarros.removerFavorito(modelo);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
