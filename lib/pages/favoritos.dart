import 'package:flutter/material.dart';
import 'package:infocar/models/favoritos_carros.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PageFavoritos extends StatefulWidget {
  const PageFavoritos({Key? key}) : super(key: key);

  @override
  State<PageFavoritos> createState() => _PageFavoritosState();
}

class _PageFavoritosState extends State<PageFavoritos> {
  late Future<List<Map<String, dynamic>>> futureBrands;

  @override
  void initState() {
    super.initState();
    // Inicie a solicitação quando o widget for iniciado
    futureBrands = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('https://parallelum.com.br/fipe/api/v2/cars/brands'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Favoritos'),
      ),
      body: Center(
        // Use FutureBuilder para lidar com o estado futuro dos dados
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureBrands,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else {
              // Se os dados foram carregados com sucesso, mostre-os na tela
              final brands = snapshot.data!;

              return ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return ListTile(
                    title: Text(brand['name'].toString()),
                    // Adicione mais widgets para mostrar outros detalhes do item
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
