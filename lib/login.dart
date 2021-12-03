import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  String usuario="";
  int idUsuario=1;
  getData()async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    setState(() {
      usuario=preferences.getString("usuario")!;
      idUsuario=preferences.getInt("idUsuario")!;
    });
  }
  final controladorTextFieldUsuario = TextEditingController();
  final controladorTextFieldPassword = TextEditingController();
  late List datosUsuario=[];
  getDatosLogin(correo) async {
    print("getDatosLogin");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/customer/email/"+correo.toString(), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) async {
      print(response);
      datosUsuario=(json.decode(response.body));
      print(datosUsuario);
      if(datosUsuario.length>0){
        print("guardar usuario en localstorage");
        SharedPreferences preferences= await SharedPreferences.getInstance();
        preferences.setString("usuario", datosUsuario[0]["first_name"]+" "+datosUsuario[0]["last_name"]);
        preferences.setString("idUsuario", datosUsuario[0]["customer_id"].toString());
      }else{
        print("Usuario no identificado");
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear cuenta"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              campo("Usuario",controladorTextFieldUsuario,0),
              SizedBox(height: 20,),
              campo("Password",controladorTextFieldPassword,1),
              SizedBox(height: 20,),
              RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    getDatosLogin(controladorTextFieldUsuario.text);
                  },
                  child:Text("Ingresar")
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget campo(String texto,TextEditingController controlador,int ocultar){
    return Row(
      children: [
        Container(width:80,child: Text(texto)),
        SizedBox(//Sizedbox necesario si se quiere utilizar el input decorator
          width: 200,
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
