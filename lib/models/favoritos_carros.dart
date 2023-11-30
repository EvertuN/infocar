import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:infocar/models/carro.dart';
import 'dart:convert';
class FavoritosCarros extends ChangeNotifier {
  final List<Carro> _carros = [];

  UnmodifiableListView<Carro> get carros => UnmodifiableListView(_carros);

  void add(Carro carro) {
    _carros.add(carro);
    notifyListeners();
  }
}

class DetalhesPage extends StatefulWidget {
  final String brandId;
  final String modelId;
  final String yearId;
  final String modelName;

  const DetalhesPage({required this.brandId, required this.modelId, required this.yearId, required this.modelName, Key? key}) : super(key: key);

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  late Future<Map<String, dynamic>> futureDetails;

  @override
  void initState() {
    super.initState();
    futureDetails = fetchDetails();
  }

  Future<Map<String, dynamic>> fetchDetails() async {
    final response = await http.get(
        Uri.parse('https://parallelum.com.br/fipe/api/v2/cars/brands/${widget.brandId}/models/${widget.modelId}/years/${widget.yearId}'));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modelName),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder<Map<String, dynamic>>(
            future: futureDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final details = snapshot.data!;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marca: ${details['brand']}',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text('Modelo: ${details['model']}',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text('Ano: ${details['modelYear']}',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text('Tipo: ${details['fuel']}',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text('Preço: ${details['price']}',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

