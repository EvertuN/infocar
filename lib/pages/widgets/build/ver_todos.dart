import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infocar/pages/widgets/build/modelos.dart';

class VerTodos extends StatefulWidget {
  const VerTodos({Key? key}) : super(key: key);

  @override
  State<VerTodos> createState() => _PageVerTodos();
}

class _PageVerTodos extends State<VerTodos> {
  late Future<List<Map<String, dynamic>>> futureBrands;

  @override
  void initState() {
    super.initState();
    futureBrands = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(
        Uri.parse('https://parallelum.com.br/fipe/api/v2/cars/brands'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Deu esse erro ai: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcas'),
        backgroundColor: Color.fromRGBO(234, 234, 234, 1),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureBrands,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else {
                  final brands = snapshot.data!;

                  return ListView.builder(
                    itemCount: brands.length * 2 - 1,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return SizedBox(height: 10.0);
                      } else {
                        final brandIndex = index ~/ 2;
                        final brand = brands[brandIndex];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModelosPage(
                                  brandCode: brand['code'].toString(),
                                  brandName: brand['name'].toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 200, 200, 200),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              title: Text(brand['name'].toString()),
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
      ),
    );
  }
}