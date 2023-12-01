import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infocar/pages/widgets/build/modelos.dart';
import 'package:infocar/pages/widgets/build/ver_todos.dart';

class Marcas extends StatefulWidget {
  const Marcas({Key? key}) : super(key: key);

  @override
  State<Marcas> createState() => _MarcasState();
}

class _MarcasState extends State<Marcas> {
  List<String> marcas = [];
  String? marcaSelecionada;

  @override
  void initState() {
    super.initState();
    fetchMarcas();
  }

  Future<void> fetchMarcas() async {
    final response = await http
        .get(Uri.parse('https://parallelum.com.br/fipe/api/v2/cars/brands'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<String> marcasList =
          List<String>.from(data.map((marca) => marca['name'].toString()));
      marcasList.sort();
      setState(() {
        marcas = marcasList.take(8).toList();
      });
    }
  }

  Widget buildMarcaItem(String titulo, BuildContext context) => Tooltip(
        message: titulo,
        child: InkWell(
          onTap: () async {
            final brandCode =
                await obterCodigoMarca(titulo); // Adicione essa linha
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ModelosPage(brandName: titulo, brandCode: brandCode),
              ),
            );
          },
          onTapDown: (_) {
            setState(() {
              marcaSelecionada = titulo;
            });
          },
          onTapUp: (_) {
            setState(() {
              marcaSelecionada = null;
            });
          },
          onTapCancel: () {
            setState(() {
              marcaSelecionada = null;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: marcaSelecionada == titulo ? Colors.grey : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/acura.png",
                  width: 48,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    titulo,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

// Função para obter o código da marca
  Future<String> obterCodigoMarca(String marca) async {
    final response = await http
        .get(Uri.parse('https://parallelum.com.br/fipe/api/v2/cars/brands'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final marcaEncontrada = data.firstWhere(
          (element) => element['name'] == marca,
          orElse: () => null);

      if (marcaEncontrada != null) {
        return marcaEncontrada['code'].toString();
      }
    }

    return ''; // Retorne um valor padrão ou lide com o erro conforme necessário
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(212, 212, 212, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Marcas",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerTodos(),
                      ),
                    );
                  },
                  child: Text(
                    "ver todas",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(53, 85, 255, 1),
                      decorationColor: Color.fromRGBO(53, 85, 255, 1),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            GridView.count(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              children: marcas
                  .map((marca) => buildMarcaItem(marca, context))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
