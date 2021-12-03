// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
