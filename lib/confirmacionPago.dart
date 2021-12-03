import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ConfirmacionPago extends StatelessWidget {
  final int diasPrestamo;
  final String fechaPrestamo;
  const ConfirmacionPago(this.diasPrestamo, this.fechaPrestamo,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Secundario(diasPrestamo,fechaPrestamo);
  }
}
class Secundario extends StatefulWidget {
  final int diasPrestamo;
  final String fechaPrestamo;
  const Secundario(this.diasPrestamo,this.fechaPrestamo, {Key? key}) : super(key: key);

  @override
  _SecundarioState createState() => _SecundarioState(diasPrestamo,fechaPrestamo);
}

class _SecundarioState extends State<Secundario> {
  late List carrito=[];
  final int diasPrestamo;
  final String fechaPrestamo;
  String usuario="";
  String idUsuario="";
  int numDiasPrestamo=1;
  String fechaEntrega="";
  int staffId=1;
  _SecundarioState(this.diasPrestamo,this.fechaPrestamo);
  deleteQuitarTodosCarrito() async{
    print("deleteQuitarTodosCarrito");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.delete("http://10.0.2.2:3000/cart/",headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response){
      //para ejecutar necesita una respuesta(response) se debe enviar desde javascript al menos un res.send("")
      print("despues de eliminar todo el carrito");
      getCarrito();
      setState(() {

      });
    });

  }
  postPayment() async{
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    http.post(
      "http://10.0.2.2:3000/payment",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'customer_id': idUsuario,
        "staff_id": staffId.toString(),
        "amount": (total/carrito.length).toString(),
        "payment_date": dateFormat.format(DateTime.now()),
        "last_update": dateFormat.format(DateTime.now()),
      }),

    ).then((response) {

    });
  }
  postRental(int inventorioId) async {
    print("Registrando nueva renta");
    print("fecha entrerga="+fechaPrestamo);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    http.post(
      "http://10.0.2.2:3000/rental",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rental_date': dateFormat.format(DateTime.now()),
        "inventory_id": inventorioId.toString(),
        "customer_id": idUsuario,
        "return_date": fechaPrestamo,
        "staff_id": staffId.toString(),
        "last_update": dateFormat.format(DateTime.now()),
      }),

    ).then((response) {

    });
  }

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

  getData()async{
    print("getData confirmacionPago-------------------------");
    SharedPreferences preferences= await SharedPreferences.getInstance();
    setState(() {
      usuario=preferences.getString("usuario")!;
      idUsuario=preferences.getString("idUsuario")!;
      //numDiasPrestamo=preferences.getInt("diasPrestamo")!;
      staffId=preferences.getInt("tiendaId")!;
      print("Datos ---------------------------------------------");
    });
    print(usuario);
    print(idUsuario);
    setState(() {

    });
  }
  void initState() {
    // TODO: implement initState
    print("Confirmacion de pago");
    print(fechaPrestamo);
    getData();
    getCarrito();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          (usuario!=null)?Text(usuario):Text("No se identifico el usuario"),
          Container(margin:EdgeInsets.symmetric(vertical: 10),child: Center(child: Text("Confirmacion de pago",style: TextStyle(fontSize: 20),))),
          Container(
            height: 200,
            padding: EdgeInsets.all(5),
            child: Scrollbar(
              child: ((carrito.length<=0)?
              Text("No hay peliculas en el carrito"):
              ListView.builder(//Este listview esta atento a los cambios
                  itemCount: carrito.length, //Sin este valor el listview interpreta una lista infinita, y se queda en un bucle
                  scrollDirection: Axis.vertical,//Sin esto hay error
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int il){//Se ejecuta en cada cambio
                    return Container(
                        color: (il%2==0)?Colors.green:Colors.white,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Image.network(
                                    "https://picsum.photos/"+(carrito[il]["inventory_id"]%1000).toString(),
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                Container(
                                  width:180,
                                  child: Column(
                                    children: [
                                      (carrito[il]['title']==null)?Text(""):Text(carrito[il]['title']),//Text(titulos[id2]),
                                      (carrito[il]['description']==null)?Text(""):Text(carrito[il]['description'])//Text(datos[id2])
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                    );
                  }
              ))),
          ),
          Container(padding:EdgeInsets.all(5),height:30,color:Colors.green,child: Center(child: Text("Direccion de envio")),margin: EdgeInsets.only(bottom: 10),),
          RaisedButton(
              onPressed: (){

              }
              ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.green,
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
                Row(
                  children: [
                    Text("Total con DSCTO"),
                    Text(obtenerTotalConDescuento()),
                  ],
                ),
                RaisedButton(
                    onPressed: () {
                        for(int i=0;i<carrito.length;i++){
                          print(carrito[i]["inventory_id"]);
                          postRental(carrito[i]["inventory_id"]);
                          postPayment();
                        }
                        deleteQuitarTodosCarrito();

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
          ),
        ]
      )
    );
  }
  double total=0;
  String obtenerTotalCarrito() {
    total=0;
    total=total+carrito.length*0.99*diasPrestamo;
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


  double totalConDescuento=0;
  String obtenerTotalConDescuento() {
    totalConDescuento=total-descuento;
    return totalConDescuento.toStringAsFixed(2);
  }


}

