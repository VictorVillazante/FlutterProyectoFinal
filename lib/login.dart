import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final controladorTextFieldUsuario = TextEditingController();
  final controladorTextFieldPassword = TextEditingController();
  late List datosUsuario=[];
  getDatosLogin(correo) async {
    print("getDatosLogin");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/customer/email/"+correo.toString(), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      print(response);
      datosUsuario=(json.decode(response.body));
      if(datosUsuario.length>0){
        print("guardar usuario en localstorage");
      }else{
        print("Usuario no identificado");
      }
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear cuenta"),
      ),
      body: Column(
        children: [
          campo("Usuario",controladorTextFieldUsuario,0),
          campo("Password",controladorTextFieldPassword,1),
          RaisedButton(
              onPressed: (){
                getDatosLogin(controladorTextFieldUsuario.text);
              },
              child:Text("Ingresar")
          )
        ],
      ),
    );
  }
  Widget campo(String texto,TextEditingController controlador,int ocultar){
    return Row(
      children: [
        Text(texto),
        SizedBox(//Sizedbox necesario si se quiere utilizar el input decorator
          width: 300,
          child: TextField(
            controller: controlador,
            obscureText: (ocultar==1)?true:false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
