import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app_tienda_videos/buscador.dart';
import 'package:flutter_app_tienda_videos/crearCuenta.dart';
import 'package:flutter_app_tienda_videos/carrito.dart';
import 'package:flutter_app_tienda_videos/login.dart';
import 'peticiones.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class Galeria extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Secundario();
  }
}

class Secundario extends StatefulWidget {

  @override
  _SecundarioState createState() => _SecundarioState();
}

class _SecundarioState extends State<Secundario> {
  late List estrenos=[];
  late List masRentadas=[];
  late List masRentadasUltimaSemana=[];
  String buscarActorPelicula = 'Actor';

  getPeliculasEstrenos() async {
    print("PeliculasEstrenos");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/estrenos", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
        setState(() {
          estrenos=(json.decode(response.body));
        });
        print(estrenos);
    });
  }
  getMasRentadasTodosLosTiempos() async {
    print("getMasRentadasTodosLosTiempos");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/masRentadasTodosLosTiempos", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      setState(() {//en widget build si tiene set state un metodo que se llama desde ahi se llama muchas veces, por eso solo esta en el init state para que se llame una sola vez
        masRentadas=(json.decode(response.body));
      });
      print(masRentadas);
    });
  }
  getMasRentadasUltimaSemana() async {
    print("getMasRentadasUltimaSemana");
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/masRentadasUltimaSemana/2021-11-25&2021-12-02", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      setState(() {
        masRentadasUltimaSemana=(json.decode(response.body));
      });
      print(masRentadasUltimaSemana);
    });
  }
  putAgregarPeliculaCarrito(int id) async{
    print("putAgregarPeliculaCarrito");
    http.post(
      "http://10.0.2.2:3000/cart/"+id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      /*(No sirve) body: {
          "title": "Tarea flutter",
          "detail": "Detalle de la tarea creada desde flutter",
          "state":"pending"}*/
    ).then((response){

    });
  }
  @override
  final ScrollController controlador= ScrollController();
  final controladorTextField = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getPeliculasEstrenos();
    getMasRentadasTodosLosTiempos();
    getMasRentadasUltimaSemana();
    super.initState();
  }
  void dispose() {
    controladorTextField.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {

    final size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Galeria"),
        backgroundColor: Colors.green,
        actions: <Widget>[ppm()],
      ),
      body: SizedBox(
        width: size.width,
        child: ListView(
          children: [
            Container(
              height: 80,
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>Buscador(controladorTextField.text,buscarActorPelicula)));
                      },
                      icon: Icon(Icons.search)
                  ),
                  SizedBox(//Sizedbox necesario si se quiere utilizar el input decorator
                    width: 250,
                    child: TextField(
                      controller: controladorTextField,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                    ),
                  ),
                  /*DropdownButton<String>(
                      value: buscarActorPelicula,
                      items: [
                        DropdownMenuItem(
                          child: Text("No seleccionado"),
                          value: "No seleccionado",
                        ),
                        DropdownMenuItem(
                          child: Text("Titulo"),
                          value: "Titulo",
                        ),
                        DropdownMenuItem(
                          child: Text("Actor"),
                          value: "Actor",
                        ),
                      ],
                      onChanged: (valor){
                        setState(() {
                          buscarActorPelicula=valor.toString();
                        });
                      },
                  )*/
                ],
              ),
            ),
            DropdownButton<String>(
              value: buscarActorPelicula,
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  buscarActorPelicula = newValue!;
                });
              },
              items: <String>[ 'Actor', 'Pelicula']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),),
            Text("Alquila tu pelicula favorita"),
            Text("Estrenos"),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: (estrenos.length>0)?Swiper(
                layout: SwiperLayout.STACK,//necesita su item width
                itemHeight: size.height*0.5,
                itemWidth: size.width*0.7,
                itemBuilder: (BuildContext context,int index){
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        child:Column(
                          children: [
                            Text(estrenos[index]["title"]),
                            Text("Año de estreno "+estrenos[index]["release_year"].toString()),
                            RaisedButton(
                              onPressed: (){
                                putAgregarPeliculaCarrito(estrenos[index]["inventory_id"]);
                              },
                              child: Text("Rentar"),
                            )
                          ]
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue
                        ),
                      )
                  );
                },
                itemCount: estrenos.length,
                //pagination: new SwiperPagination(),//puntitos de elementos
                //control: new SwiperControl(),//flechas de desplazamiento
              ):Text("No hay estrenos"),
            ),
            Text("La mas rentadas en la ultima semana"),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: (masRentadasUltimaSemana.length>0)?Swiper(
                layout: SwiperLayout.STACK,//necesita su item width
                itemHeight: size.height*0.5,
                itemWidth: size.width*0.7,
                itemBuilder: (BuildContext context,int index){
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue
                        ),
                        child: Column(
                          children: [
                            Text(masRentadasUltimaSemana[index]["title"]),
                            Text("rentas "+masRentadasUltimaSemana[index]["rentas"].toString()),
                            RaisedButton(
                              onPressed: (){
                                putAgregarPeliculaCarrito(masRentadasUltimaSemana[index]["inventory_id"]);
                              },
                              child: Text("Rentar"),
                            )

                          ],
                        ),
                      )
                  );
                },
                itemCount: masRentadasUltimaSemana.length,
                //pagination: new SwiperPagination(),//puntitos de elementos
                //control: new SwiperControl(),//flechas de desplazamiento
              ):Text("No hay peliculas rentadas en la ultima semana"),
            ),
            Text("La mas rentada en todos lo tiempos"),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: (masRentadas.length>0)?Swiper(
                layout: SwiperLayout.STACK,//necesita su item width
                itemHeight: size.height*0.5,
                itemWidth: size.width*0.7,
                itemBuilder: (BuildContext context,int index){
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue
                        ),
                        child: Column(
                          children: [
                            Text(masRentadas[index]["title"]),
                            Text("rentas "+masRentadas[index]["rentas"].toString()),
                            RaisedButton(
                              onPressed: (){
                                putAgregarPeliculaCarrito(masRentadas[index]["inventory_id"]);
                              },
                              child: Text("Rentar"),
                            )
                          ],
                        ),
                      )
                  );
                },
                itemCount: masRentadas.length,
                //pagination: new SwiperPagination(),//puntitos de elementos
                //control: new SwiperControl(),//flechas de desplazamiento
              ):Text("No hay rentas"),
            ),
          ],
        ),
      ),
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
              //
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
                  double d3 = d1-d2;
                  aux = operacion('$d1  -   $d2', d3);
                }*/
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Carrito()));
                break;
            }
          });
        },
        itemBuilder: (context){
          return [
            PopupMenuItem(child: Text('Ingresar'), value: 1,),
            PopupMenuItem(child: Text('Crear cuenta'), value: 2,),
            PopupMenuItem(child: Text('Carrito'), value: 3,),
          ];
        }
    );
  }

}
