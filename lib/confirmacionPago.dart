import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ConfirmacionPago extends StatelessWidget {
  const ConfirmacionPago({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Secundario();
  }
}
class Secundario extends StatefulWidget {
  const Secundario({Key? key}) : super(key: key);

  @override
  _SecundarioState createState() => _SecundarioState();
}

class _SecundarioState extends State<Secundario> {
  late List carrito=[];

  getCarrito() async {
    print("Carrito");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/cart", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      setState(() {
        carrito=(json.decode(response.body));
      });
      setState(() {

      });
      print(carrito);
    });
  }
  void initState() {
    // TODO: implement initState
    print("Confirmacion de pago");
    getCarrito();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido"),
      ),
      body: ListView(
        children: [Column(
          children: [
            Text("Confirmacion de pago"),
            Column(
              children: [
                Scrollbar(
                  child: ((carrito.length<=0)?
                  Text("No hay peliculas en el carrito"):
                  ListView.builder(//Este listview esta atento a los cambios
                      itemCount: carrito.length, //Sin este valor el listview interpreta una lista infinita, y se queda en un bucle
                      scrollDirection: Axis.vertical,//Sin esto hay error
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int il){//Se ejecuta en cada cambio
                        return Container(
                            color: (il%2==0)?Colors.grey:Colors.white,
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*(3/9),
                                  child: Column(
                                    children: [
                                      (carrito[il]['title']==null)?Text(""):Text(carrito[il]['title']),//Text(titulos[id2]),
                                      (carrito[il]['description']==null)?Text(""):Text(carrito[il]['description'])//Text(datos[id2])
                                    ],
                                  ),
                                ),
                              ],
                            )
                        );
                      }
                  ))),
                Text("Direccion de envio"),
                RaisedButton(
                    onPressed: (){

                    }
                    ),
                Text("Descripcion de informacion")
              ],
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width*0.4,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("TOTAL"),
                          Text(obtenerTotalCarrito())

                        ],
                      ),
                      Row(
                        children: [
                          Text("DSCTO"),
                          Text(obtenerDescuento())

                        ],
                      ),
                      Text("Total con DSCTO"),
                      Text(obtenerTotalConDescuento()),
                      RaisedButton(
                          onPressed: () {

                          },
                          child:Text("confirmar")
                      ),
                      RaisedButton(
                          onPressed: (){

                          },
                          child: Text("Cancelar"),
                          )
                    ],
                  ),
                )
              ],
            )
          ]
        ),
      ]
      )
    );
  }
  double total=0;
  String obtenerTotalCarrito() {
    total=0;
    total=total+carrito.length*0.99*obtenerNumeroDiasPrestamo();
    return total.toStringAsFixed(2);
  }
  double descuento=0;
  String obtenerDescuento() {
    if(total>=10 && total<15){
      descuento=total*0.1;
      return descuento.toStringAsFixed(2);
    }else{
      if(total>=15 && total<20){
        descuento=total*0.15;
        return descuento.toStringAsFixed(2);
      }else{
        if(total>=20){
          descuento=total*0.2;
          return descuento.toStringAsFixed(2);
        }else{
          descuento=0;
          return descuento.toStringAsFixed(2);
        }
      }
    }
  }

  num obtenerNumeroDiasPrestamo() {
    return 7;
  }
  double totalConDescuento=0;
  String obtenerTotalConDescuento() {
    totalConDescuento=total-descuento;
    return totalConDescuento.toStringAsFixed(2);
  }
}

