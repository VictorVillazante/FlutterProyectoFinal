import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'package:flutter_app_tienda_videos/crearCuenta.dart';
import 'inicio.dart';
import 'package:flutter_app_tienda_videos/confirmacionPago.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Carrito extends StatelessWidget {
  const Carrito({Key? key}) : super(key: key);

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
    print("PeliculasEstrenos");
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
  void deleteQuitarPeliculaCarrito(int id) async{
    print("deleteQuitarPeliculaCarrito");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.delete("http://10.0.2.2:3000/cart/"+id.toString(),headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response){
      //para ejecutar necesita una respuesta(response) se debe enviar desde javascript al menos un res.send("")
      print("despues de eliminar pelicula");
      getCarrito();
      setState(() {

      });
    });

  }

  void initState() {
    // TODO: implement initState
    getCarrito();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito"),
        backgroundColor: Colors.green,
        actions: <Widget>[ppm()],
      ),
      body: SizedBox(
        width: size.width,
        child: ListView(
          children: [
            Text("Carrito de peliculas"),
            Text("Han agregado la siguientes peliculas"),
            Scrollbar(
              child: ((carrito.length<=0)?
              Text("No peliculas en el carrito"):
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
                            RaisedButton(
                                onPressed: (){
                                  deleteQuitarPeliculaCarrito(carrito[il]["inventory_id"]);
                                },
                              child: Text("Quitar pelicula"),
                            )
                          ],
                        )
                    );
                  }
              ))),
              Row(
              children: [
                Text("Fecha de devolucion"),
                Icon(Icons.calendar_today),
              ],
            ),
            Column(
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
                Row(
                  children: [
                    Text("Total con DSCTO"),
                    Text(obtenerTotalConDescuento())
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>ConfirmacionPago()));
                  },
                  child: Text("Pagar"),
                )
              ],
            )

          ]
        )
      )
    );
  }
  Widget ppm(){
    Widget aux;
    return PopupMenuButton(
        icon: Icon(Icons.menu),
        onSelected: (valor){
          setState(() {
            switch(valor){
              case 1:
              //aux = cargaDatos();
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Login()));
                break;
              case 2:
              /*if(dato1.text.toString().isNotEmpty && dato2.text.toString().isNotEmpty) {
                  double d1 = double.parse(dato1.text.toString());
                  double d2 = double.parse(dato2.text.toString());
                  double d3 = d1+d2;
                  aux = operacion('$d1  +   $d2', d3);
                }*/
                Navigator.push(context,MaterialPageRoute(builder:(context)=>CrearCuenta()));
                break;
              case 3:
              /*if(dato1.text.toString().isNotEmpty && dato2.text.toString().isNotEmpty) {
                  double d1 = double.parse(dato1.text.toString());
                  double d2 = double.parse(dato2.text.toString());
                  double d3 = d1+d2;
                  aux = operacion('$d1  +   $d2', d3);
                }*/
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Inicio()));
                break;
            }
          });
        },
        itemBuilder: (context){
          return [
            PopupMenuItem(child: Text('Ingresar'), value: 1,),
            PopupMenuItem(child: Text('Crear cuenta'), value: 2,),
            PopupMenuItem(child: Text('Inicio'), value: 3,),
          ];
        }
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

