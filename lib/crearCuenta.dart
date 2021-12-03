// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class CrearCuenta extends StatefulWidget {
  const CrearCuenta({Key? key}) : super(key: key);

  @override
  _CrearCuentaState createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  @override
  final controladorTextFieldNombre = TextEditingController();
  final controladorTextFieldApellido = TextEditingController();
  final controladorTextFieldEmail = TextEditingController();
  final controladorTextFieldDireccion = TextEditingController();
  final controladorTextFieldDireccion2 = TextEditingController();
  final controladorTextFieldDistrito = TextEditingController();
  postA() async{
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    http.post(
      "http://10.0.2.2:3000/payment",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'address': controladorTextFieldDireccion.text,
        "address2": controladorTextFieldDireccion2.text,
        "district": controladorTextFieldDistrito.text,
        "city_id": 1.toString(),
        "postal_code": 1.toString(),
        "phone": 4929328.toString(),
        "last_update": dateFormat.format(DateTime.now()),
      }),

    ).then((response) {

    });
  }
  postC() async{
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    http.post(
      "http://10.0.2.2:3000/payment",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': controladorTextFieldNombre.text,
        "last_name": controladorTextFieldApellido.text,
        "email": controladorTextFieldEmail.text,
        "active": 1.toString(),
        "create_date": dateFormat.format(DateTime.now()),
        "last_update": dateFormat.format(DateTime.now()),
      }),

    ).then((response) {

    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear cuenta"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          campo("Nombres",controladorTextFieldNombre),
          campo("Apellidos",controladorTextFieldApellido),
          campo("Email",controladorTextFieldEmail),
          Text("Direccion"),
          campo("Direccion",controladorTextFieldDireccion),
          campo("Direccion 2",controladorTextFieldDireccion2),
          campo("Distrito",controladorTextFieldDistrito),
          RaisedButton(
            color: Colors.green,
              onPressed: (){
                postA();
                postC();
              },
              child:Text("Registrar")
          )
        ],
      ),
    );
  }
  Widget campo(String texto,TextEditingController controlador){
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width:80,child: Text(texto)),
          SizedBox(//Sizedbox necesario si se quiere utilizar el input decorator
            width: 200,
            child: TextField(
              controller: controlador,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
