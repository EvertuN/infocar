import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infocar/pages/widgets/build/modelos_detalhe.dart';

class AnosPage extends StatefulWidget {
  final String brandId;
  final String modelId;
  final String modelName;

  const AnosPage({
    required this.brandId,
    required this.modelId,
    required this.modelName,
    Key? key,
  }) : super(key: key);

  @override
  State<AnosPage> createState() => _AnosPageState();
}

class _AnosPageState extends State<AnosPage> {
  late Future<List<Map<String, dynamic>>> futureYears;

  @override
  void initState() {
    super.initState();
    futureYears = fetchYears();
  }

  Future<List<Map<String, dynamic>>> fetchYears() async {
    try {
      final response = await http.get(Uri.parse(
          'https://parallelum.com.br/fipe/api/v2/cars/brands/${widget.brandId}/models/${widget.modelId}/years'));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception(
            'Erro ao buscar os anos. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro durante a solicitação HTTP: $e');
    }
  }

  Future<String> getYearId(String yearCode) async {
    try {
      final response = await http.get(Uri.parse(
          'https://parallelum.com.br/fipe/api/v2/cars/brands/${widget.brandId}/models/${widget.modelId}/years/$yearCode'));

      //print('Resposta para getYearId: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('codeFipe') &&
            responseData['codeFipe'] != null) {
          final yearId = responseData['codeFipe'];
          //print('Valor de yearId após a chamada: $yearId');
          return yearId.toString();
        } else {
          //print('A resposta não contém a chave "codeFipe" ou o valor é nulo.');
          throw Exception('Erro ao obter o yearId. Resposta inválida.');
        }
      } else {
        //print('Erro na resposta da API: ${response.body}');
        throw Exception(
            'Erro ao obter o yearId. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      //print('Erro durante a requisição: $e');
      throw Exception('Erro ao obter yearId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anos para ${widget.modelName}'),
        backgroundColor: Color.fromRGBO(234, 234, 234, 1), foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureYears,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final years = snapshot.data!;

                return ListView.builder(
                  itemCount: years.length * 2 - 1,
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      return SizedBox(height: 10.0);
                    } else {
                      final yearIndex = index ~/ 2;
                      final year = years[yearIndex];
                      return InkWell(
                        onTap: () async {
                          final yearCode = year['code'].toString();
                          if (yearCode.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalhesModeloPage(
                                  brandId: widget.brandId,
                                  modelId: widget.modelId,
                                  yearId:
                                      yearCode,
                                  modelName: widget.modelName,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 200, 200, 200),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            title: Text(year['code'].toString()),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
