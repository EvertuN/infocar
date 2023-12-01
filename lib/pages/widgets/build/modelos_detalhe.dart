import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetalhesModeloPage extends StatefulWidget {
  final String brandId;
  final String modelId;
  final String yearId;
  final String modelName;

  const DetalhesModeloPage({
    required this.brandId,
    required this.modelId,
    required this.yearId,
    required this.modelName,
    Key? key,
  }) : super(key: key);

  @override
  _DetalhesModeloPageState createState() => _DetalhesModeloPageState();
}

class _DetalhesModeloPageState extends State<DetalhesModeloPage> {
  bool isFavorito = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Modelo'), foregroundColor: Colors.black,
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      ),
      body: FutureBuilder(
        future: getFipeInfo(widget.yearId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            var details = snapshot.data as Map<String, dynamic>;

            var brand = details['brand'] ?? 'Marca indisponível';
            var fuel = details['fuel'] ?? 'Tipo de combustível indisponível';
            var preco = details['price'] ?? 'Preço indisponível';

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                      image: DecorationImage(
                        image: NetworkImage('https://d2hucwwplm5rxi.cloudfront.net/wp-content/uploads/2022/05/10074851/top-5-animated-movie-cars-cover-100530331250.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            isFavorito = !isFavorito;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritosPage(
                                modelName: widget.modelName,
                                isFavorito: isFavorito,
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.white,
                        child: Icon(
                          isFavorito ? Icons.favorite : Icons.favorite_border,
                          color: isFavorito ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(234, 234, 234, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marca: $brand', style: TextStyle(fontSize: 20)),
                        Text('Modelo: ${widget.modelName}', style: TextStyle(fontSize: 20)),
                        Text('Ano: ${widget.yearId}', style: TextStyle(fontSize: 20)),
                        Text('Tipo de Combustível: $fuel', style: TextStyle(fontSize: 20)),
                        Text('Preço: $preco', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getFipeInfo(String yearCode) async {
    if (widget.brandId.isEmpty || widget.modelId.isEmpty || yearCode.isEmpty) {
      throw Exception('Parâmetros inválidos para a requisição.');
    }

    final url = Uri.parse('https://parallelum.com.br/fipe/api/v2/cars/brands/${widget.brandId}/models/${widget.modelId}/years/$yearCode');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 500) {
        throw Exception('Erro interno do servidor. Por favor, tente novamente mais tarde.');
      } else {
        throw Exception('Falha ao carregar detalhes do modelo. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      //print('Erro durante a requisição: $e');
      throw Exception('Erro ao fazer a requisição: $e');
    }
  }
}

class FavoritosPage extends StatefulWidget {
  final String modelName;
  final bool isFavorito;

  FavoritosPage({required this.modelName, required this.isFavorito, Key? key}) : super(key: key);

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<String> favoritos = [];

  @override
  void initState() {
    super.initState();
    if (widget.isFavorito) {
      favoritos.add(widget.modelName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: favoritos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoritos[index]),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                setState(() {
                  favoritos.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
