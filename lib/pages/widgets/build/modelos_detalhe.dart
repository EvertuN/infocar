import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetalhesModeloPage extends StatelessWidget {
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

  Future<Map<String, dynamic>> getFipeInfo() async {
  final url = Uri.parse('https://parallelum.com.br/fipe/api/v2/cars/brands/$brandId/models/$modelId/years/$yearId');

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
    throw Exception('Erro ao fazer a requisição: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Modelo'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: getFipeInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            var details = snapshot.data as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Marca: $brandId'),
                    Text('Modelo: $modelName'),
                    Text('Ano: $yearId'),
                    Text('Preço: ${details['preco']}'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
