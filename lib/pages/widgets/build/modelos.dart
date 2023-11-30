import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infocar/pages/widgets/build/modelo_ano.dart';

class ModelosPage extends StatefulWidget {
  final String brandCode;
  final String brandName;

  const ModelosPage(
      {required this.brandCode, required this.brandName, Key? key})
      : super(key: key);

  @override
  State<ModelosPage> createState() => _ModelosPageState();
}

class _ModelosPageState extends State<ModelosPage> {
  late Future<List<Map<String, dynamic>>> futureModels;

  @override
  void initState() {
    super.initState();
    futureModels = fetchModels();
  }

  Future<List<Map<String, dynamic>>> fetchModels() async {
  try {
    final response = await http.get(Uri.parse(
        'https://parallelum.com.br/fipe/api/v2/cars/brands/${widget.brandCode}/models'));

    if (response.statusCode == 200) {
      final models = List<Map<String, dynamic>>.from(json.decode(response.body));

      return models;
    } else {
      throw Exception(
          'Erro ao buscar os modelos. Código de status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro durante a solicitação HTTP: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandName),
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureModels,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final models = snapshot.data!;

                return ListView.builder(
                  itemCount: models.length * 2 - 1,
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      return SizedBox(height: 10.0);
                    } else {
                      final modelIndex = index ~/ 2;
                      final model = models[modelIndex];
                      return InkWell(
                        onTap: () async {
                          final modelId = model['code'];
                          if (modelId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnosPage(
                                  brandId: widget.brandCode,
                                  modelId: modelId.toString(),
                                  modelName: model['name'].toString(),
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
                            title: Text(model['name'].toString()),
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
