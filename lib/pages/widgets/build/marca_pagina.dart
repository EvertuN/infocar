import 'package:flutter/material.dart';

class DetalhesMarca extends StatelessWidget {
  final String nomeMarca;

  const DetalhesMarca({required this.nomeMarca, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeMarca),
      ),
      body: Center(
        child: Text(
          'Detalhes da marca: $nomeMarca',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
