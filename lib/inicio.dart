// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_tienda_videos/galeria.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  @override
  deleteQuitarTodosCarrito() async{
    print("deleteQuitarTodosCarrito");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.delete("http://10.0.2.2:3000/cart/",headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response){
      //para ejecutar necesita una respuesta(response) se debe enviar desde javascript al menos un res.send("")
      print("despues de eliminar todo el carrito");
      setState(() {

      });
    });

  }
  get(String direccion) async {
    print("Establecer tienda");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get(direccion, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {

    });
  }
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Tienda de videos"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Center(child: Container(child: Text("Bienvenido a la sakila rental",style: TextStyle(fontSize: 25),),margin: EdgeInsets.all(20),)),
              Container(child: Text("Porfavor seleccione el pais en el que desea comprar",style: TextStyle(fontSize: 12),),margin: EdgeInsets.only(bottom: 20,left: 20),),
              GestureDetector(
                onTap: () async {
                  get("http://10.0.2.2:3000/store/1");
                  SharedPreferences preferences= await SharedPreferences.getInstance();
                  preferences.setInt("tiendaId",1);
                  deleteQuitarTodosCarrito();
                  preferences.setString("usuario", "");
                  preferences.setString("idUsuario", "");
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Secundario()));
                },
                child: Container(
                    width: 200,
                    color: Colors.green,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                    children: [
                      Image(
                          width: 200,
                          image: AssetImage(
                              'assets/australia.png'
                          )
                      ),
                      Text("Australia",style: TextStyle(color: Colors.white,fontSize: 18),)
                    ],
                  )
                ),
              ),

              GestureDetector(
                onTap: () async {
                  get("http://10.0.2.2:3000/store/2");
                  SharedPreferences preferences= await SharedPreferences.getInstance();
                  preferences.setInt("tiendaId",2);
                  deleteQuitarTodosCarrito();
                  preferences.setString("usuario", "");
                  preferences.setString("idUsuario", "");
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>Secundario()));
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.green,
                    child: Column(
                      children: [
                        Image(
                            width: 200,
                            image: AssetImage(
                                'assets/canada.jpg'
                            )
                        ),
                        Text("Canada",style: TextStyle(color: Colors.white,fontSize: 18),)
                      ],
                    ),

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

