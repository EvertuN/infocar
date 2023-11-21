import 'package:flutter/material.dart';

class PageCar extends StatefulWidget {
  const PageCar({super.key});

  @override
  State<PageCar> createState() => _PageCarState();
}

class _PageCarState extends State<PageCar> {
  CarroItem() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(children: [
          // oia
        ]),
      );

  MarcaItem(String titulo) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "assets/acura.png",
            width: 48,
          ),
          Text(
            "Acura",
            style: TextStyle(fontSize: 18),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 35, 8, 0),
      child: Column(
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
                //color: Color.fromARGB(206, 205, 212, 244),
                color: Color.fromRGBO(212, 212, 212, 1),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Marcas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'ver todas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(53, 285, 255, 1),
                            decorationColor: Color.fromRGBO(53, 285, 255, 1),
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                    //Row(
                    //  children: [
                    //    Padding(padding: EdgeInsets.all(8.0)),
                    //    Container(
                    //      decoration: BoxDecoration(
                    //        color: Colors.white,
                    //        borderRadius: BorderRadius.circular(6),
                    //      ),
                    //      child: const Padding(
                    //          padding: EdgeInsets.all(8.0),
                    //          child: Column(
                    //            children: [
                    //              Icon(Icons.person),
                    //              Text("Acura"),
                    //            ],
                    //          )),
                    //    )
                    //  ],
                    //),
                    GridView.count(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      crossAxisSpacing: 8,
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      children: [
                        MarcaItem("Acura"),
                        MarcaItem("Acura"),
                        MarcaItem("Acura"),
                        MarcaItem("Acura"),
                        MarcaItem("Acura"),
                        MarcaItem("Acura"),
                        MarcaItem("Acura"),
                        MarcaItem("Acura"),
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
