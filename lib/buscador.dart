import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app_tienda_videos/login.dart';
import 'package:flutter_app_tienda_videos/crearCuenta.dart';
import 'package:flutter_app_tienda_videos/carrito.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Buscador extends StatelessWidget {
  final String texto;
  final String opcion;

  const Buscador(this.texto,this.opcion, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Secundario(texto,opcion);
  }
}

class Secundario extends StatefulWidget {
  final String texto;
  final String seleccion;
  const Secundario(this.texto,this.seleccion, {Key? key}) : super(key: key);

  @override
  _SecundarioState createState() => _SecundarioState(texto,seleccion);
}

class _SecundarioState extends State<Secundario> {
  @override
  String texto;
  final String seleccion;
  late List estrenos=[];
  late List busquedas=[];
  String buscarActorPelicula = 'Actor';
  _SecundarioState(this.texto,this.seleccion);
  final controladorTextField = TextEditingController();
  late List buscado;
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
  getPeliculasBuscadasActor() async {
    print("getPeliculasBuscadasActor-------------------------------------------------------------------------------");

    texto=texto.replaceAll(" ", "&");
    print(texto);
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/film/actor/"+texto+"&", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      setState(() {
        busquedas=(json.decode(response.body));
      });
      print(busquedas);
    });
  }
  getPeliculasBuscadasPelicula() async {
    print("getPeliculasBuscadasPelicula-------------------------------------------------------------------------------");
    texto=texto.replaceAll(" ", "&");
    print(texto);
    //http.Response response = await http.get("http://10.0.2.2:3000/tasks");
    http.get("http://10.0.2.2:3000/film/title/"+texto+"&", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((response) {
      setState(() {
        busquedas=(json.decode(response.body));
      });
      print(busquedas);
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
  void initState() {
    // TODO: implement initState
    getPeliculasEstrenos();
    if(seleccion=="Actor"){
      getPeliculasBuscadasActor();
    }else{
      getPeliculasBuscadasPelicula();
    }
    super.initState();
  }
  @override
  void dispose() {
    controladorTextField.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tienda de peliculas"),
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
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Buscador(controladorTextField.text,buscarActorPelicula)));
                        },
                        icon: Icon(Icons.search)),
                    SizedBox(
                      //Sizedbox necesario si se quiere utilizar el input decorator
                      width: 250,
                      child: TextField(
                        controller: controladorTextField,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Search',
                        ),
                      ),
                    ),
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
              Text("Peliculas encontradas"),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: (busquedas.length>0)?Swiper(
                  layout: SwiperLayout.STACK, //necesita su item width
                  itemHeight: size.height * 0.5,
                  itemWidth: size.width * 0.7,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.blue),
                          child:Column(
                              children: [
                                Text(busquedas[index]["title"]),
                                Text("Año de estreno "+busquedas[index]["release_year"].toString()),
                                RaisedButton(
                                  onPressed: (){
                                    putAgregarPeliculaCarrito(busquedas[index]["inventory_id"]);
                                  },
                                  child: Text("Rentar"),
                                )
                              ]
                          ),
                        ));
                  },
                  itemCount: busquedas.length,
                  //pagination: new SwiperPagination(),//puntitos de elementos
                  //control: new SwiperControl(),//flechas de desplazamiento
                ):Text("No se encontraron peliculas"),
              ),
              Text("Estrenos"),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: (estrenos.length>0)?Swiper(
                  layout: SwiperLayout.STACK, //necesita su item width
                  itemHeight: size.height * 0.5,
                  itemWidth: size.width * 0.7,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.blue),
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
                        ));
                  },
                  itemCount: estrenos.length,
                  //pagination: new SwiperPagination(),//puntitos de elementos
                  //control: new SwiperControl(),//flechas de desplazamiento
                ):Text("No se encontraron estrenos"),
              ),
            ],
          ),
        )
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
